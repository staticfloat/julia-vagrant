#!/bin/bash

sudo add-apt-repository -y ppa:staticfloat/julia-deps
sudo add-apt-repository -y ppa:staticfloat/julianightlies
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install julia

echo "Done installing packages"