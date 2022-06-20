#!/bin/bash

mkdir $HOME/src && tar -xf Front-User-master.tar.gz -C $HOME/src
cd $HOME/src/front-user && yarn install 2> error.log
cd shared && yarn install 2> error.log && yarn build 2> error.log
cd ../ui-kit && yarn install 2> error.log && yarn build 2> error.log
cd ../front && yarn install 2> error.log && yarn build 2> error.log

cd $HOME/src && if ! docker build . -t front-user-app; then
    ./mailscript.sh "error" "error creating docker image" front-user/error.log 
    echo "error mail was sent"
elif ! docker run -p 49160:8080 -d node-web-app; then
    ./mailscript.sh "error" "error creating docker container" front-user/error.log
    echo "error mail was sent"
else
    ./mailscript.sh "success" "application was built successfully"
    echo "success mail was sent"
    ansible-playbook playbook.yml
fi


