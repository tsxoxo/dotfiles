#!/usr/bin/env bash

# Check integrity of dotfiles.
# Do all dirs map to an entry?
# Do all entries map to a dir?
# Are all entries valid?

# SETUP
set -u
WRONG_ARGS=85
# For testing
# ENTRIES="./test_entries.conf"
ENTRIES="./entries.db"
# \033 is equivalent to \e but more portable
# the "0;" resets all previous styles
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m' # No Styles

usage() {
  # echo "> ./setup.sh <FILEPATH> <DIRNAME>"
  # echo "FILE will live under dotfiles/DIRNAME/some-config-file and be symlinked to FILEPATH."
  echo "Util for checking integrity of dotfiles."
  echo "USAGE: $0"
}
log_err() {
  echo -e "${RED}${BOLD}ERROR:\t${RED}$1${RESET}" >&2
}
log_warn() {
  echo -e "${YELLOW}${BOLD}WARN:\t${YELLOW}$1${RESET}"
}
log_ok() {
  echo -e "${GREEN}${BOLD}OK:\t${GREEN}$1${RESET}"
}
log() {
  msg="${1-'no message in log()'}"
  indent_level="${2-0}"
  indent=""

  for ((i = 1; i <= "$indent_level"; i++)); do
    indent="${indent}---"
  done

  echo -e "${indent}> ${msg}"
}
separate() {
  echo -e "--------------------------"
}

if [[ $# -gt 0 ]]; then
  echo "Unexpected argument."
  usage
  exit $WRONG_ARGS
fi

# Does each dir map to an entry?
for dotfile_dir in ./*; do
  # Skip dirs
  [[ ! -d "$dotfile_dir" ]] && continue

  dirname=${dotfile_dir#*/}
  log "Checking dir ${BOLD}$dirname${RESET}"

  # Search for dirname in entries, skipping comments.
  # Desired state: one unique entry.
  entries_in_db=$(grep -v "^#" "${ENTRIES}" | grep -i "${dirname}")

  # Fail: empty match.
  # Discard this before counting, as wc counts "" as 1 line.
  if [[ -z "$entries_in_db" ]]; then
    log_err "Found no entry."
    separate
    continue
  else
    num_of_entries=$(echo "${entries_in_db}" | wc -l)
    trimmed_num_of_entries=${num_of_entries#"${num_of_entries%%[![:space:]]}"}
  fi

  # Fail: More than 1 match
  if [[ "$trimmed_num_of_entries" -ne 1 ]]; then
    log_err "Found more than 1 entry (${trimmed_num_of_entries}):\n${entries_in_db}"
    separate
    continue
  fi

  # OK: 1 match.
  log_ok "Found unique entry."

  # Parse the entry for this dotfile dir
  IFS=":" read -r id backlink <<<"$entries_in_db"

  # Check if entry is well-formatted
  [[ "$id" != "$dirname" ]] && log_err "Dir name in DB \"${id}\" does not match existing dir name."

  # Check health of backlink. It should:
  # * it should exist
  target=$(readlink -f "${backlink}") || {
    log_err "Something is wrong with this backlink:\n\t${backlink}\n\tCheck if it exists and is a link."
    separate
    continue
  }

  # * if backlink is a dir, it should point to dotfile_dir
  if [[ -d "$backlink" ]]; then
    dotfile_dir_abs=$(readlink -f "${dotfile_dir}")
    if [[ "${target}" == "${dotfile_dir_abs}" ]]; then
      log_ok "Backlink points to right dotfile dir."
    else
      # echo -e "file:\t${dotfile_dir}"
      # echo -e "target:\t${target}"
      # echo -e "file_abs:\t${dotfile_dir_abs}"
      log_err "Backlink points to wrong target: ${target}."
      separate
      continue
    fi
  elif [[ -f "$backlink" ]]; then
    # * if it's a file, it should point to dotfile_dir/file_name
    expected_target=$(readlink -f "${dotfile_dir}")/$(basename "${backlink}")
    if [[ "${target}" == "${expected_target}" ]]; then
      log_ok "Backlink points to right dotfile."
    else
      log_err "Backlink points to wrong target: ${target}."
      separate
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

  separate
done
# Do all entries map to a dir?
# Are all entries valid?
