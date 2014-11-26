#!/bin/bash

sudo add-apt-repository -y ppa:staticfloat/julia-deps
sudo apt-get update
sudo apt-get -y upgrade

# These are needed for building .debs
PKGS="build-essential dpkg-dev debhelper dh-exec devscripts python-sphinx python-sphinx-rtd-theme"
# These are needed to build julia herself
PKGS="$PKGS git patchelf gfortran g++ gcc m4 llvm-3.3-dev zlib1g-dev libsuitesparse-dev libopenblas-dev liblapack-dev libarpack2-dev libfftw3-dev libgmp-dev libpcre3-dev libunwind7-dev libunwind8-dev libdouble-conversion-dev libmpfr-dev librmath-julia-dev cmake"
for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo apt-get -y install $PKG
done

echo "Done installing packages"
