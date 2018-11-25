FROM ubuntu:16.04

EXPOSE 4443
EXPOSE 4444
EXPOSE 3000
EXPOSE 1935

RUN apt-get update && apt-get -y install git pkg-config dh-autoreconf liblua5.2-dev lua5.2 wget libx264-dev libtwolame-dev libasound2-dev wget cmake mercurial gettext flex bison unzip libc++-dev libc++abi-dev

RUN mkdir /data/

WORKDIR /data

#The zip file by default is something stupid with spaces like Blackmagic\ DeckLink\ SDK\ 10.6.1/
#we rename it to DecklinkSDK for ease of use
#ADD Blackmagic_DeckLink_SDK_10.8.3.zip /data/DecklinkSDK
##ADD BlackmagicSDK.zip /data/BlackmagicSDK.zip
RUN wget https://s3.amazonaws.com/files.polarismediaworks.com/BlackmagicSDK.zip
RUN unzip BlackmagicSDK.zip
RUN mv Blackmagic\ DeckLink\ SDK\ 10.11.1 DecklinkSDK/


#Build libdvbpsi from source rather than repo cus we needed latest
WORKDIR /data	
RUN git clone http://git.videolan.org/git/x264.git && cd x264 && \
  ./configure --disable-asm --enable-shared && make -j $(grep -c processor /proc/cpuinfo) && make install && cd .. 


## INSTALL LIBx265
WORKDIR /data
RUN hg clone https://bitbucket.org/multicoreware/x265 && \
cd /data/x265/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/data/lib" -DENABLE_SHARED:bool=on ../../source && \
make && \
make install && \
make clean
WORKDIR /data



##Install Mpeg2
##LIB MPEG2 Decoder
WORKDIR /data
RUN wget http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.0.tar.gz  && \
	tar xvf libmpeg2-0.5.0.tar.gz
WORKDIR /data/libmpeg2-0.5.0
RUN	./configure --enable-shared && make && make install



WORKDIR /data
RUN git clone https://github.com/Arcen/faac.git && cd faac && \
	./bootstrap && ./configure && make -j $(grep -c processor /proc/cpuinfo) && make install



##LIB DVB PSI
WORKDIR /data
RUN git clone https://github.com/mkrufky/libdvbpsi.git && \
    cd libdvbpsi && ./bootstrap && ./configure && make && make install



ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/x265/build/linux:/lib/lib/pkgconfig
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/lib:/lib/lib/pkgconfig:/x265/build/linux:/data/x265/build/linux
RUN ldconfig


##FFMPEG   
RUN git clone https://github.com/FFmpeg/FFmpeg.git && \
    cd FFmpeg && \
    git checkout release/3.4 && \
    ./configure --prefix='/data' --disable-yasm --enable-ffprobe --disable-ffplay --enable-nonfree --enable-libx264 --disable-libx265 --enable-gpl --enable-shared  && \
    make && \
    make install


COPY libDeckLinkAPI.so /data/lib/libDeckLinkAPI.so

RUN apt-get -y install libxcb-shm0-dev libxcb-xv0-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-composite0-dev
 
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/data/FFmpeg/libavcodec:/data/FFmpeg/libavdevice:/data/lib/pkgconfig:/data/lib
ENV export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/lib 
RUN pkg-config --modversion libavcodec
RUN ldconfig

RUN apt-get -y install libqt5x11extras5-dev wayland-protocols

WORKDIR /data
RUN git clone https://github.com/videolan/vlc.git
WORKDIR /data/vlc
RUN git checkout 32ab3f71fbb9fcba0c91ec700dccf9060806f679 .
RUN ./bootstrap
RUN ./configure --disable-qt --disable-a52 --disable-xcb --enable-twolame --enable-dvbpsi --enable-lua --enable-run-as-root --disable-chromecast --enable-x264  --disable-libmpeg2 --enable-decklink --with-decklink-sdk=/data/DecklinkSDK/Linux 
RUN make && make install
RUN rm -rf /data/vlc-3.0
RUN ldconfig

WORKDIR /data
ENTRYPOINT ["/bin/bash", "/data/hostfiles/vlc-play.sh"]
