#!/bin/bash
GDE_ANDROID_PATH="$1"
NDK_PATH="$2"

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

# This is REALLY IMPORTANT!! It builds the .so libs for SDL, SDL_Image, SDL_Mixer, Box2d (more if in future more libs are added), through their corresponding Android.mk
"$NDK_PATH"/20.1.5948944/ndk-build APP_PLATFORM=android-21 NDK_DEBUG=0 NDK_OUT="$GDE_ANDROID_PATH"/sdl/build/intermediates/ndkBuild/release/object NDK_LIBS_OUT="$GDE_ANDROID_PATH"/sdl/build/intermediates/ndkBuild/release/lib