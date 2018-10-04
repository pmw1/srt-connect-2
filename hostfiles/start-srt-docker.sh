#!/bin/bash
<<<<<<< HEAD
sudo docker rm -f srt-rx
sudo docker run --name="srt-rx" --network="split" --ip="10.0.10.4" -p 3000:3000/udp -v /home/pmw/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d --entrypoint="/home/hostfiles/srt-entrypoint.sh" pmw1/srt 
=======
echo
sudo docker rm -f srt-tx
sudo docker run --name="srt-tx" --network="split" --ip="10.0.10.3" -p 4443:4443/udp -p 3000:3000/udp -v /home/kevin/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d pmw1/srt 
>>>>>>> 74db9cf2831c2c545cf263e8806bcdc6edde140e
