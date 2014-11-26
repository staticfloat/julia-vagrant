#!/bin/bash

PKGS="pcre gmp fftw mpfr libunwind blas lapack suitesparse git gcc-fortran cmake"

for PKG in $PKGS; do
    echo "Installing $PKG"
    sudo pacman --noconfirm -S $PKG
done

echo "Done installing packages"