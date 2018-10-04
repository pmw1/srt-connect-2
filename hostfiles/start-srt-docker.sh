#!/bin/bash
sudo docker rm -f srt-rx
sudo docker run --name="srt-rx" --network="split" --ip="10.0.10.4" -p 3000:3000/udp -v /home/pmw/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d --entrypoint="/home/hostfiles/srt-entrypoint.sh" pmw1/srt 
