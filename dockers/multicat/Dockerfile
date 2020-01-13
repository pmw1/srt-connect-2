FROM ubuntu:16.04
USER root
WORKDIR /
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y git nload vim build-essential automake

RUN git clone http://github.com/videolan/multicat.git
RUN git clone git://git.videolan.org/bitstream.git
RUN git clone https://github.com/sleinen/samplicator.git

WORKDIR /bitstream
RUN make install

WORKDIR /multicat
RUN make
RUN make install

WORKDIR /samplicator
RUN ./autogen.sh	
RUN ./configure
RUN make
RUN make install



WORKDIR /hostfiles





