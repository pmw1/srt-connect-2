FROM ubuntu:16.04
MAINTAINER Kevin Hurley <kevin@polarismediaworks.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /apps
WORKDIR /apps

# Install Blackmagic dependencies
RUN apt-get update && \
    apt-get install -y libjpeg62 libgl1-mesa-glx libxml2 && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y libc++1 libc++-dev libc++abi-dev wget unzip

# Install Blackmagic libs (not drivers)
COPY libDeckLinkAPI.so /usr/lib/
COPY libDeckLinkPreviewAPI.so /usr/lib/

WORKDIR /apps

# SETUP SDK
RUN wget https://s3.amazonaws.com/files.polarismediaworks.com/BlackmagicSDK.zip
RUN unzip BlackmagicSDK.zip
RUN mv Blackmagic\ DeckLink\ SDK\ 10.11.1 DecklinkSDK/
RUN rm -f BlackmagicSDK.zip


### FFMPEG AND CODEC DEPENDENCIES
RUN apt-get update -qq && apt-get -y install autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libtool libvorbis-dev pkg-config texinfo zlib1g-dev


RUN mkdir -p /apps/ffmpeg_sources /apps/bin


#  INSTALL NASM
WORKDIR /apps/ffmpeg_sources
RUN git clone https://github.com/letolabs/nasm.git
WORKDIR /apps/ffmpeg_sources/nasm
RUN ["/bin/bash", "/apps/ffmpeg_sources/nasm/autogen.sh"]
RUN PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
RUN make
RUN make install


# INSTALL YASM
RUN apt-get install yasm

# INSTALL  LIBX264
RUN apt-get install -y libx264-dev

# INSTALL LIBX265
RUN apt-get install -y libx265-dev libnuma-dev

# INSTALL LIBVPX
RUN apt-get install -y libvpx-dev

# INSTALL LIBFDK-AAC
RUN apt-get install -y libfdk-aac-dev

# INSTALL LIBMP3LAME
RUN apt-get install -y libmp3lame-dev

# INSTALL LIBOPUS 
RUN apt-get install -y libopus-dev

#MOVE LATER
RUN apt-get install -y python

# INSTALL LIBAOM
WORKDIR /apps/ffmpeg_sources
RUN git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom
WORKDIR /apps/ffmpeg_sources/aom_build
RUN PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom
RUN PATH="$HOME/bin:$PATH" make

# INSTALL TURING CODEC
RUN apt-get update
RUN apt-get install -y g++ cmake-curses-gui
WORKDIR /apps/ffmpeg_sources
RUN git clone https://github.com/bbc/turingcodec.git
WORKDIR /apps/ffmpeg_sources/turingcodec
RUN mkdir -p build/debug build/release
WORKDIR /apps/ffmpeg_sources/turingcodec/build/release


# INSTALL FFMPEG (TURING VERSION)
WORKDIR /apps
RUN git clone https://github.com/kupix/FFmpeg-1.git
# rebuild turingcodec to install codec libraries in ffmpeg source directory
WORKDIR /apps/ffmpeg_sources/turingcodec/build/release
RUN cmake -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" ../../
RUN make
WORKDIR /apps/FFmpeg-1
RUN PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:$HOME/FFmpeg-1/libavutil" ./configure \
     --prefix="$HOME/ffmpeg_build"  \
     --pkg-config-flags="--static" \
     --extra-cflags="-I$HOME/ffmpeg_build/include" \
     --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
     --extra-libs="-lpthread -lm" \
     --bindir="$HOME/bin" \
     --enable-gpl \
     --enable-libass \
     --enable-libfdk-aac \
     --enable-libfreetype \
     --enable-libmp3lame \
     --enable-libopus \
     --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree \
      --enable-decklink \
      --extra-cflags="-I$HOME/DecklinkSDK/Linux/include" \
      --extra-ldflags="-L$HOME/DecklinkSDK/Linux/include"


# removed from configure --enable-libaom --enable-libturing
RUN make install
RUN hash -r
ENV PATH="/apps/bin:${PATH}"


# INSTALL BMDTOOLS
WORKDIR /apps
RUN git clone https://github.com/lu-zero/bmdtools.git
WORKDIR /apps/bmdtools

ENV PKG_CONFIG_PATH="${HOME}/FFmpeg-1/libavcodec:${HOME}/FFmpeg-1/libswresample:${HOME}/FFmpeg-1/libavutil/:${HOME}/FFmpeg-1/libavformat:${HOME}/FFmpeg-1/libswscale"
RUN make SDK_PATH=/apps/DecklinkSDK/Linux/include
ENV PATH="/apps/bmdtools:${PATH}"
ENV PATH="/apps/ffmpeg_sources/turingcodec/build/release/turing:${PATH}"

WORKDIR /apps/hostfiles

#ENTRYPOINT /apps/hostfiles/entrypoint.sh


