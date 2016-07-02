#!/bin/bash

export PATH=$PATH:"/usr/local/bin"
export NODE_PATH="/home/nate/.npm-global/lib/node_modules"
node /home/nate/bin/fetch_stars.js "$@"
