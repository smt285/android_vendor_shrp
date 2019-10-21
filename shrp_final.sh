#!/bin/bash
##########################################################################
#Copyright 2019 SKYHAWK RECOVERY PROJECT
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
##########################################################################
CLR_RST=$(tput sgr0)                        ## reset flag
CLR_RED=$CLR_RST$(tput setaf 1)             #  red, plain
CLR_GRN=$CLR_RST$(tput setaf 2)             #  green, plain
CLR_YLW=$CLR_RST$(tput setaf 3)             #  yellow, plain
CLR_BLU=$CLR_RST$(tput setaf 4)             #  blue, plain
CLR_PPL=$CLR_RST$(tput setaf 5)             #  purple,plain
CLR_CYA=$CLR_RST$(tput setaf 6)             #  cyan, plain
CLR_BLD=$(tput bold)                        ## bold flag
CLR_BLD_RED=$CLR_RST$CLR_BLD$(tput setaf 1) #  red, bold
CLR_BLD_GRN=$CLR_RST$CLR_BLD$(tput setaf 2) #  green, bold
CLR_BLD_YLW=$CLR_RST$CLR_BLD$(tput setaf 3) #  yellow, bold
CLR_BLD_BLU=$CLR_RST$CLR_BLD$(tput setaf 4) #  blue, bold
CLR_BLD_PPL=$CLR_RST$CLR_BLD$(tput setaf 5) #  purple, bold
CLR_BLD_CYA=$CLR_RST$CLR_BLD$(tput setaf 6) #  cyan, bold

# Extra Variables
BUILD_START=$(date +"%s")
DATE=$(date -u +%Y%m%d-%H%M)
VERSION=2.1
SHRP_VENDOR=vendor/shrp
SHRP_BUILD=build/make/shrp
SHRP_OUT=$OUT
SHRP_WORK_DIR=$OUT/zip
SHRP_META_DATA_DIR=$OUT/zip/META-INF
RECOVERY_IMG=$OUT/recovery.img
RECOVERY_RAM=$OUT/ramdisk-recovery.cpio

ZIP_NAME=SHRP-$SHRP_DEVICE_CODE-$VERSION-$DATE

if [ -d "$SHRP_META_DATA_DIR" ]; then
        rm -rf "$SHRP_META_DATA_DIR"
        rm -rf "$SHRP_OUT"/*.zip
fi

#if [ ! -d "SHRP_WORK_DIR" ]; then
#       mkdir "$SHRP_WORK_DIR"
#fi

#mkdir -p "$SHRP_WORK_DIR/Files/SHRP/epicx"
cp -a $SHRP_VENDOR/extras/. $SHRP_WORK_DIR/Files/SHRP/epicx
#cp -R "$SHRP_OUT/recovery/root/etc/cookies" "$SHRP_WORK_DIR/Files/SHRP/epicx/"
mkdir -p "$SHRP_WORK_DIR/META-INF/com/google/android"
#cp -R "$SHRP_VENDOR/updater/"* "$SHRP_WORK_DIR/META-INF/com/google/android/"
cp -R "$SHRP_BUILD/updater-script" "$SHRP_WORK_DIR/META-INF/com/google/android/"
cp -R "$SHRP_VENDOR/updater/update-binary" "$SHRP_WORK_DIR/META-INF/com/google/android/update-binary"

cp "$RECOVERY_IMG" "$SHRP_WORK_DIR/Files/SHRP/epicx/"
echo -e ""
cd $SHRP_WORK_DIR
zip -r ${ZIP_NAME}.zip *

