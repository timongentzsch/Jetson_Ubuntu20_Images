#!/bin/bash

# load docker completion
_completion_loader docker;

# Usage:
#   docker_alias_completion_wrapper <completion function> <alias/function name>
#
# Example:
#   dock-ip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' $@ ;}
#   docker_alias_completion_wrapper __docker_complete_containers_running dock-ip
function docker_alias_completion_wrapper {
  local completion_function="$1";
  local alias_name="$2";

  local func=$(cat <<EOT
    # Generate a new completion function name
    function _$alias_name() {
        # Start off like _docker()
        local previous_extglob_setting=\$(shopt -p extglob);
        shopt -s extglob;

        # Populate \$cur, \$prev, \$words, \$cword
        _get_comp_words_by_ref -n : cur prev words cword;

        # Declare and execute
        declare -F $completion_function >/dev/null && $completion_function;

        eval "\$previous_extglob_setting";
        return 0;
    };
EOT
  );
  eval "$func";

  # Register the alias completion function
  complete -F _$alias_name $alias_name
}
export -f docker_alias_completion_wrapper

# Check if script is executed on Jetson platform
CUDA_DIRECTORY="/usr/local/cuda-10.2"
IS_JETSON=false

if [[ -d "$CUDA_DIRECTORY" ]]; then
    IS_JETSON=true
fi

#
# Custom docker scripts
#

drun() {
    
    # Allow X11 access
    xhost +si:localuser:root
    
    # Intial variable setup
    DOCKER_CUSTOM_ARGS=$@
    DOCKER_DEFAULT_ARGS=()
    DOCKER_DEFAULT_ARGS+=("-it")
    DOCKER_USER_HOME="/root"

    # Default: Disposable Container
    PERSISTENT_CONTAINER=0

    while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -u|--user)
        DOCKER_USER_HOME="/home/$2"
        echo "Using User $2 with \$HOME=$DOCKER_USER_HOME"
        echo ""
        shift # past argument
        shift # past value
        ;;
        --name)
        PERSISTENT_CONTAINER=1
        CONTAINER_NAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # default
        shift # past argument
        echo $@
        ;;
    esac
    done

    if [[ $PERSISTENT_CONTAINER -eq 0 ]];then
        DOCKER_DEFAULT_ARGS+=("--rm")
        echo "Using disposable container"
        echo ""
    else
        echo "Saivng container under: $CONTAINER_NAME"
        echo ""
    fi
    
    # Map host's display socket to docker
    DOCKER_DEFAULT_ARGS+=("-v /tmp/.X11-unix:/tmp/.X11-unix")
    DOCKER_DEFAULT_ARGS+=("-e DISPLAY")

    # Device and audio passtrough
    DOCKER_DEFAULT_ARGS+=("-e 'TERM=xterm-256color'")
    DOCKER_DEFAULT_ARGS+=("--network host")
    DOCKER_DEFAULT_ARGS+=("-v /dev:/dev")
    DOCKER_DEFAULT_ARGS+=("-v /mnt:/mnt")
    DOCKER_DEFAULT_ARGS+=("-v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket")
    DOCKER_DEFAULT_ARGS+=("-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native")
    DOCKER_DEFAULT_ARGS+=("-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native")
    DOCKER_DEFAULT_ARGS+=("-v ${HOME}/.config/pulse/cookie:$DOCKER_USER_HOME/.config/pulse/cookie")

    # SSH keys
    DOCKER_DEFAULT_ARGS+=("-v ${HOME}/.ssh:$DOCKER_USER_HOME/.ssh")

    # Mount Jetson cuda libs
    if [[ $IS_JETSON = true ]]; then
        DOCKER_DEFAULT_ARGS+=("--gpus all")
        DOCKER_DEFAULT_ARGS+=("-e NVIDIA_DRIVER_CAPABILITIES=all")
        DOCKER_DEFAULT_ARGS+=("-e NVIDIA_VISIBLE_DEVICES=all")
        DOCKER_DEFAULT_ARGS+=("--runtime nvidia")
    fi

    echo "Container initialized with following arguments:"
    echo "docker run "${DOCKER_DEFAULT_ARGS[@]} $DOCKER_CUSTOM_ARGS
    echo ""

    docker run ${DOCKER_DEFAULT_ARGS[@]} $DOCKER_CUSTOM_ARGS ;
    }

# Register completion function
docker_alias_completion_wrapper _docker_container_run_and_create drun

dbuild() {

    DOCKER_BUILD_ARGS=()

    # Map group and user id
    DOCKER_BUILD_ARGS+=("--network host")
    DOCKER_BUILD_ARGS+=("--build-arg USER_ID=$(id -u)")
	DOCKER_BUILD_ARGS+=("--build-arg GROUP_ID=$(id -g)")

    docker build ${DOCKER_BUILD_ARGS[@]} $@ ;
    }

# Register completion function
docker_alias_completion_wrapper _docker_image_build dbuild

# Register completion function
docker_alias_completion_wrapper _docker_container_run_and_create drun

dstart() {

    xhost +si:localuser:root

    docker start -i $@ ;
    }

# Register completion function
docker_alias_completion_wrapper __docker_complete_containers_all dstart
