#!/usr/bin/env bash
# shellcheck enable=all
# shellcheck enable=check-unassigned-uppercase

set -u # Error on undefined variables

# TODO:
# * cleanup trap in case of failure
#
#
# USAGE
#
### Add new to dotfiles
# > ./dotfile.sh --add <PATH_TO_FILE>
# OR --add <PATH_TO_FILE_OR_DIR>
#
# This copies a file to . and creates a symlink in original location.
# It possibly creates an entry in a "db" for easier reference when removing.
#
### Remove from dotfiles
# > ./dotfile.sh --remove <PATH? ID?>
#
# This moves the dotfile back to its original location.
# And possibly removes it from the db.
#

# \033 is equivalent to \e but more portable
# the "0;" resets all previous styles
RED='\033[0;31m'
RESET='\033[0m' # No Color

BOLD='\033[1m'

usage() {
  # echo "> ./setup.sh <FILEPATH> <DIRNAME>"
  # echo "FILE will live under dotfiles/DIRNAME/some-config-file and be symlinked to FILEPATH."
  echo "USAGE: $0 --check [<config_id> | all]"
}

print_error() {
  echo -e "${RED}${BOLD}ERROR: ${RED}$1${RESET}"
}

# Checks if each dotfile has a proper entry in config file
check_health_dotfile_has_config_entry() {
  true
  # for each file in DOTFILES
  # if file is dir then
  # check if dirname is in config (and unique?)
  # -> custom parse? use grep?
  # throw error 'not in config'
  # -> give option: 'add to config?'
  # throw error: 'not unique'
  # -> give option: 'remove a/b?'
}

# Checks if config entry maps to a dotfile
check_health_config_entry_has_dotfile() {
  true
  # while read -r og_path dotfiles_dir
  # if og_path is file then
  # there should be dotfiles_dir/basename og_path
  # if og_path is dir then
  # there should be dotfiles_dir
  # if og_path does not exist then throw
}

# Checks if dotfile is linked to from original location
check_health_links() {
  true
  # while read -r og_path dotfiles_dir < CONFIG
  # if path is file then
  # readlink path should = dotfiles_dir/$(basename og_path)
  # if file exists but is not link, offer user to check diff
  # if path is dir then
  # readlink path should = dotfiles_dir
}

# Takes path, checks if file or dir
function check_dir() {
  if [ -d "$1" ]; then
    echo "Path is a dir"
  elif [[ -r $1 ]]; then
    echo "Path is a file"
  else
    echo "Error while reading \"${1}\"."
    echo "Expected path to file or dir."
    exit 1
  fi
}

DB="./test_entries.conf"

parse_args() {
  if [[ $# -lt 1 ]]; then
    {
      print_error "Wrong number of arguments."
      usage
      exit 1
    } 1>&2
  fi

  case $1 in
  "add") echo "want add" ;;
  "remove") echo "want remove" ;;
  "check")
    shift

    if [[ $# -lt 1 ]]; then
      {
        print_error "The \"--check\" option expects at least 1 argument."
        usage
        exit 1
      } 1>&2
    fi

    if [[ "$1" == "all" ]]; then
      echo "alllll"
    else
      for arg in "$@"; do
        # arg -> is db_entry unique? throw and print lines or proceed -> exit 1 | entry
        local entries_in_db
        entries_in_db=$(grep -i "${arg}" "${DB}")
        if [[ -z "$entries_in_db" ]]; then
          echo "no entries for ${arg}"
          continue
        fi

        num_of_entries=$(wc -l <<<"$entries_in_db")
        local trimmed_num_of_entries=${num_of_entries#"${num_of_entries%%[![:space:]]}"}

        case "${trimmed_num_of_entries}" in
        "1")
          echo "GOOD: found 1 match for ${arg}"
          while IFS="|" read -r backlink id; do
            # filter out comments.
            if [[ "${backlink:0:1}" == "#" ]]; then
              echo "comment!!!"
              continue
            fi

            echo "backlink: ${backlink}"

            # Check if id is composed of valid chars.
            if [[ ! "${id}" =~ /[a-zA-Z0-9_-]/ ]]; then
              {
                print_error "Expected id to only contain /[a-zA-Z0-9_-]/. Instead got:"
                echo "\"${id}\""
              } >&2
            fi
            if target=$(readlink "${backlink}"); then
              echo "target: $target"
              if [[ -r "${target}" ]]; then
                echo "backlink exists and is readable!"
              fi
            fi

          done <<<"$entries_in_db"
          ;;
        *)
          {
            print_error "Expected 1 entry for ${arg} but found ${trimmed_num_of_entries}:"
            echo "${entries_in_db}"
          } >&2
          ;;
        esac
      done
    fi
    ;;

  *)
    {
      echo "Unknown argument."
      usage
      exit 1
    } 1>&2
    ;;
  esac

}
parse_args "$@"

function get_params_from_config_simple() {
  # DEBUG
  # echo "\$1: $1"
  while IFS='|' read -r filepath dotfiles_dir description; do
    # Filter out comments
    if [ ! "${filepath:0:1}" = "#" ]; then
      # alternative, cringe
      # if [ ! $(echo "$filepath" | cut -c 1) = "#" ]
      echo "$filepath $dotfiles_dir $description"
    fi
  done <"$1"
}

function make_link() {
  # $1 === path to some config to be added to dotfiles
  # $2 === dirname: newfile will be stored under dotfiles/$2
  #
  # ALGO
  # 1. Try copy $1 to dotfiles/$2
  # 1a. Success? (mb `diff oldfile newfile`)
  # 2. IFF success, delete oldfile
  # 4. ln -s dotfiles/$2/newfile $1
  # 5. ???
  # 6. Profit!
  exit 0
}

function confirm() {
  # Probably wanna confirm when
  # * git commit
  # * removing or changing stuff
  #
  # Snippet
  # Read a keypress without hitting ENTER.
  read -s -n1 -p "Hit a key " keypress
  echo
  echo "Keypress was "\"$keypress\""."
}

exit 0
