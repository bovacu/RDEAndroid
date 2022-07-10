#!/bin/bash
GDE_ANDROID_PATH="$1"
NDK_PATH="$2"
# This is REALLY IMPORTANT!! It builds the .so libs for SDL, SDL_Image, SDL_Mixer, Box2d and Yaml-cpp (more if in future more libs are added), through their corresponding Android.mk
"$NDK_PATH"/20.1.5948944/ndk-build APP_PLATFORM=android-21 NDK_DEBUG=1 NDK_OUT="$GDE_ANDROID_PATH"/sdl/build/intermediates/ndkBuild/debug/object NDK_LIBS_OUT="$GDE_ANDROID_PATH"/sdl/build/intermediates/ndkBuild/debug/lib