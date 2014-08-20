#!/bin/bash

set -e

LIB_FILE_NAME=libluajit.a
OUT_DIR=dist/Android
OUT_DIR_LIB=$OUT_DIR/lib
OUT_INCLUDE_DIR=$OUT_DIR/include

rm -rf $OUT_DIR
mkdir -p $OUT_DIR_LIB
mkdir -p $OUT_INCLUDE_DIR

# Common settings
NDK=$HOME/android-ndk-r10
NDKABI=19

# armeabi
echo "Building armeabi.."
make clean

NDKVER=$NDK/toolchains/arm-linux-androideabi-4.6
NDKP=$NDKVER/prebuilt/linux-x86/bin/arm-linux-androideabi-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_FLAGS="$NDKF"
[ $? -ne 0 ] && exit -1

mkdir -p $OUT_DIR_LIB/armeabi
mv src/$LIB_FILE_NAME $OUT_DIR_LIB/armeabi/$LIB_FILE_NAME

# armeabi-v7a
echo -e "\n\nBuilding armeabi-v7a.."
make clean
NDKVER=$NDK/toolchains/arm-linux-androideabi-4.6
NDKP=$NDKVER/prebuilt/linux-x86/bin/arm-linux-androideabi-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"
NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
make CROSS=$NDKP TARGET_FLAGS="$NDKF $NDKARCH"
[ $? -ne 0 ] && exit -1

mkdir -p $OUT_DIR_LIB/armeabi-v7a
mv src/$LIB_FILE_NAME $OUT_DIR_LIB/armeabi-v7a/$LIB_FILE_NAME

# x86
echo -e "\n\nBuilding x86.."
make clean
NDKVER=$NDK/toolchains/x86-4.6
NDKP=$NDKVER/prebuilt/linux-x86/bin/i686-linux-android-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-x86"
make CROSS=$NDKP TARGET_FLAGS="$NDKF"
[ $? -ne 0 ] && exit -1

mkdir -p $OUT_DIR_LIB/x86
mv src/$LIB_FILE_NAME $OUT_DIR_LIB/x86/$LIB_FILE_NAME

# copy includes
cp src/lua.hpp $OUT_INCLUDE_DIR
cp src/lauxlib.h $OUT_INCLUDE_DIR
cp src/lua.h $OUT_INCLUDE_DIR
cp src/luaconf.h $OUT_INCLUDE_DIR
cp src/lualib.h $OUT_INCLUDE_DIR
cp src/luajit.h $OUT_INCLUDE_DIR

echo -e "\nArtifacts are in $OUT_DIR directory.\n"
