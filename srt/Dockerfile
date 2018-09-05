FROM ubuntu:16.04

USER root

EXPOSE 4443
EXPOSE 4444
EXPOSE 3000

COPY /srt /home/srt

WORKDIR /home/srt

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git tclsh pkg-config cmake libssl-dev build-essential
RUN ./configure
RUN make

RUN apt-get install -y nload


WORKDIR /home/hostfiles
	



CMD ["/bin/bash", "/home/hostfiles/srt-entrypoint.sh"]



