#!/bin/bash

GDE_PATH="$1"
GDE_ANDROID_PATH="$2"
SDK_PATH="$3"
NDK_PATH="$4"

echo "REMEMBER: cmake version should be 3.18.1, if yours is not go download that version from"
echo "SDK Manager and then go to app/build.gradle, there in externalNativeBuild, inside cmake add ' version '3.18.1' '"
echo "REMEMBER: Your NDK version MUST BE 20.1.5948944"

if [ -z "$GDE_PATH" ]
then
    echo "First enter the path to GDE, ex: ~/Documents/GDE"
    exit 0
fi

if [ -z "$GDE_ANDROID_PATH" ]
then
    echo "Second enter the path to GDEAndroid, ex: ~/Documents/GDEAndroid"
    exit 0
fi

if [ -z "$SDK_PATH" ]
then
    echo "Third enter the path to ndk, ex: ~/Android/Sdk"
    exit 0
fi

if [ -z "$NDK_PATH" ]
then
    echo "Fourth enter the path to ndk, ex: ~/Android/Sdk/ndk"
    exit 0
fi

rm -f sdl/jni/GDE
rm -f app/jni/GDE
ln -s "$GDE_PATH" sdl/jni
ln -s "$GDE_PATH" app/jni

if ! grep -q "sdk.dir" gradle.properties; then
  echo -e "\nsdk.dir=$SDK_PATH" >> gradle.properties
fi


# cd sdl/jni/ && ./buildAndroidLibs.sh "$GDE_ANDROID_PATH" "$NDK_PATH" "$BUILD_TYPE"

echo "REMEMBER: cmake version should be 3.18.1, if yours is not go download that version from"
echo "SDK Manager and then go to app/build.gradle, there in externalNativeBuild, inside cmake add ' version '3.18.1' '"
