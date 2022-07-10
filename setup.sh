#!/bin/bash

GDE_PATH="$1"
GDE_ANDROID_PATH="$2"
NDK_PATH="$2"

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

if [ -z "$NDK_PATH" ]
then
    echo "Third enter the path to ndk, ex: ~/Android/Sdk/ndk"
    exit 0
fi

mkdir entt && cd entt && ln -s "$GDE_PATH"/submodules/entt . && cd ..
mkdir freetype && cd freetype && ln -s "$GDE_PATH"/submodules/freetype . && cd ..
mkdir glm && cd glm && ln -s "$GDE_PATH"/submodules/glm . && cd ..

cat <<EOT >> "$GDE_PATH"/submodules/yaml-cpp/Android.mk
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := yaml-cpp

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

  LOCAL_CFLAGS := -fexceptions -frtti

$(info    LOCAL_PATH is $(LOCAL_PATH))

LOCAL_SRC_FILES := \
  $(subst $(LOCAL_PATH)/,, \
  $(wildcard $(LOCAL_PATH)/src/*.cpp) \
  $(wildcard $(LOCAL_PATH)/src/contrib/*.cpp))

include $(BUILD_SHARED_LIBRARY)
EOT

cat <<EOT >> "$GDE_PATH"/submodules/yaml-cpp/Application.mk
APP_STL := c++_shared
APP_ABI := armeabi-v7a arm64-v8a x86 x86_64
APP_PLATFORM := android-21
EOT


cat <<EOT >> "$GDE_PATH"/submodules/box2d/Android.mk
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := box2d

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

$(info    LOCAL_PATH is $(LOCAL_PATH))

LOCAL_SRC_FILES := \
  $(subst $(LOCAL_PATH)/,, \
  $(wildcard $(LOCAL_PATH)/src/collision/*.cpp) \
  $(wildcard $(LOCAL_PATH)/src/common/*.cpp) \
  $(wildcard $(LOCAL_PATH)/src/dynamics/*.cpp) \
  $(wildcard $(LOCAL_PATH)/src/rope/*.cpp))

include $(BUILD_SHARED_LIBRARY)
EOT

cat <<EOT >> "$GDE_PATH"/submodules/box2d/Application.mk
APP_STL := c++_shared
APP_ABI := armeabi-v7a arm64-v8a x86 x86_64
APP_PLATFORM := android-21
EOT


cd sdl/jni && ln -s "$GDE_PATH"/submodules/box2d . && ln -s "$GDE_PATH"/submodules/yaml-cpp .

cd ../.. && sed -i -e 's/add_subdirectory(extern/glad)/#add_subdirectory(extern/glad)/g' "$GDE_PATH"/submodules/box2d/CMakeLists.txt
cd ../.. && sed -i -e 's/add_subdirectory(extern/glfw)/#add_subdirectory(extern/glfw)/g' "$GDE_PATH"/submodules/box2d/CMakeLists.txt
cd ../.. && sed -i -e 's/add_subdirectory(extern/imgui)/#add_subdirectory(extern/imgui)/g' "$GDE_PATH"/submodules/box2d/CMakeLists.txt
cd ../.. && sed -i -e 's/add_subdirectory(extern/sajson)/#add_subdirectory(extern/sajson)/g' "$GDE_PATH"/submodules/box2d/CMakeLists.txt
cd ../.. && sed -i -e 's/add_subdirectory(testbed)/#add_subdirectory(testbed)/g' "$GDE_PATH"/submodules/box2d/CMakeLists.txt
cd ../.. && sed -i -e 's/set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT testbed)/#set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT testbed)/g' "$GDE_PATH"/submodules/box2d/CMakeLists.txt
cd ../.. && sed -i -e "s/set_property(TARGET testbed PROPERTY VS_DEBUGGER_WORKING_DIRECTORY ""${CMAKE_SOURCE_DIR}"/testbed")/set_property(TARGET testbed PROPERTY VS_DEBUGGER_WORKING_DIRECTORY ""${CMAKE_SOURCE_DIR}"/testbed")/g" "$GDE_PATH"/submodules/box2d/CMakeLists.txt

cd ../.. && sed -i -e "s/~BadConversion() YAML_CPP_NOEXCEPT override;/~BadConversion() YAML_CPP_NOEXCEPT override{}\n/g" "$GDE_PATH"/submodules/yaml-cpp/include/yaml-cpp/exceptions.h
cd ../.. && sed -i -e "s/BadConversion::~BadConversion() YAML_CPP_NOEXCEPT = default;/ //BadConversion::~BadConversion() YAML_CPP_NOEXCEPT = default;\n/g" "$GDE_PATH"/submodules/yaml-cpp/src/exceptions.cpp

./buildAndroidLibs.sh "$GDE_ANDROID_PATH" "$NDK_PATH"

echo "REMEMBER: cmake version should be 3.18.1, if yours is not go download that version from"
echo "SDK Manager and then go to app/build.gradle, there in externalNativeBuild, inside cmake add ' version '3.18.1' '"