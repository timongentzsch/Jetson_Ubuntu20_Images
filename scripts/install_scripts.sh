#!/bin/bash
cd "$(dirname "$0")"

# remove legacy
sudo rm -f /usr/bin/docker_run /usr/bin/docker_build /usr/bin/docker_start 

sudo cp dbuild /usr/bin/
sudo cp drun /usr/bin/
sudo cp dstart /usr/bin/
