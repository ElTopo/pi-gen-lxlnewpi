#!/bin/bash 

# NOTE: to clean build, sudo rm -rf work/

APP=$(basename $0)

# build lxlnewpios lite (stage2)
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

# source my config file so the script gets env $IMG_NAME
source ./lxlnewpi-dfs/lxlnewpi-config

# clean before build if it has arg "cleanbuild"
[ "$1" = "cleanbuild" ] && sudo rm -rf work

echo "$APP: start building [$IMG_NAME]..."
sudo ./build.sh -c ./lxlnewpi-dfs/lxlnewpi-config

[ $? -eq 0 ] && echo "$APP: built OK." || echo "$APP: built failed with problem(s)!"
echo "$APP: Check [work/$IMG_NAME/build.log] for details."
