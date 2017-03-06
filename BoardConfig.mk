#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
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

# Inherit from common msm8996-common
-include device/xiaomi/msm8996-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/gemini

# Assert
TARGET_OTA_ASSERT_DEVICE := gemini

# Board
TARGET_BOARD_INFO_FILE ?= $(DEVICE_PATH)/board-info.txt

# Kernel
TARGET_KERNEL_CONFIG := lineageos_gemini_defconfig

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Inherit from the proprietary version
-include vendor/xiaomi/gemini/BoardConfigVendor.mk
