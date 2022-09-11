#!/bin/bash
GDE_ANDROID_PATH="$1"
NDK_PATH="$2"
APP_HEADERS="$3"
APP_SOURCES="$4"
BUILD_TYPE="$5"

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

if [ -z "$APP_HEADERS" ]
then
    echo "Third enter the path to your app headers folder, ex: ~/Documents/MyApp/include"
    exit 0
fi

if [ -z "$APP_SOURCES" ]
then
    echo "Fourth enter the path to your app sources folder, ex: ~/Documents/MyApp/src"
    exit 0
fi

if [ -z "$BUILD_TYPE" ]
then
    echo "Fifth enter the build type, debug or release"
    exit 0
fi
./build.sh "$GDE_ANDROID_PATH" "$NDK_PATH" "$APP_HEADERS" "$APP_SOURCES" "$BUILD_TYPE"
adb -d install apk/"$BUILD_TYPE"/app-"$BUILD_TYPE".apk
