# Copyright (C) 2012 The Android Open Source Project
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

"""Firmware update tool for Xiaomi Mi 5 (All variants)"""

import common
import re
import sha

def FullOTA_Assertions(info):
  print "FullOTA_Assertions not implemented"

def IncrementalOTA_Assertions(info):
  print "IncrementalOTA_Assertions not implemented"

def InstallImage(img_name, img_file, partition, info):
  common.ZipWriteStr(info.output_zip, img_name, img_file)
  info.script.AppendExtra(('package_extract_file("' + img_name + '", "/dev/block/platform/msm_sdcc.1/by-name/' + partition + '");'))

image_partitions = {
   'cmnlib64.mbn'      : 'cmnlib64',
   'cmnlib.mbn'        : 'cmnlib',
   'hyp.mbn'           : 'hyp',
   'pmic.elf'          : 'pmic',
   'tz.mbn'            : 'tz',
   'emmc_appsboot.mbn' : 'aboot',
   'lksecapp.mbn'      : 'lksecapp',
   'devcfg.mbn'        : 'devcfg',
   'keymaster.mbn'     : 'keymaster',
   'xbl.elf'           : 'xbl',
   'rpm.mbn'           : 'rpm',
   'cmnlib64.mbn'      : 'cmnlib64bak',
   'cmnlib.mbn'        : 'cmnlibbak',
   'hyp.mbn'           : 'hypbak',
   'pmic.elf'          : 'pmicbak',
   'tz.mbn'            : 'tzbak',
   'emmc_appsboot.mbn' : 'abootbak',
   'lksecapp.mbn'      : 'lksecappbak',
   'devcfg.mbn'        : 'devcfgbak',
   'keymaster.mbn'     : 'keymasterbak',
   'xbl.elf'           : 'xblbak',
   'rpm.mbn'           : 'rpmbak',
   'splash.img'        : 'splash',
   'NON-HLOS.bin'      : 'modem',
   'logo.img'          : 'logo',
   'adspso.bin'        : 'dsp',
   'BTFM.bin'          : 'bluetooth'
}

def FullOTA_InstallEnd(info):
  for k, v in image_partitions.iteritems():
    try:
      img_file = info.input_zip.read("RADIO/" + k)
      info.script.Print("Writing image " + k + "...")
      InstallImage(k, img_file, v, info)
    except KeyError:
      print "warning: no " + k + " image in input target_files; not flashing " + k


def IncrementalOTA_InstallEnd(info):
  for k, v in image_partitions.iteritems():
    try:
      source_file = info.source_zip.read("RADIO/" + k)
      target_file = info.target_zip.read("RADIO/" + k)
      if source_file != target_file:
        InstallImage(k, target_file, v, info)
      else:
        print k + " image unchanged; skipping"
    except KeyError:
      print "warning: " + k + " image missing from target; not flashing " + k
