#!/bin/bash
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_PATH=$( echo "$SCRIPT_PATH" | sed 's/ /\\ /g')

# remove legacy
sudo rm -f /usr/bin/docker_run /usr/bin/docker_build /usr/bin/docker_start
# remove new legacy
sudo rm -f /usr/bin/drun /usr/bin/dbuild /usr/bin/dstart

if  grep -q "source $SCRIPT_PATH/jetson_docker_scripts.bash\n" "$HOME/.bashrc" ; then
    echo "Already sourcing jetson_docker_scripts.bash"
    echo "Skipping..."
else
    echo "source $SCRIPT_PATH/jetson_docker_scripts.bash" >> $HOME/.bashrc
    echo "jetson_docker_scripts.bash added to .bashrc"
fi
