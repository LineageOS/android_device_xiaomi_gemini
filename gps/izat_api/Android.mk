ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_COPY_HEADERS_TO:= liblocationservice/lcp/inc/

LOCAL_COPY_HEADERS:= \
    IzatRemoteApi.h \
    izat_remote_api.h

include $(BUILD_COPY_HEADERS)

endif # not BUILD_TINY_ANDROID
