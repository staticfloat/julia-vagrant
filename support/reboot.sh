#!/bin/bash

# Sleep until we get killed so that Packer knows that we've restarted!
shutdown -r now && sleep 60