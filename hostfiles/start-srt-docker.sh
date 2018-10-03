#!/bin/bash
echo
docker rm -f srt-tx
docker run --name="srt-tx" --network="split" --ip="10.0.10.3" -p 4443:4443/udp -p 3000:3000/udp -v /home/kevin/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d pmw1/srt 
