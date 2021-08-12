# Hardware accelerated Docker images based on Ubuntu 20.04 for Jetson family

Nvidia Jetson images are based on Ubuntu 18.04. However, many applications and projects utilizes libraries specific to Ubuntu 20.04. Therefore, this repository provides docker images based on [`ubuntu:focal`](Dockerfile.ros2), that are able to take full advantage of the Jetson hardware (Nano, Xavier NX, Xavier AGX and Xavier TX2). All images come with full CUDA support (passthrough from the host) including TensorRT and VisionWorks.

Furthermore the [script](scripts) folder includes sustem installable run-scripts to quickly iterate the build process.

The following images can be directly pulled from DockerHub without needing to build the containers yourself:

|                                                                                     | L4T Version | Container Tag                                      |
|-------------------------------------------------------------------------------------|:-----------:|----------------------------------------------------|
| [`l4t-ubuntu20-base`](Dockerfile.base)           							                      |   R32.6.1   | `timongentzsch/l4t-ubuntu20-base:latest`           |
|                                                                                     |   R32.5.0   |                                                    |
| [`l4t-ubuntu20-pytorch`](Dockerfile.pytorch)									                      |   R32.6.1   | `timongentzsch/l4t-ubuntu20-pytorch:latest`        |
|                                                                                     |   R32.5.0   |                                                    |
| [`l4t-ubuntu20-ros2`](Dockerfile.ros2)									                            |   R32.6.1   | `timongentzsch/l4t-ubuntu20-ros2:latest`           |
|                                                                                     |   R32.5.0   |                                                    |
| [`l4t-ubuntu20-zedsdk`](Dockerfile.zedsdk) 									                        |   R32.6.1   | `timongentzsch/l4t-ubuntu20-zedsdk:latest`         |
|                                                                                     |   R32.5.0   | 											                             |


> **note:** make sure to run the container on the intended L4T host system. Running on older JetPack releases (e.g. r32.4.4) can cause driver issues, since L4T drivers are passed into the container.

To download and run one of these images, you can use the included run script from the repo:

``` bash
$ scripts/docker_run timongentzsch/l4t-ubuntu20-base:latest
```

For other configurations, below are the instructions to build and test the containers using the included Dockerfiles.

## Docker Default Runtime

To enable access to the CUDA compiler (nvcc) during `docker build` operations, add `"default-runtime": "nvidia"` to your `/etc/docker/daemon.json` configuration file before attempting to build the containers:

``` json
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime": "nvidia"
}
```

You will then want to restart the Docker service or reboot your system before proceeding.

## Build and test the images

To rebuild the containers from a Jetson device running [JetPack 4.5.1](https://developer.nvidia.com/embedded/jetpack) or newer, first clone this repo:

``` bash
$ git clone https://github.com/timongentzsch/Jetson_Ubuntu20_Images.git
$ cd Jetson_Ubuntu20_Images
```

## Work with the provided scripts

You may want to install the provided scripts to build, run and restart containers with the right set of docker flags:

``` bash
$ sudo scripts/install-scripts.sh
```

This will enable you to quickly iterate your build process and application.

After that you can use following commands globally:

`docker_build`, `docker_run`, `docker_start`

It ensures that the docker environment feels as native as possible by enabling the following features by default:
- USB hot plug
- sound
- network
- bluetooth
- GPU
- X11

> **note:** refer to `--help` for the syntax
