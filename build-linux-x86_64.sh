#!/bin/bash

set -e

pushd native
cmake -B build-x64 .
cmake --build build-x64 --config Release
popd

APPIMAGE_VERSION="13"

umask 022

source .jdk-versions.sh

rm -rf build/linux-x64
mkdir -p build/linux-x64

if ! [ -f linux64_jre.tar.gz ] ; then
    curl -Lo linux64_jre.tar.gz $LINUX_AMD64_LINK
fi

echo "$LINUX_AMD64_CHKSUM linux64_jre.tar.gz" | sha256sum -c

# Note: Host umask may have checked out this directory with g/o permissions blank
chmod -R u=rwX,go=rX appimage
# ...ditto for the build process
chmod 644 target/Wrath.jar

cp native/build-x64/src/Wrath build/linux-x64/
cp target/Wrath.jar build/linux-x64/
cp packr/linux-x64-config.json build/linux-x64/config.json
cp target/filtered-resources/app.desktop build/linux-x64/
cp appimage/app.png build/linux-x64/

tar zxf linux64_jre.tar.gz
mv jdk-$LINUX_AMD64_VERSION-jre build/linux-x64/jre

pushd build/linux-x64/
mkdir -p jre/lib/amd64/server/
ln -s ../../server/libjvm.so jre/lib/amd64/server/ # packr looks for libjvm at this hardcoded path

# Symlink AppRun -> RuneLite
ln -s Wrath AppRun

# Ensure RuneLite is executable to all users
chmod 755 Wrath
popd

if ! [ -f appimagetool-x86_64.AppImage ] ; then
    curl -Lo appimagetool-x86_64.AppImage \
        https://github.com/AppImage/AppImageKit/releases/download/$APPIMAGE_VERSION/appimagetool-x86_64.AppImage
    chmod +x appimagetool-x86_64.AppImage
fi

echo "df3baf5ca5facbecfc2f3fa6713c29ab9cefa8fd8c1eac5d283b79cab33e4acb  appimagetool-x86_64.AppImage" | sha256sum -c

# Build the AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage build/linux-x64/ Wrath.AppImage
# Ensure the AppImage is executable to all users