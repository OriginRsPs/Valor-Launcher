#!/bin/bash

set -e

APPBASE="build/macos-aarch64/Wrath.app"

build() {
    pushd native
    cmake -DCMAKE_OSX_ARCHITECTURES=arm64 -B build-aarch64 .
    cmake --build build-aarch64 --config Release
    popd

    source .jdk-versions.sh

    rm -rf build/macos-aarch64
    mkdir -p build/macos-aarch64

    if ! [ -f mac_aarch64_jre.tar.gz ] ; then
        curl -Lo mac_aarch64_jre.tar.gz $MAC_AARCH64_LINK
    fi

    echo "$MAC_AARCH64_CHKSUM  mac_aarch64_jre.tar.gz" | shasum -c

    mkdir -p $APPBASE/Contents/{MacOS,Resources}

    cp native/build-aarch64/src/Wrath $APPBASE/Contents/MacOS/
    cp target/Wrath.jar $APPBASE/Contents/Resources/
    cp packr/macos-aarch64-config.json $APPBASE/Contents/Resources/config.json
    cp target/filtered-resources/Info.plist $APPBASE/Contents/
    cp osx/app.icns $APPBASE/Contents/Resources/icons.icns

    tar zxf mac_aarch64_jre.tar.gz
    mkdir $APPBASE/Contents/Resources/jre
    mv jdk-$MAC_AARCH64_VERSION-jre/Contents/Home/* $APPBASE/Contents/Resources/jre

    echo Setting world execute permissions on Wrath
    pushd $APPBASE
    chmod g+x,o+x Contents/MacOS/Wrath
    popd

    otool -l $APPBASE/Contents/MacOS/Wrath
}

dmg() {
    SIGNING_IDENTITY="Developer ID Application"
    codesign -f -s "${SIGNING_IDENTITY}" --entitlements osx/signing.entitlements --options runtime $APPBASE || true

    # create-dmg exits with an error code due to no code signing, but is still okay
    create-dmg $APPBASE . || true
    mv Wrath\ *.dmg Wrath-aarch64.dmg

    # dump for CI
    hdiutil imageinfo Wrath-aarch64.dmg

    if ! hdiutil imageinfo Wrath-aarch64.dmg | grep -q "Format: ULFO" ; then
        echo Format of dmg is not ULFO
        exit 1
    fi

    if ! hdiutil imageinfo Wrath-aarch64.dmg | grep -q "Apple_HFS" ; then
        echo Filesystem of dmg is not Apple_HFS
        exit 1
    fi

    # Notarize app
    if xcrun notarytool submit Wrath-aarch64.dmg --wait --keychain-profile "AC_PASSWORD" ; then
        xcrun stapler staple Wrath-aarch64.dmg
    fi
}

while test $# -gt 0; do
  case "$1" in
    --build)
      build
      shift
      ;;
    --dmg)
      dmg
      shift
      ;;
    *)
      break
      ;;
  esac
done