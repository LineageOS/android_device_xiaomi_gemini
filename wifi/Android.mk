LOCAL_PATH:= $(call my-dir)

ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
include $(CLEAR_VARS)
LOCAL_MODULE           := readmac
LOCAL_MODULE_TAGS      := optional
LOCAL_SRC_FILES        := xiaomi_readmac.c
LOCAL_CFLAGS           += -Wall
LOCAL_SHARED_LIBRARIES := libc libcutils libutils liblog libqminvapi
include $(BUILD_EXECUTABLE)
endif
