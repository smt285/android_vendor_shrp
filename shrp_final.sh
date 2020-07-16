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

# Functions
isab() {
	if sed -n '1p' "$SHRP_BUILD/ab" | grep -Fqe "true"; then
		return 0
	else
		return 1
	fi
}

# Extra Variables
BUILD_START=$(date +"%s")
SHRP_VENDOR=vendor/shrp
MAGISKBOOT=$SHRP_VENDOR/extras/magiskboot
SHRP_BUILD=build/make/shrp
SHRP_OUT=$OUT
SHRP_WORK_DIR=$OUT/zip
SHRP_META_DATA_DIR=$OUT/zip/META-INF
RECOVERY_IMG=$OUT/recovery.img
RECOVERY_RAM=$OUT/ramdisk-recovery.cpio
SHRP_DEVICE=$(cut -d'_' -f2-3 <<<$TARGET_PRODUCT)



ZIP_NAME=SHRP_v2.3.2_$SHRP_DEVICE-$SHRP_BUILD_DATE

if [ -d "$SHRP_META_DATA_DIR" ]; then
        rm -rf "$SHRP_META_DATA_DIR"
        rm -rf "$SHRP_OUT"/*.zip
fi

cp -a $SHRP_VENDOR/extras/. $SHRP_WORK_DIR/Files/SHRP/addons
mkdir -p "$SHRP_WORK_DIR/Files/SHRP/data"
cp -R "$SHRP_BUILD/shrp_info.json" "$SHRP_WORK_DIR/Files/SHRP/data/"
mkdir -p "$SHRP_WORK_DIR/META-INF/com/google/android"
if isab; then
  rm -rf "$SHRP_WORK_DIR/META-INF/com/google/android/update-binary"
  mv "$SHRP_VENDOR/updater/update-binary" "$SHRP_VENDOR/updater/update-binary-old"
  cp "$SHRP_VENDOR/updater/update-binary-a" "$SHRP_VENDOR/update-binary-a-bak"
  mv "$SHRP_VENDOR/updater/update-binary-a" "$SHRP_VENDOR/updater/update-binary"
  sed -i 's/$device/'"$SHRP_DEVICE"'/g' "$SHRP_VENDOR/updater/update-binary"
  cp -R "$SHRP_VENDOR/updater/update-binary" "$SHRP_WORK_DIR/META-INF/com/google/android/"
  rm -rf "$SHRP_VENDOR/updater/update-binary"
  mv "$SHRP_VENDOR/update-binary-a-bak" "$SHRP_VENDOR/updater/update-binary-a"
  mv "$SHRP_VENDOR/updater/update-binary-old" "$SHRP_VENDOR/updater/update-binary"
  cp "$RECOVERY_RAM" "$SHRP_WORK_DIR"
  cp "$MAGISKBOOT"  "SHRP_WORK_DIR"
else
  cp -R "$SHRP_BUILD/updater-script" "$SHRP_WORK_DIR/META-INF/com/google/android/"
  cp -R "$SHRP_VENDOR/updater/update-binary" "$SHRP_WORK_DIR/META-INF/com/google/android/update-binary"
  cp "$RECOVERY_IMG" "$SHRP_WORK_DIR"
fi
echo -e ""
cd $SHRP_WORK_DIR
zip -r ${ZIP_NAME}.zip *
mv $SHRP_WORK_DIR/*.zip $SHRP_OUT
