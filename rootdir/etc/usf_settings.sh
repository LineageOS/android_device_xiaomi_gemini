#!/system/bin/sh
# Copyright (c) 2015, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

clean_copy_dir=/system/etc/usf
dir0=/data/usf
h_dir=$dir0/hovering
g_dir=$dir0/gesture
sg_dir=$dir0/sync_gesture
t_dir=$dir0/tester
e_dir=$dir0/epos
p2p_dir=$dir0/p2p
prox_dir=$dir0/proximity
pairing_dir=$dir0/pairing
sw_calib_dir=$dir0/sw_calib
ucm_dir=$dir0/ucm
mixer_dir=$dir0/mixer

trigger_file=$dir0/form_factor.cfg

if [ ! -e $trigger_file ]; then
   # Configurations select upon the current platform
   platform=`cat /sys/devices/soc0/hw_platform`
   type=""

   case $platform in
       "Liquid")
           type="liquid"
       ;;
       "Fluid")
           type="fluid"
       ;;
       "MTP")
           type="mtp"
       ;;
       "Dragon")
           type="dragon"
       ;;
   esac

   cp -r $clean_copy_dir/* $dir0

   # The USF based calculators have system permissions
   chown -R system $dir0

   ln -s $dir0/form_factor_"$type".cfg $dir0/form_factor.cfg
   ln -s $t_dir/cfg_"$type" $t_dir/cfg
   ln -s $e_dir/cfg_"$type" $e_dir/cfg
   ln -s $h_dir/cfg_"$type" $h_dir/cfg
   ln -s $p2p_dir/cfg_"$type" $p2p_dir/cfg
   ln -s $g_dir/cfg_"$type" $g_dir/cfg
   ln -s $sg_dir/cfg_"$type" $sg_dir/cfg
   ln -s $prox_dir/cfg_"$type" $prox_dir/cfg
   ln -s $pairing_dir/cfg_"$type" $pairing_dir/cfg
   ln -s $sw_calib_dir/cfg_"$type" $sw_calib_dir/cfg

   ln -s $e_dir/cfg/usf_epos_"$type".cfg $e_dir/usf_epos.cfg
   ln -s $t_dir/cfg/usf_tester_epos_"$type".cfg $t_dir/usf_tester.cfg
   ln -s $h_dir/cfg/usf_hovering_"$type".cfg $h_dir/usf_hovering.cfg
   ln -s $p2p_dir/cfg/usf_p2p_"$type".cfg $p2p_dir/usf_p2p.cfg
   ln -s $g_dir/cfg/usf_gesture_"$type".cfg $g_dir/usf_gesture.cfg
   ln -s $sg_dir/cfg/usf_sync_gesture_"$type".cfg $sg_dir/usf_sync_gesture.cfg
   ln -s $prox_dir/cfg/usf_proximity_"$type".cfg $prox_dir/usf_proximity.cfg
   ln -s $pairing_dir/cfg/usf_pairing_"$type".cfg $pairing_dir/usf_pairing.cfg
   ln -s $sw_calib_dir/cfg/usf_sw_calib_"$type".cfg $sw_calib_dir/usf_sw_calib.cfg
   ln -s $sw_calib_dir/cfg/usf_sw_calib_tester_"$type".cfg $sw_calib_dir/usf_sw_calib_tester.cfg

   ln -s $e_dir/cfg/service_settings_"$type".xml $e_dir/service_settings.xml

   ln -s $mixer_dir/mixer_paths_"$type".xml $mixer_dir/mixer_paths.xml

fi

# Set enabled properties for daemon
setprop ro.qc.sdk.us.proximity 1
