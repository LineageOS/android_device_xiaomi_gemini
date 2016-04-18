#!/system/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
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
#      from this software without specific prior written permission.
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
# This script will check the type of the bluetooth device and set the
# symbolic links to UCM files accordingly

target="$1"
btsoc="$2"
if [ -f /sys/devices/soc0/soc_id ]; then
    soc_hwid=`cat /sys/devices/soc0/soc_id`
else
    soc_hwid=`cat /sys/devices/system/soc/soc0/id`
fi

# No path is set up at this point so we have to do it here.
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

case "$target" in
    msm8960*)
        echo "The TARGET ID is $target"
    case $soc_hwid in
         "130")
            echo "The BTSOC ID is $btsoc"
            echo "Setting soft links for auxpcm files"
            rm /etc/snd_soc_msm/snd_soc_msm 2>/dev/null
            rm /etc/snd_soc_msm/snd_soc_msm_2x 2>/dev/null
            rm /etc/snd_soc_msm/snd_soc_msm_2x_mpq 2>/dev/null
            rm /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3 2>/dev/null
            rm /etc/snd_soc_msm/snd_soc_msm_Sitar 2>/dev/null
            ln -s /etc/snd_soc_msm/snd_soc_msm_auxpcm             /etc/snd_soc_msm/snd_soc_msm 2>/dev/null
            ln -s /etc/snd_soc_msm/snd_soc_msm_2x_auxpcm          /etc/snd_soc_msm/snd_soc_msm_2x 2>/dev/null
            ln -s /etc/snd_soc_msm/snd_soc_msm_2x_mpq_auxpcm      /etc/snd_soc_msm/snd_soc_msm_2x_mpq 2>/dev/null
            ln -s /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3_auxpcm  /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3 2>/dev/null
            ln -s /etc/snd_soc_msm/snd_soc_msm_Sitar_auxpcm       /etc/snd_soc_msm/snd_soc_msm_Sitar 2>/dev/null
            setprop qcom.audio.init complete
            exit 0
        ;;
    *)
        ;;
    esac
    ;;
*)
    ;;
esac

echo "The BTSOC ID is $btsoc"
case "$btsoc" in
    "ath3k")
	case "$target" in
	    msm8974*)
		echo "Setting soft links for auxpcm files"
		rm /etc/snd_soc_msm/snd_soc_msm_Taiko_liquid 2>/dev/null
		ln -s /etc/snd_soc_msm/snd_soc_msm_Taiko_liquid_auxpcm	/etc/snd_soc_msm/snd_soc_msm_Taiko_liquid 2>/dev/null
		;;
	    msm8960*)
	        echo "Setting soft links for auxpcm files"
		rm /etc/snd_soc_msm/snd_soc_msm 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_2x 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_2x_mpq 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_Sitar 2>/dev/null
		ln -s /etc/snd_soc_msm/snd_soc_msm_auxpcm             /etc/snd_soc_msm/snd_soc_msm 2>/dev/null
		ln -s /etc/snd_soc_msm/snd_soc_msm_2x_auxpcm          /etc/snd_soc_msm/snd_soc_msm_2x 2>/dev/null
		ln -s /etc/snd_soc_msm/snd_soc_msm_2x_mpq_auxpcm      /etc/snd_soc_msm/snd_soc_msm_2x_mpq 2>/dev/null
		ln -s /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3_auxpcm  /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3 2>/dev/null
		ln -s /etc/snd_soc_msm/snd_soc_msm_Sitar_auxpcm       /etc/snd_soc_msm/snd_soc_msm_Sitar 2>/dev/null
		;;
	    *)
		;;
	esac
        ;;
    *)
	case "$target" in
	    msm8974*)
		echo "Not setting soft links, remove Auxpcm UCM files"
		rm /etc/snd_soc_msm/snd_soc_msm_Taiko_liquid_auxpcm 2>/dev/null
		;;
	    msm8960*)
		echo "Not setting soft links, remove Auxpcm UCM files"
		rm /etc/snd_soc_msm/snd_soc_msm_auxpcm 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_2x_auxpcm 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_2x_mpq_auxpcm 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_2x_Fusion3_auxpcm 2>/dev/null
		rm /etc/snd_soc_msm/snd_soc_msm_Sitar_auxpcm 2>/dev/null
		;;
	    *)
		;;
	esac
        ;;
esac

setprop qcom.audio.init complete
exit 0

