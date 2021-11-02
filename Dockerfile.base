FROM ubuntu:focal

ARG L4T_RELEASE_MAJOR=32.6
ARG L4T_RELEASE_MINOR=1
ARG CUDA=10.2
ARG DEBIAN_FRONTEND=noninteractive
ARG SOC="t194"

ARG L4T_RELEASE=$L4T_RELEASE_MAJOR.$L4T_RELEASE_MINOR

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils software-properties-common && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

#
# Jetson debian packages
#
RUN echo $L4T_RELEASE_MAJOR
ADD --chown=root:root https://repo.download.nvidia.com/jetson/jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
RUN chmod 644 /etc/apt/trusted.gpg.d/jetson-ota-public.asc && \
    apt-get update && apt-get install -y --no-install-recommends ca-certificates && \
    echo "deb https://repo.download.nvidia.com/jetson/common r$L4T_RELEASE_MAJOR main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    echo "deb https://repo.download.nvidia.com/jetson/${SOC} r$L4T_RELEASE_MAJOR main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

#
# Tegra setup
#
RUN apt-get update && \
    apt-get install -y libglu1-mesa-dev freeglut3 freeglut3-dev unzip dialog && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf && \
    echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf
RUN rm /usr/share/glvnd/egl_vendor.d/50_mesa.json
RUN mkdir -p /usr/share/glvnd/egl_vendor.d/ && \
    echo '{"file_format_version" : "1.0.0" , "ICD" : { "library_path" : "libEGL_nvidia.so.0" }}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json
RUN mkdir -p /usr/share/egl/egl_external_platform.d/ && \
    echo '{"file_format_version" : "1.0.0" , "ICD" : { "library_path" : "libnvidia-egl-wayland.so.1" }}' > /usr/share/egl/egl_external_platform.d/nvidia_wayland.json
RUN echo "/usr/local/cuda-$CUDA/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf

RUN ldconfig

#
# Update environment
#
ENV PATH /usr/local/cuda-$CUDA/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda-$CUDA/targets/aarch64-linux/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/opt/nvidia/vpi1/lib64:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra-egl:${LD_LIBRARY_PATH}

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV OPENBLAS_CORETYPE=ARMV8

WORKDIR /root
CMD ["bash"]
