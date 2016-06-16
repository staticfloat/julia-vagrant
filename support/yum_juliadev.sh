#!/bin/bash

PKGS="pcre-devel gmp-devel fftw-devel mpfr-devel blas-devel lapack-devel cmake kernel-headers"

for PKG in $PKGS; do
    sudo yum install -y $PKG
done

echo "Done installing packages"
