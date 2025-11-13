#!/bin/bash

set -eou pipefail

debug=false

# process command line flags
while (( $# > 0 )); do
    case "${1}" in
        -d)
            debug=true
            ;;
    esac

    shift
done

# discover script directory from base name of this install script
full_script_name="$(readlink -f $0)"
if [[ "${debug}" == "true" ]]; then
    echo "full script name: ${full_script_name}"
fi
full_script_directory="${full_script_name%/*}"
if [[ "${debug}" == "true" ]]; then
    echo "full script directory: ${full_script_directory}"
fi
if [[ -z "${full_script_directory}" ]]; then
    echo "Unable to determine directory containing this script" 1>&2
    exit 2
fi

# find git root directory using the assumption that ${script_directory}/.. is git root directory
git_root_directory="$(readlink -f "${full_script_directory}/..")"
if [[ "${debug}" == "true" ]]; then
    echo "git root directory: ${git_root_directory}"
fi
if [[ -z "${git_root_directory}" ]]; then
    echo "Unable to determine git root directory" 1>&2
    exit 3
fi
if [[ ! -d "${git_root_directory}/.git" ]]; then
    echo "Unable to find .git directory in your git root directory" 1>&2
    exit 4
fi
echo "Looks like your git root is: ${git_root_directory}"
git_hooks_directory="${git_root_directory}/.git/hooks"
if [[ ! -d "${git_hooks_directory}" ]]; then
    echo "Unable to access the git hooks directory" 1>&2
    exit 5
fi

# filter for files that:
#   (1) do not end in .sh
#   (2) are not directories
#
# fail if there already exists a git hook at any of the locations we plan to install to
declare -a source_hooks=()
declare -a destination_hooks=()
for script in "${full_script_directory}"/*; do
    # git hooks aren't directories and don't end in .sh so this must be the install script (or something else)
    if [[ -d "${script}" ]] || [[ "${script}" == *.sh ]]; then
        continue
    fi
    
    script_base_name="${script##*/}"
    script_destination_path="${git_hooks_directory}/${script_base_name}"
    if [[ -e "${script_destination_path}" ]]; then
        echo "${script_destination_path} already exists. Cannot install ${script} at that path." 1>&2
        echo "Please manually remove the existing git hook if you want to overwrite!" 1>&2
        exit 6
    fi

    source_hooks+=("${script}")
    destination_hooks+=("${script_destination_path}")
done

# check length of source_hooks and destination_hooks is same
if (( ${#source_hooks[@]} != ${#destination_hooks[@]} )); then
    echo "Error constructing list of scripts" 1>&2
    exit 7
fi

# create links
for (( i = 0; i < ${#source_hooks[@]}; i++ )); do
    ln "${source_hooks[$i]}" "${destination_hooks[$i]}"
    echo "Installed ${source_hooks[$i]} as ${destination_hooks[$i]} by creating a link."
done
