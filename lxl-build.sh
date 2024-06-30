#!/bin/bash 

# NOTE: to clean build, sudo rm -rf work/

# build lxlnewpios lite (stage2)
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

sudo ./build.sh -c ./lxlnewpi-dfs/lxlnewpi-config
