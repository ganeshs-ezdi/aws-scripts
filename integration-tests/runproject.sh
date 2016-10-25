#! /bin/bash

# CHECK FOR ENVIRONMENT VARIABLE FOR THE PROJECT TO RUN
PROJECT_TO_RUN=$PROJECT

if [[ -z "$PROJECT_TO_RUN" ]]
then
  echo "Project to run is not specified"
  echo "Please add environment variable PROJECT to specify which project to run."
else
  echo Running --$PROJECT_TO_RUN--
fi

function check_gitclone_or_gitpull()
{
  URL=$1
  DIR=$(basename $URL .git)
  if [[ ! -d "$DIR" ]]
  then
    echo "Git Cloning URL=$URL"
    git clone $URL
  fi
  cd $DIR
  echo "Trying git pull in $DIR"
  git pull
}

function package_installed()
{
  dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -o 'installed'
}

cd /tmp
echo Working directory --$PWD--

# Check for software deps
## Oracle JDK
JAVA_INSTALLED=$(package_installed oracle-java8-installer)

if [[ -z "$JAVA_INSTALLED" ]]
then
  sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:webupd8team/java
  sudo DEBIAN_FRONTEND=noninteractive apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-installer
fi

## Check for maven
MAVEN_INSTALLED=$(package_installed maven)
if [[ -z "$MAVEN_INSTALLED" ]]
then
  sudo DEBIAN_FRONTEND=noninteractive apt-get install maven
fi

## Check for filebeat
FILEBEAT_INSTALLED=$(package_installed filebeat)
if [[ -z "$FILEBEAT_INSTALLED" ]]
then
  echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list
  wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  sudo DEBIAN_FRONTEND=noninteractive apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install filebeat
fi

## Check for git
GIT_INSTALLED=$(package_installed git)
if [[ -z "$GIT_INSTALLED" ]]
then
  sudo DEBIAN_FRONTEND=noninteractive apt-get install git --yes
fi

pushd /tmp
# Check for maven deps -- to be cloned and installed
check_gitclone_or_gitpull https://github.com/Mediscribes/repezCACCore.git
pushd repezCACCore/ezSpringSessionCommon
mvn install

popd
popd

# Runtime deps -- checks for environment variables
# Configurations

# Clone the repo, build and run it
# Execution
# check_gitclone_or_gitpull https://github.com/Mediscribes/repezPaaSPoC.git
cd ../$PROJECT_TO_RUN
mvn spring-boot:run -Drun.jvmArguments="-Dspring.profiles.active=int"
