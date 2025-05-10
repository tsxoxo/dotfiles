#!/usr/bin/env bash

# Check integrity of dotfiles.
# Do all dirs map to an entry?
# Do all entries map to a dir?
# Are all entries valid?

###############################################################################
# SETUP
###############################################################################
HAD_ERR=0
WRONG_ARGS=85
VERBOSE=""
ENTRIES="./entries.db"
# \033 is equivalent to \e but more portable
# the "0;" resets all previous styles
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m' # No Styles

usage() {
  echo -e "
${BOLD}USAGE:${RESET}\t$0 [ -f entries_file ] [ -v ]

\tOptions:
\t-f: specify entries database file (default: $ENTRIES)
\t-v: enable verbose output"
}

log() {
  [[ -z "$VERBOSE" ]] && return
  echo -e "${BLUE}${1}${RESET}"

}
log_err() {
  HAD_ERR=1
  verbose_override=$2
  [[ -z "$VERBOSE" && -z $verbose_override ]] && return
  echo -e "${RED}${BOLD}ERROR${RESET}\t$1" >&2
}
log_warn() {
  [[ -z "$VERBOSE" ]] && return
  echo -e "${YELLOW}${BOLD}WARN${RESET}\t$1"
}
log_ok() {
  [[ -z "$VERBOSE" ]] && return
  echo -e "${GREEN}${BOLD}OK${RESET}\t$1"
}
separate() {
  [[ -z "$VERBOSE" ]] && return
  char="${1--}"
  reps="${2-65}"
  printf -v line "%*s" "$reps" ""
  # Replace all spaces in 'line' with the desired character
  # This is Bash-specific string manipulation: ${variable//pattern/replacement}
  line="${line// /${char}}"
  echo -e "$line"
}

###############################################################################
# MAIN
###############################################################################
# parse args
while [[ -n "$1" ]]; do
  case "$1" in
  -f)
    shift
    if [[ -z "$1" ]]; then
      log_err "-f option expects path to entries db." force
      usage
      exit $WRONG_ARGS
    fi
    if [[ ! -r "$1" ]]; then
      log_err "Could not read $1" force
      usage
      exit $WRONG_ARGS
    fi

    ENTRIES="$1"
    ;;
  "-v")
    VERBOSE=verbose
    ;;
  *)
    log_err "Unexpected argument."
    usage
    exit $WRONG_ARGS
    ;;
  esac
  shift
done

[[ -n "$VERBOSE" ]] && log "${BOLD}>>> CHECK: dirs${RESET}" && separate "-" 26

