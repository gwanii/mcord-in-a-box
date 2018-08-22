#!/bin/bash
docker logs -f $(docker ps |grep "$1"|awk '{print $1}')
