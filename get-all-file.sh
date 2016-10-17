#! /bin/bash

BASEDIR=`realpath .`
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DIR=elk-loadtest-files
PEMFILE=~/.keys/cac-int-ops.pem

if [[ -d "$DIR" ]]
then
	# Directory is there remove the all the contents of the directory
	rm -rf elk-loadtest-files/*
else
	mkdir -p elk-loadtest-files
fi

cd $DIR
echo $PWD

for HOST in $*
do
	NUMBER=$(echo $HOST | cut -d'.' -f 4)
	if [[ ! -d "files_$NUMBER" ]]
	then
		mkdir -p files_$NUMBER
	fi

	scp -i $PEMFILE ubuntu@$HOST:/tmp/sys-monitor/{monitor,throughput}.csv files_$NUMBER/.
done

cd ..
echo $PWD
tar -cf elk-loadtest-$TIMESTAMP.tar.gz elk-loadtest-files

echo Done
