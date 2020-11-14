#!/bin/bash
jdk=`ls jdk_use|head -n 1`
tempjdkpath=`tar -tf jdk_use/$jdk | head -n 1`
jdkpath=${tempjdkpath%/*}
echo "jdk=$jdk" > .env
echo "jdkpath=$jdkpath" >> .env
docker-compose build 
echo $jdk
echo $jdkpath
