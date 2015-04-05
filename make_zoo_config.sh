#!/bin/sh

cat zoo.cfg.tpl
num_of_drills=$1
for i in $(seq 1 $num_of_drills); do
  echo server.${i}=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' drill_$i`:2888:3888
done

