#!/bin/bash

PKGS="pcre gmp fftw mpfr unwind blas lapack arpack suitesparse"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo pacman --noconfirm -S $PKG
done