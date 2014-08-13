#!/bin/bash

# Install Homebrew, don't let it ask questions
sudo -u vagrant ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" </dev/null
export PATH="$PATH:/usr/local/bin:/usr/local/sbin"

# Install gcc (which gives us gfortran) and git, since we like new versions of git
sudo -u vagrant brew install -v gcc git

# Install llvm33 (we're gonna need to bottle this one)
sudo -u vagrant brew tap homebrew/versions
sudo -u vagrant brew tap staticfloat/julia

# Install pcre, gmp (make it explicit even though llvm requires it), fftw, mpfr
sudo -u vagrant brew install -v pcre gmp fftw mpfr python