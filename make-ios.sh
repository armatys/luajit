#!/bin/bash

set -e
echo "Compiling..."

OUT_DIR=dist/iOS
OUT_LIB_DIR=$OUT_DIR/lib
OUT_INCLUDE_DIR=$OUT_DIR/include

rm -rf $OUT_DIR
mkdir -p $OUT_LIB_DIR
mkdir -p $OUT_INCLUDE_DIR

IXCODE=`xcode-select -print-path`
ISDK=$IXCODE/Platforms/iPhoneOS.platform/Developer
ISDK_SIMULATOR=$IXCODE/Platforms/iPhoneSimulator.platform/Developer
ISDKVER=iPhoneOS7.1.sdk
ISDKVER_SIMULATOR=iPhoneSimulator7.1.sdk
LDFLAGS="-framework CoreFoundation"

ISDKP=/usr/bin/

### armv7

ISDKF="-arch armv7 -isysroot $ISDK/SDKs/$ISDKVER"
make clean
make HOST_CC="xcrun gcc -m32 -arch i386" LDFLAGS="$LDFLAGS" CROSS="$ISDKP" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS
cp src/libluajit.a $OUT_LIB_DIR/libluajit_arm7.a

### armv7s

ISDKF="-arch armv7s -isysroot $ISDK/SDKs/$ISDKVER"
make clean
make HOST_CC="xcrun gcc -m32 -arch i386" LDFLAGS="$LDFLAGS" CROSS="$ISDKP" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS
cp src/libluajit.a $OUT_LIB_DIR/libluajit_arm7s.a

### i386

ISDKF="-arch i386 -isysroot $ISDK_SIMULATOR/SDKs/$ISDKVER_SIMULATOR"
make clean
make HOST_CC="xcrun gcc -m32 -arch i386" LDFLAGS="$LDFLAGS" CC="xcrun gcc -miphoneos-version-min=7.0" CROSS="$ISDKP" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS
cp src/libluajit.a $OUT_LIB_DIR/libluajit_i386.a

### x86_64

ISDKF="-arch x86_64 -isysroot $ISDK_SIMULATOR/SDKs/$ISDKVER_SIMULATOR"
make clean
make HOST_CC="xcrun gcc -m64 -arch x86_64" LDFLAGS="$LDFLAGS" CC="xcrun gcc -miphoneos-version-min=7.0" CROSS="$ISDKP" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS
cp src/libluajit.a $OUT_LIB_DIR/libluajit_x86_64.a

# copy includes
cp src/lua.hpp $OUT_INCLUDE_DIR
cp src/lauxlib.h $OUT_INCLUDE_DIR
cp src/lua.h $OUT_INCLUDE_DIR
cp src/luaconf.h $OUT_INCLUDE_DIR
cp src/lualib.h $OUT_INCLUDE_DIR
cp src/luajit.h $OUT_INCLUDE_DIR

# combine lib
cd $OUT_LIB_DIR
lipo -create -output libluajit.a libluajit_arm7.a libluajit_arm7s.a libluajit_i386.a

echo -n "\nArtifacts are in $OUT_DIR directory.\n"
