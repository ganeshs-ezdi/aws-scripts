#! /bin/bash

PROJECT_TO_RUN=$1
HOST=$2
USERTOLOG="ubuntu"
PEMFILE=~/.keys/cac-int-ops.pem

# remove script name from the arguments
#shift 1

if [[ -z "$1" ]]
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

ssh -i $PEMFILE $USERTOLOG@$HOST "
	SCRIPT_URL=https://github.com/ganeshs-ezdi/aws-scripts.git
	SCRIPT_DIR=$(basename $SCRIPT_URL .git)

	if [ ! -d "$SCRIPT_DIR" ]
	then
		echo Git cloning the URL=$SCRIPT_URL
		git clone $SCRIPT_URL
	fi
	git pull

	cd $SCRIPT_DIR/integration-tests
	echo Working Dir --$PWD--
	PROJECT=$PROJECT_TO_RUN ./runproject.sh
"

echo 'Done'
