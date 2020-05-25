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
TEMP_DIR="${RELEASE_DIR}/_temp"
TEMP_SWAG_DIR="${TEMP_DIR}/swag"

echo Creating DelphiDabbler SWAG release $VERSION
echo

# Create a clean release directory
rm -rf $RELEASE_DIR || true
mkdir $RELEASE_DIR

# Create temp directory for manipulating file
mkdir $TEMP_DIR
mkdir $TEMP_SWAG_DIR

# Copy source dir to temp directory & rename 'source' as 'swag'
echo Copying files
cp -R -f ./source/* "${TEMP_SWAG_DIR}"

echo Zipping data

# Files from root dir
zip -q $ZIP_FILE *.* -x MakeRelease.sh
# Files from 'docs' dir copied to root
zip -q -j $ZIP_FILE ./docs/*
# Files and sub dirs in temp 'swag' dir copied with dir structure intact
cd $TEMP_DIR
zip -q -r "../../${ZIP_FILE}" ./swag/*
cd ../..

# Tidy up
echo Tidying up
rm -rf $TEMP_DIR || true

echo
echo Done
