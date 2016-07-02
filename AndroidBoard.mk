#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2016 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

#----------------------------------------------------------------------
# Radio image
#----------------------------------------------------------------------
ifeq ($(ADD_RADIO_FILES), true)
radio_dir := $(LOCAL_PATH)/radio
RADIO_FILES := $(shell cd $(radio_dir) ; ls)
$(foreach f, $(RADIO_FILES), \
    $(call add-radio-file,radio/$(f)))
endif

TARGET_BOOTLOADER_EMMC_INTERNAL := $(LOCAL_PATH)/images/emmc_appsboot.mbn
$(TARGET_BOOTLOADER_EMMC_INTERNAL): $(TARGET_BOOTLOADER)

INSTALLED_RADIOIMAGE_TARGET += $(TARGET_BOOTLOADER_EMMC_INTERNAL)
$(call add-radio-file,images/adspso.bin)
$(call add-radio-file,images/BTFM.bin)
$(call add-radio-file,images/cmnlib64.mbn)
$(call add-radio-file,images/cmnlib.mbn)
$(call add-radio-file,images/devcfg.mbn)
$(call add-radio-file,images/hyp.mbn)
$(call add-radio-file,images/keymaster.mbn)
$(call add-radio-file,images/lksecapp.mbn)
$(call add-radio-file,images/logo.img)
$(call add-radio-file,images/NON-HLOS.bin)
$(call add-radio-file,images/pmic.elf)
$(call add-radio-file,images/rpm.mbn)
$(call add-radio-file,images/splash.img)
$(call add-radio-file,images/tz.mbn)
$(call add-radio-file,images/xbl.elf)
