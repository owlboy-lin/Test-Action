#!/bin/bash
#=================================================
# Description: Upload Firmware & Other Files to Tmp.Link
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Upload Packages to Tmp.Link
cd openwrt/bin/packages
zip -q -r packages.zip *
echo "packages.zip" >> ../targets/*/*/$DOWNLOAD_URL_FILE
curl -k -F "file=@packages.zip" -F "token=${{ secrets.TMP_LINK_TOKEN }}" -F "model=0" -X POST "https://connect.tmp.link/api_v2/cli_uploader" -s >> ../targets/*/*/$DOWNLOAD_URL_FILE

# Upload Kernel-Packages to Tmp.Link
cd ../targets/*/*
zip -q -r kernel-packages.zip packages
echo "kernel-packages.zip" >> $DOWNLOAD_URL_FILE
curl -k -F "file=@kernel-packages.zip" -F "token=${{ secrets.TMP_LINK_TOKEN }}" -F "model=0" -X POST "https://connect.tmp.link/api_v2/cli_uploader" -s >> $DOWNLOAD_URL_FILE

# Upload Firmware/ImageBuilder/PackagesInfo/RootFS/SDK/Toolchain to Tmp.Link
find -name "openwrt*" -exec echo {} >> Download-Url.txt \; -exec curl -k -F "file=@{}" -F "token=fk51xrsqea" -F "model=0" -X POST "https://connect.tmp.link/api_v2/cli_uploader" -s >> Download-Url.txt \;

# Upload config.seed to Tmp.Link
echo "config.seed" >> $DOWNLOAD_URL_FILE
curl -k -F "file=@config.seed" -F "token=${{ secrets.TMP_LINK_TOKEN }}" -F "model=0" -X POST "https://connect.tmp.link/api_v2/cli_uploader" -s >> $DOWNLOAD_URL_FILE

# Upload sha256sums to Tmp.Link
echo "sha256sums" >> $DOWNLOAD_URL_FILE
curl -k -F "file=@sha256sums" -F "token=${{ secrets.TMP_LINK_TOKEN }}" -F "model=0" -X POST "https://connect.tmp.link/api_v2/cli_uploader" -s >> $DOWNLOAD_URL_FILE

# Remove No Need Contents
sed -i 's/\.\///g' $DOWNLOAD_URL_FILE
sed -i '/^Upload.*/d' $DOWNLOAD_URL_FILE
sed -i '/^Thank.*/d' $DOWNLOAD_URL_FILE
sed -i '/Download/G' $DOWNLOAD_URL_FILE
