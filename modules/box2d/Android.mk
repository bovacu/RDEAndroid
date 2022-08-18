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