#!/bin/bash

# Set PATH since we haven't restarted since storing .bash_profile
export PATH="$PATH:/usr/local/bin:/usr/local/sbin"

# Install all julia dependencies
brew tap staticfloat/julia
brew install julia