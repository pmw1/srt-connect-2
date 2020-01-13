#!/bin/bash
docker rm -f tscap01
docker run -v /home/pmw/apps/srt-connect-2/hostfiles/:/hostfiles -v /home/pmw/apps/srt-connect-2/captures/:/captures --name="tscap01" --network="split" --ip="10.0.10.4" --entrypoint="/bin/bash" --privileged -i -t -d pmw1/multicat
echo && echo