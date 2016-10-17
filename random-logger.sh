#! /bin/bash

set -o verbose

export SYS_MONITOR_DIRECTORY="/tmp/sys-monitor"

sudo DEBIAN_FRONTEND=noninteractive apt-get install python-psutil --yes
sudo DEBIAN_FRONTEND=noninteractive apt-get install git --yes


if [ ! -d "$SYS_MONITOR_DIRECTORY" ]; then
	cd /tmp
        git clone https://github.com/ganeshs-ezdi/sys-monitor.git            
fi	

cd $SYS_MONITOR_DIRECTORY
git pull

echo 'time, size' > throughput.csv

nohup ./run-interval.sh >> throughput.csv &
nohup python monitor.py > monitor.csv 2>&1 &
nohup python random-logger.py >/home/ubuntu/logs/test.log 2>&1 & 

