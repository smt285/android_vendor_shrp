#!/bin/bash
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
cp -R "$SHRP_VENDOR/extras/"* "$SHRP_WORK_DIR/Files/SHRP/epicx/"
#cp -R "$SHRP_OUT/recovery/root/etc/cookies" "$SHRP_WORK_DIR/Files/SHRP/epicx/"
mkdir -p "$SHRP_WORK_DIR/META-INF/com/google/android"
cp -R "$SHRP_VENDOR/updater/"* "$SHRP_WORK_DIR/META-INF/com/google/android/"
cp -R "$SHRP_BUILD/updater-script" "$SHRP_WORK_DIR/META-INF/com/google/android/"
cp -R "$SHRP_VENDOR/updater/update-binary" "$SHRP_WORK_DIR/META-INF/com/google/android/update-binary"

cp "$RECOVERY_IMG" "$SHRP_WORK_DIR/Files/SHRP/epicx/"
echo -e ""
cd $SHRP_WORK_DIR
zip -r ${ZIP_NAME}.zip *

