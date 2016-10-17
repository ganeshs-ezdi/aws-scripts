#! /bin/bash

SCRIPT_NAME="$1"
USERTOLOG="ubuntu"
PEMFILE=~/.keys/cac-int-ops.pem

# remove script name from the arguments
shift 1

if [[ -z "$SCRIPT_NAME" ]]
then
	echo "Please give the script name and the parameters"
	exit 0
fi

# Unable to find pem file
if [[ ! -f "$PEMFILE" ]]
then
	echo "Unable to find pem file"
	echo "PEMFILE=$PEMFILE"
	exit 0
fi

COMMAND=`cat $SCRIPT_NAME`
if [[ -z "$COMMAND" ]]
then
	echo "Unable to read the script"
	exit 0
fi

HOSTS="$*"

for HOST in $HOSTS
do
	echo ''
	echo Executing script on HOST=$HOST
	ssh -i $PEMFILE $USERTOLOG@$HOST "$COMMAND"
	echo ''
done

echo 'Done'

