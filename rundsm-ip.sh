#!/bin/bash

echo =================================================
echo Run dsm container
echo =================================================

docker run -d -it \
 --name=dsm \
 --env-file=./dsm.env \
 --net mynet \
 --ip 192.168.142.195 \
 -h dsmhost \
 -p 11080:11080 -p 11081:11081 \
 ibm/dsm:v2.1.5
