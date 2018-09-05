#!/bin/bash
NAME=obe
screen  -d -m -S $NAME obecli
sleep 2
screen -p 0 -S $NAME -X stuff $"set input decklink\012"
screen -p 0 -S $NAME -X stuff $"set input opts card-idx=0\012"
screen -p 0 -S $NAME -X stuff $"set input opts video-format=1080i59.94\012"
screen -p 0 -S $NAME -X stuff $"set input opts video-connection=sdi\012"
screen -p 0 -S $NAME -X stuff $"set input opts audio-connection=embedded\012"
screen -p 0 -S $NAME -X stuff $"set obe opts system-type=lowestlatency\012"
screen -p 0 -S $NAME -X stuff $"probe input\012"
sleep 2
screen -p 0 -S $NAME -X stuff $"set stream opts 0:pid=1000,threads=6,format=avc,profile=high,level=5.1,aspect-ratio=16:9,intra-refresh=1,bitrate=4000\012"
screen -p 0 -S $NAME -X stuff $"set stream opts 1:pid=1001,bitrate=256,format=aac,aac-profile=aac-lc,aac-encap=latm\012"
screen -p 0 -S $NAME -X stuff $"set muxer opts ts-id=1,program-num=1,pmt-pid=256,ts-type=dvb,cbr=1,ts-muxrate=5000000,pcr-pid=512\012"
screen -p 0 -S $NAME -X stuff $"set stream opts 0:lookahead=5,keyint=30,bframes=1\012"
screen -p 0 -S $NAME -X stuff $"set stream opts 0:bitrate=4000\012"
screen -p 0 -S $NAME -X stuff $"set outputs 1\012"
screen -p 0 -S $NAME -X stuff $"set output opts 0:target=udp://10.0.10.3:4443,type=udp\012"
screen -p 0 -S $NAME -X stuff $"start\012"
screen -r
