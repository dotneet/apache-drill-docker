#!/bin/sh

num_of_drills=$1
zkhosts=
#"172.17.0.49:2181,172.17.0.50:2181"
for i in $(seq 1 $num_of_drills); do
  if [ "$zkhosts" != "" ];then
    zkhosts=${zkhosts},
  fi
  ipstr=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' drill_$i`
  zkhosts=${zkhosts}${ipstr}:2181
done

zkrow="zk.connect: \\\"${zkhosts}\\\","

awkscript='/ZKCONNECT/{ $1 = "'${zkrow}'"; } //'
cat drill-override.conf | awk "${awkscript}"

