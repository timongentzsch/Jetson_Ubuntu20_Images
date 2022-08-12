#!/bin/bash
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_PATH=$( echo "$SCRIPT_PATH" | sed 's/ /\\ /g')

if  grep -qxF "# Source jetson docker scripts" "$HOME/.bashrc" ; then
    echo "Already sourcing jetson_docker_scripts"
    echo "Deleting..."
    # get line number
    LINE_NUMBER=$(grep -n "# Source jetson docker scripts" "$HOME/.bashrc" | cut -d: -f1)
    # remove line and line below
    sed -i "${LINE_NUMBER}d" "$HOME/.bashrc"
    sed -i "${LINE_NUMBER}d" "$HOME/.bashrc"
fi

echo "# Source jetson docker scripts" >> $HOME/.bashrc
echo "source $SCRIPT_PATH/jetson_docker_scripts && export DUMMY_SSH_CONFIG="${SCRIPT_PATH}/dummy_root_SSH_config"" >> $HOME/.bashrc
echo "jetson_docker_scripts.bash added to .bashrc"