#!/bin/sh

# by diversario <ilya.shaisultanov@gmail.com>
#
# This script adds few repos into apt,
# installs CouchDB, Node, npm and log.io
# under ~/local/
#
# If you use it and want to improve it - submit a pull request,
# because I am by no means a shell expert.

cd ~

echo "\033[1;32mAdding more repos\033[0m"
echo 'deb http://archive.ubuntu.com/ubuntu natty multiverse' >> /etc/apt/sources.list
echo 'deb http://archive.canonical.com/ natty partner' >> /etc/apt/sources.list
echo 'deb-src http://archive.ubuntu.com/ubuntu natty multiverse' >> /etc/apt/sources.list

echo "\033[1;32mInstalling ZShell\033[0m"
sudo apt-get update
sudo apt-get -y install zsh git
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
chsh ilya -s /bin/zsh

echo "\033[1;32mInstalling CouchDB, port 5984\033[0m"
echo "\033[1;34mInstalling packages needed for CouchDB build\033[0m"
sudo apt-get -y install make gcc zlib1g-dev libssl-dev libreadline5-dev rake

echo "\033[1;34mCloning Git repo\033[0m"
mkdir -p ~/distros && cd ~/distros
git clone git://github.com/iriscouch/build-couchdb

cd build-couchdb

git submodule init
git submodule update

mkdir -p ~/local/couchdb5984
mkdir -p ~/local/node

cd ~

echo "\033[1;34mBuilding CouchDB\033[0m"
rake -f ~/distros/build-couchdb/Rakefile install=`pwd`/local/couchdb5984
sudo chown couchdb:couchdb -R ~/local/couchdb5984

echo "\033[1;34mSet CouchDB to start on system startup\033[0m"

cd /etc/init.d
sudo ln -s `pwd`/local/couchdb5984/bin/couchdb couchdb5984
sudo update-rc.d couchdb5984 defaults

echo "\033[1;32mInstalling Node\033[0m"

cd ~/distros
git clone git://github.com/joyent/node.git

cd node/
git checkout v0.4.12

./configure --prefix=~/local/node
./configure && make && sudo make install

PATH=$HOME/local/node/bin:$PATH
export PATH

cd ..

git clone git://github.com/isaacs/npm.git

cd npm/

./configure && make && sudo make install

echo 'export PATH=$HOME/local/node/bin:$PATH' >> ~/.bashrc

echo "\033[1;32mInstalling Log.io harvester\033[0m"
sudo npm config set unsafe-perm true
sudo npm install -g --prefix=/usr/local log.io
sudo log.io harvester start

echo "\033[1;32mAll done\033[0m"
echo "\033[1;32mDon't forget to configure Log.io harvester!\033[0m"



