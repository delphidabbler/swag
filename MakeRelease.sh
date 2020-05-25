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
# A single package is created that contains the SWAG collection itself along
# with documentation and license information. Everything is packaged into a
# zip file that is written to the '_release' directory. For details of the
# package contents see the project's 'README.md' file.
#
# ** WARNING: Any pre-existing '_release' directory is cleared before the zip
#   file is created.
#
# Requirements:
#
#   - See the project's 'README.md' file for details of the utilities required
#     to run this script.
#
#   - The version number included in the generated zip file name is taken from
#     the 'VERSION' file in the project's 'source' directory. Ensure this file
#     is updated to the correct version before running the script. The script
#     will fail if 'VERSION' is missing or is invalid. Read the file
#     'swag-data-structure.md' in the project's 'docs' directory for more
#     information about the 'VERSION' file.
#
# --------------------------------------------------------------------------


RELEASE_DIR="./_release"
TEMP_DIR="${RELEASE_DIR}/_temp"
TEMP_SWAG_DIR="${TEMP_DIR}/swag"
VERSION_FILE="./source/VERSION"

echo Creating DelphiDabbler SWAG release
echo

echo Reading release version from VERSION file

# Read version from VERSION file & create release file name
version=$(head -n 1 $VERSION_FILE)
if [ $? -ne 0 ]; then
	echo "ERROR: Can't read VERSION file"
	exit 1;
fi
# -- simple minded check that version has been read
if [ -z $version ]; then
  echo "ERROR: VERSION file is empty"
  exit 1;
fi
ZIP_FILE="${RELEASE_DIR}/dd-swag-v${version}.zip"
echo "    Version is: ${version}"
echo "    Release file name is: ${ZIP_FILE}"

# Create a clean release directory
rm -rf $RELEASE_DIR || true
mkdir $RELEASE_DIR

# Create temp directory for manipulating file
mkdir $TEMP_DIR
mkdir $TEMP_SWAG_DIR

# Copy source dir to temp directory & rename 'source' as 'swag'
echo Copying files
cp -R -f ./source/* "${TEMP_SWAG_DIR}"
if [ $? -ne 0 ]; then
	echo "ERROR: Can't copy 'source' to 'swag'"
	exit 1;
fi

# Create release zip file
echo Zipping data
# -- files from root dir
zip -q $ZIP_FILE *.* -x MakeRelease.sh
zip1=$?
# -- files from 'docs' dir copied to root
zip -q -j $ZIP_FILE ./docs/*
zip2=$?
# -- files and sub dirs in temp 'swag' dir copied with dir structure intact
cd $TEMP_DIR
zip -q -r "../../${ZIP_FILE}" ./swag/*
zip3=$?
cd ../..
# -- check for errors
if [ $zip1 -ne 0 ] || [ $zip2 -ne 0 ] || [ $zip3 -ne 0 ]; then
  echo "ERROR: Zip failed"
	exit 1
fi

# Tidy up
echo Tidying up
rm -rf $TEMP_DIR

echo
echo Done
