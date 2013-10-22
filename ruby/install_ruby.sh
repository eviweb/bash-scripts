#!/bin/bash
[[ -n `which ruby` ]] && exit 0
[[ -z `which curl` ]] && sudo apt-get update && sudo apt-get install curl
BACKUP_DIR=`pwd`
cd $HOME
\curl -L https://get.rvm.io | bash -s stable
source $HOME/.rvm/scripts/rvm
rvm requirements
rvm install 1.9.3
rvm use 1.9.3 --default
rvm rubygems current
echo "Don't forget to run 'source ~/.bashrc' to reload your shell config"
