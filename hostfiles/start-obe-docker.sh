#!/bin/bash
docker rm -f obe-rt
docker run --name="obe-rt" --network="split" --ip="10.0.10.2" -v /home/pmw/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d --device /dev/blackmagic/io0 pmw1/obe-rt 
