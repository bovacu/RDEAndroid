#!/bin/bash
GDE_ANDROID_PATH="$1"
NDK_PATH="$2"
BUILD_TYPE="$3"

if [ -z "$GDE_ANDROID_PATH" ]
then
    echo "First enter the path to GDEAndroid, ex: ~/Documents/GDEAndroid"
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

./build.sh "$GDE_ANDROID_PATH" "$NDK_PATH" "$BUILD_TYPE"
adb -d install apk/"$BUILD_TYPE"/app-"$BUILD_TYPE".apk