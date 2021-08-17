FROM timongentzsch/l4t-ubuntu20-base

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_SOX=1

RUN apt-get update && apt-get install -y --no-install-recommends python3-pip python3-dev libopenblas-dev libjpeg-dev zlib1g-dev sox libsox-dev libsox-fmt-all && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

COPY assets/*whl /root/
RUN pip3 install torch-1.9.0-cp38-cp38-linux_aarch64.whl \
        torchvision-0.10.0a0+300a8a4-cp38-cp38-linux_aarch64.whl \
        torchaudio-0.10.0a0+ee74056-cp38-cp38-linux_aarch64.whl && \
    rm -rf *.whl

ENV PATH=/usr/local/cuda/bin:/usr/local/cuda-10.2/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda-10.2/targets/aarch64-linux/lib:

CMD ["bash"]
WORKDIR /root
