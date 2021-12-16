FROM python:3.8

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# Tell nvidia-docker the driver spec that we need as well as to
# use all available devices, which are mounted at /usr/local/nvidia.
# The LABEL supports an older version of nvidia-docker, the env
# variables a newer one.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN apt-get update --fix-missing && apt-get install -y \
 gettext-base && \
 rm -rf /var/lib/apt/lists/*

WORKDIR /stage/

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN python -m nltk.downloader stopwords
RUN python -m nltk.downloader punkt
COPY commaqa/ commaqa/

CMD ["/bin/bash"]