#!/bin/bash
GDE_ANDROID_PATH="$1"
NDK_PATH="$2"
BUILD_TYPE="$3"

if [ -z "$GDE_ANDROID_PATH" ]
then
    echo "First enter the path to RDEAndroid, ex: ~/Documents/RDEAndroid"
    exit 0
fi

if [ -z "$NDK_PATH" ]
then
    echo "Second enter the path to NDK"
    exit 0
fi

if [ -z "$BUILD_TYPE" ]
then
    echo "Third enter the path build type, debug or release"
    exit 0
fi

NDK_BUILD_TYPE=1

if [ "$BUILD_TYPE" = "debug" ]
then
    NDK_BUILD_TYPE=0
fi

# This is REALLY IMPORTANT!! It builds the .so libs for SDL through its corresponding Android.mk
"$NDK_PATH"/25.2.9519653/ndk-build APP_PLATFORM=android-28 NDK_DEBUG=0 NDK_OUT="$GDE_ANDROID_PATH"/sdl/build/intermediates/ndkBuild/"$BUILD_TYPE"/object NDK_LIBS_OUT="$GDE_ANDROID_PATH"/sdl/build/intermediates/ndkBuild/"$BUILD_TYPE"/lib