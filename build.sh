#!/bin/bash
GDE_ANDROID_PATH="$1"
NDK_PATH="$2"
APP_HEADERS="$3"
APP_SOURCES="$4"

if [ -z "$NDK_PATH" ]
then
    echo "First enter the path to NDK"
    exit 0
fi

if [ -z "$GDE_ANDROID_PATH" ]
then
    echo "Second enter the path to GDEAndroid, ex: ~/Documents/GDEAndroid"
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

sed -i -e "/.*set(APP_HEADERS)*./c set(APP_HEADERS $APP_HEADERS)" CMakeLists.txt
sed -i -e "/.*set(APP_SOURCES)*./c set(APP_HEADERS $APP_SOURCES)" CMakeLists.txt

mkdir apk
echo "CLEANING PROJECT"
./gradlew clean

echo "COMPILING LIBS"
cd sdl/jni && ./buildAndroidLibs.sh "$GDE_ANDROID_PATH" "$NDK_PATH"
cd ../..

echo "BUILDING APP"
./gradlew assembleRelease
mv app/build/outputs/apk/release/* apk