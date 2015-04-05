#!/bin/bash

num_of_drills=$1
container_name=$2

for i in $(seq 1 $num_of_drills); do
  docker run -d --name drill_$i \
             -e "ZOOKEEPER_SERVER_ID=$i" \
             -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
             -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
             $container_name
done

zooconf=$(mktemp)
./make_zoo_config.sh $num_of_drills > $zooconf

drillconf=$(mktemp)
./make_drill_config.sh $num_of_drills > $drillconf

for i in $(seq 1 $num_of_drills); do
  docker exec -i drill_$i /bin/bash -c 'cat > /etc/zookeeper/conf/zoo.cfg' < $zooconf
  docker exec -i drill_$i /bin/bash -c 'cat > /opt/drill/conf/drill-override.conf' < $drillconf
done

sleep 3

for i in $(seq 1 $num_of_drills); do
  docker exec -i drill_$i /etc/init.d/zookeeper-server start
done

for i in $(seq 1 $num_of_drills); do
  docker exec -i drill_$i ./bin/drillbit.sh start
done

