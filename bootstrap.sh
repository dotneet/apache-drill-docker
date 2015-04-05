#!/bin/bash

erb core-site.xml.erb > /opt/drill/conf/core-site.xml
echo $ZOOKEEPER_SERVER_ID > /var/lib/zookeeper/myid

while true; do sleep 10000; done

