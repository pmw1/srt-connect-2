#!/bin/bash
sudo docker rm -f obe-rt
<<<<<<< HEAD
sudo docker run --name="obe-rt" --network="split" --ip="10.0.10.2" -v /home/pmw/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d --device /dev/blackmagic/io0 pmw1/obe-rt 
=======
sudo docker run --name="obe-rt" --network="split" --ip="10.0.10.2" -v /home/kevin/apps/srt-connect-2/hostfiles:/home/hostfiles --privileged -i -t -d --device /dev/blackmagic/io0 pmw1/obe-rt 
>>>>>>> 74db9cf2831c2c545cf263e8806bcdc6edde140e
