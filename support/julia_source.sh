#!/bin/bash

# Grab the sources
git clone https://github.com/JuliaLang/julia.git ~/julia
cd ~/julia

# Grab the submodules, just for fun
git submodule init
git submodule update

if [[ "$(uname -s)" == "Linux" ]]; then
	MAKEOPTS="VERBOSE=1"
	MAKEOPTS="$MAKEOPTS OPENBLAS_DYNAMIC_ARCH=0"
	MAKEOPTS="$MAKEOPTS USE_BLAS64=0"
	MAKEOPTS="$MAKEOPTS USE_SYSTEM_PCRE=1"
	MAKEOPTS="$MAKEOPTS USE_SYSTEM_GMP=1"
	MAKEOPTS="$MAKEOPTS USE_SYSTEM_FFTW=1"
	MAKEOPTS="$MAKEOPTS USE_SYSTEM_MPFR=1"
	MAKEOPTS="$MAKEOPTS USE_SYSTEM_BLAS=1"
	MAKEOPTS="$MAKEOPTS USE_SYSTEM_LAPACK=1"
	MAKEOPTS="$MAKEOPTS LIBBLASNAME=libblas.so.3"
	MAKEOPTS="$MAKEOPTS LIBLAPACKNAME=liblapack.so.3"

	# If we're on ubuntu, these are the packages we can use
	if [[ $(hostname) == ubuntu* ]]; then
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_LIBUNWIND=1"
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_ARPACK=1"
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_GRISU=1"
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_SUITESPARSE=1"
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_RMATH=1"
	fi

	if [[ $(hostname) == arch* ]]; then
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_LIBUNWIND=1"
		MAKEOPTS="$MAKEOPTS USE_SYSTEM_SUITESPARSE=1"
	fi

	if [[ $(hostname) == centos* ]]; then
		echo "sad face"	
	fi

	# Output Make.user so that when we "make" it goes quickly
	echo > Make.user
	for f in $MAKEOPTS; do
		echo $f >> Make.user
	done
fi
