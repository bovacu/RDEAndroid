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

sed -i -e "/.*set(APP_HEADERS)*./c set(APP_HEADERS $APP_HEADERS)" CMakeLists.txt
sed -i -e "/.*set(APP_SOURCES)*./c set(APP_SOURCES $APP_SOURCES)" CMakeLists.txt
sed -i -e "/.*set(CMAKE_BUILD_TYPE)*./c set(CMAKE_BUILD_TYPE $BUILD_TYPE)" CMakeLists.txt

echo "CLEANING PROJECT"
./gradlew clean

if [ ! -d "precompiledLibs-$BUILD_TYPE" ]
then
  echo "COMPILING LIBS FOR - $BUILD_TYPE -"
  cd sdl/jni && ./buildAndroidLibs.sh "$GDE_ANDROID_PATH" "$NDK_PATH" "$BUILD_TYPE"
  cd ../..
  mkdir -p precompiledLibs-"$BUILD_TYPE"
  cp -r sdl/build/intermediates/ndkBuild/"$BUILD_TYPE"/lib precompiledLibs-"$BUILD_TYPE"
fi

rm -r -f app/src/main/assets/*
echo "LINKED DEFAULT ASSETS"
ln -s "$GDE_PATH"/defaultAssets app/src/main/assets/
echo "LINKED APP ASSETS"
ln -s "$APP_ASSETS" app/src/main/assets/

echo "BUILDING APP FOR - $BUILD_TYPE -"
if [ "$BUILD_TYPE" = "debug" ]
then
  mkdir -p apk
  mkdir -p apk/debug
  ./gradlew assembleDebug
else
  mkdir -p apk
  mkdir -p apk/release
  ./gradlew assembleRelease
fi

mv app/build/outputs/apk/"$BUILD_TYPE"/* apk/"$BUILD_TYPE"