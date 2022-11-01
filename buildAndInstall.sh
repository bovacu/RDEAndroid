#!/bin/bash
GDE_ANDROID_PATH="$1"
GDE_PATH="$2"
NDK_PATH="$3"
APP_HEADERS="$4"
APP_SOURCES="$5"
APP_ASSETS="$6"
BUILD_TYPE="$7"

if [ -z "$GDE_ANDROID_PATH" ]
then
    echo "First enter the path to GDEAndroid, ex: ~/Documents/GDEAndroid"
    exit 0
fi

if [ -z "$GDE_PATH" ]
then
    echo "Second enter the path to GDE, ex: ~/Documents/GDE"
    exit 0
fi

if [ -z "$NDK_PATH" ]
then
    echo "Third enter the path to NDK"
    exit 0
fi

if [ -z "$APP_HEADERS" ]
then
    echo "Fourth enter the path to your app headers folder, ex: ~/Documents/MyApp/include"
    exit 0
fi

if [ -z "$APP_SOURCES" ]
then
    echo "Fifth enter the path to your app sources folder, ex: ~/Documents/MyApp/src"
    exit 0
fi

if [ -z "$APP_ASSETS" ]
then
    echo "Sixth enter the path to your app assets folder, ex: ~/Documents/MyApp/assets"
    exit 0
fi

if [ -z "$BUILD_TYPE" ]
then
    echo "Seventh enter the build type, debug or release"
    exit 0
fi


./build.sh "$GDE_ANDROID_PATH" "$GDE_PATH" "$NDK_PATH" "$APP_HEADERS" "$APP_SOURCES" "$APP_ASSETS" "$BUILD_TYPE"
adb -d install apk/"$BUILD_TYPE"/app-"$BUILD_TYPE".apk
