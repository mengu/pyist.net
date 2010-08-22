#!/usr/bin/env bash

error=0
touch .last_commit

LOCAL_COMMIT=`cat .last_commit`
REMOTE_COMMIT=`git log -n1 --pretty=%H`

DEPLOYMENT_PATH="~/webapps/pyist"

date +"%F %D Script started..."
echo "Pulling from origin..."
git pull origin master
if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
  echo $REMOTE_COMMIT > .last_commit
  echo "Detected new commit. Building..."
  make clean html || error=1
  if [ ! $error ]; then
    echo "Build successful!"
    echo "Copying files..."
    rm -rf $DEPLOYMENT_PATH
    mkdir -p $DEPLOYMENT_PATH
    cp -R build/html/* $DEPLOYMENT_PATH
    mv $DEPLOYMENT_PATH/_static/.htaccess $DEPLOYMENT_PATH/
    echo "Done.";
  else
    echo "Build failed!";
  fi;
else
  echo "No new commits.";
fi

exit $error