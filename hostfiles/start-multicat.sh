#!/bin/bash
docker rm -f multicat
docker run -v /home/pmw/apps/srt-connect-2/hostfiles/:/hostfiles --name="multicat" --network="split" --ip="10.0.10.3" --entrypoint="/bin/bash" --privileged -i -t -d pmw1/multicat
echo && echo