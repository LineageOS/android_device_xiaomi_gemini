#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2018 The LineageOS Project
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

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from gemini device
$(call inherit-product, device/xiaomi/gemini/device.mk)

# must be before including RR part
TARGET_BOOTANIMATION_SIZE := 1080p

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/rr/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := rr_gemini
PRODUCT_DEVICE := gemini
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := MI 5
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE="gemini" \
    PRODUCT_NAME="gemini" \
    PRIVATE_BUILD_DESC="gemini-user 8.0.0 OPR1.170623.032 V9.6.1.0.OAAMIFD release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := "Xiaomi/gemini/gemini:8.0.0/OPR1.170623.032/V9.6.1.0.OAAMIFD:user/release-keys"

TARGET_VENDOR := Xiaomi
