FROM ubuntu:16.04
MAINTAINER Kevin Hurley <kevin@polarismediaworks.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /tmp
WORKDIR /tmp

# Install Blackmagic dependencies
RUN apt-get update && \
    apt-get install -y libjpeg62 libgl1-mesa-glx libxml2 && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y libc++1 libc++-dev libc++abi-dev

# Install Blackmagic libs (not drivers)
COPY libDeckLinkAPI.so /usr/lib/
COPY libDeckLinkPreviewAPI.so /usr/lib/