dir_count=0
for dotfile_dir in ./*; do
  # Skip anything that's not a dir
  [[ ! -d "$dotfile_dir" ]] && continue

  # Print separators
  ((dir_count++))
  [[ -n "$VERBOSE" && $dir_count -gt 1 ]]

  dirname=${dotfile_dir#*/}
  log "${BOLD}> ${dir_count} $dirname${RESET}"

  # Special case: keyboard layouts
  # No DB entry for that.
  # Just check if system dir has identical entry
  if [[ "$dirname" == keyboard ]]; then
    layouts_path="$HOME/Library/Keyboard Layouts"
    for l in "$dotfile_dir"/*; do
      layout=${l##*/}
      if [[ ! -f "$layouts_path/$layout" ]]; then
        log_err "Layout \"${layout%.*}\" not found in system dir:\n\t$layouts_path."
      fi

      if ! cmp --quiet "$l" "$layouts_path/$layout"; then
        log_err "Layout \"${layout%.*}\" differs from file in system dir:\n\t$layouts_path."
      fi

      log_ok "Layout \"${layout%.*}\" found in system dir."
    done

    continue
  fi

  # Special case: macports
  # No DB entry here.
  # Do a simple check to see if our entry is up-to-date
  if [[ "$dirname" == macports ]]; then
    if ! command -v port &>/dev/null; then
      log_err "Macports not installed."
    fi

    if ! cmp --quiet ./macports/requested_packages.txt <(port echo requested); then
      log_err "Stored package list differs from 'port echo requested'"
    fi

    log_ok "Stored package list seems up to date."

    continue
  fi

  # Does dir map to an entry?
  # Search for dirname in entries, skipping comments.
  # Desired state: one unique entry.
  # First, count the lines.
  # (Rationale for grepping multiple times -- once for counting, once for fetching result:
  # using wc -l was hacky and brittle)
  num_entries_in_db=$(grep -v "^#" "${ENTRIES}" | grep -c -- "${dirname}")

  # Discard undesired: empty match or more than 1.
  if [[ "$num_entries_in_db" -eq 0 ]]; then
    log_err "Found no entry."
    continue
  elif [[ "$num_entries_in_db" -gt 1 ]]; then
    log_err "Found ${num_entries_in_db} entries (expected 1):\n$(grep -v "^#" "${ENTRIES}" | grep -- "${dirname}" | sed 's/^/\t\t/')"
    continue
  fi

  # OK: 1 match.
  entry=$(grep -v "^#" "${ENTRIES}" | grep "${dirname}")
  log_ok "Found unique entry."

  # Parse the entry for this dotfile dir
  IFS=":" read -r id backlink <<<"$entry"

  # Check if entry is well-formatted
  [[ "$id" != "$dirname" ]] && log_err "Dir name in DB does not match:\n\t\t${id}"

  # Check health of backlink. It should:
  # * it should exist
  target=$(readlink -f "${backlink}") || {
    log_err "Something is wrong with this backlink:\n\t\t${backlink}\n\tCheck if it exists and is a link."
    continue
  }

  # * if backlink is a dir, it should point to dotfile_dir
  if [[ -d "$backlink" ]]; then
    # Get absolute path.
    expected_target=$(readlink -f "${dotfile_dir}")
    if [[ "${target}" == "${expected_target}" ]]; then
      log_ok "Backlink points to right dotfile dir."
    else
      # echo -e "file:\t${dotfile_dir}"
      # echo -e "target:\t${target}"
      # echo -e "file_abs:\t${dotfile_dir_abs}"
      log_err "Backlink points to wrong target: ${target}."
      continue
    fi
  elif [[ -f "$backlink" ]]; then
    # * if it's a file, it should point to dotfile_dir/file_name
    expected_target=$(readlink -f "${dotfile_dir}")/$(basename "${backlink}")
    if [[ "${target}" == "${expected_target}" ]]; then
      log_ok "Backlink points to right dotfile."
    else
      log_err "Backlink points to wrong target: ${target}."
      continue
    fi

    # Check for unexpected: more than one file in dotfile dir
    shopt -s dotglob
    count=0
    for file in "$dotfile_dir"/*; do
      # safety check against "." and ".."
      test -f "$file" || continue
      ((count += 1))

      if [[ $count -gt 1 ]]; then
        log_warn "Unexpected: more than one file in dotfiles/${dirname}."
        break
      fi

    done
    shopt -u dotglob
  fi

done

echo

# Do all entries map to a dir?
[[ -n "$VERBOSE" ]] && log "${BOLD}>>> CHECK: entries${RESET}" && separate "-" 26

while IFS=":" read -r dir_name link_path; do
  if [[ ! -d ./"$dir_name" ]]; then
    log_err "Did not find ./${dir_name}"
  fi

  log_ok "Entry '${BOLD}${dir_name}${RESET}' matches directory './${dir_name}'."
done < <(grep "^[^#]" "$ENTRIES")

###############################################################################
# CLEANUP
###############################################################################

# Something bad happened along the way
if [[ $HAD_ERR -ne 0 && -z $VERBOSE ]]; then
  log_err "Something went wrong. Run \"$0 -v\" to see errors." force
  exit 90
fi

exit 0

# TODO: bash profiling, cmp vs diff
#
# TODO: stuff in neovim
# * snippets:
# * run different things based on buffer filetype or lsp recognition
# * bash: for loop with files and basename
# * bash: log variable
# * keybind: swith vl= to v=l
#
# TODO: keys
# tmux: simpler pane switch
