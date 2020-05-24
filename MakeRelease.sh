#!/bin/bash

# --------------------------------------------------------------------------
# SWAG Pascal Code Collection (DelphiDabbler Edition)
#
# Build tool to package up files ready for release.
#
# This file is licensed under the MIT license, copyright © 2020 Peter Johnson,
# https://gravatar.com/delphidabbler
#
#
# A single package is made that contains the SWAG collection itself along with
# documentation and license information. Everything is packaged into a single
# zip file. The zip file is written to the '_release' directory.
#
# Any pre-existing '_release' directory is cleared before the zip file is
# created.
#
# Requirements:
#
#   - The release version number must be passed to this script on the command
#     line. The version number must be in x.y.z format where x, y and z
#     represent the major, minor and patch version numbers respectively.
#
#   - The Info-ZIP zip utility is required to zip up the files. Make sure it's
#     on the system path.
#
# --------------------------------------------------------------------------


# Simple minded check that some value has been passed as 1st paramter
if [ -z $1 ] ; then
  echo "ERROR: Version number in form x.y.z must be passed as a parameter"
  exit 1;
fi


VERSION=$1
RELEASE_DIR="./_release"
RELEASE_FILE_STUB="${RELEASE_DIR}/dd-swag-v${VERSION}"
ZIP_FILE="${RELEASE_FILE_STUB}.zip"

echo Creating DelphiDabbler SWAG release $VERSION
echo

# Create a clean release directory
rm -rf $RELEASE_DIR || true
mkdir $RELEASE_DIR

echo Zipping data

# Files from root dir
zip -q $ZIP_FILE *.* -x MakeRelease.sh  
# Files from 'docs' dir copied to root
zip -q -j $ZIP_FILE ./docs/* 						
# Files and sub dirs in 'source' dir copied with dir structure intact
zip -q -r $ZIP_FILE ./source/*          

echo Done
