#!/usr/bin/env bash

vips_site=https://github.com/libvips/libvips/releases/download
version=$VIPS_VERSION_MAJOR.$VIPS_VERSION_MINOR.$VIPS_VERSION_MICRO

set -e

# do we already have the correct vips built? early exit if yes
# we could check the configure params as well I guess
#if [ -d "${VIPS_HOME}/bin" ]; then
#	installed_version=$(vips --version)
#	escaped_version="$VIPS_VERSION_MAJOR\.$VIPS_VERSION_MINOR\.$VIPS_VERSION_MICRO"
#	echo "Need vips-$version"
#	echo "Found $installed_version"
#	if [[ "$installed_version" =~ ^vips-$escaped_version ]]; then
#		echo "Using cached directory"
#		exit 0
#	fi
#fi

rm -rf "${VIPS_HOME}"
wget "$vips_site/v$version/vips-$version.tar.gz"
tar xf "vips-$version.tar.gz"
cd "vips-$version"
CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 ./configure --prefix="${VIPS_HOME}" $*
make && make install
