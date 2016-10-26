#!/system/bin/sh
# Copyright (c) 2009-2015, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

start_msm_irqbalance()
{
	if [ -f /system/bin/msm_irqbalance ]; then
		start msm_irqbalance
	fi
}

start_copying_prebuilt_qcril_db()
{
    if [ -f /system/vendor/qcril.db -a ! -f /data/misc/radio/qcril.db ]; then
        cp /system/vendor/qcril.db /data/misc/radio/qcril.db
        chown -h radio.radio /data/misc/radio/qcril.db
    fi
}

bootmode=`getprop ro.bootmode`
emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        if [ "$bootmode" != "charger" ]; then # start rmt_storage and rfs_access
            start rmt_storage
            start rfs_access
        fi
    ;;
esac

# Set shared touchpanel nodes ownership (these are proc_symlinks to the real sysfs nodes)
chown -LR system.system /proc/touchpanel

#
# Copy qcril.db if needed for RIL
#
start_copying_prebuilt_qcril_db
echo 1 > /data/misc/radio/db_check_done

#
# Make modem config folder and copy firmware config to that folder for RIL
#
if [ -f /data/misc/radio/ver_info.txt ]; then
    prev_version_info=`cat /data/misc/radio/ver_info.txt`
else
    prev_version_info=""
fi

cur_version_info=`cat /firmware/verinfo/ver_info.txt`
if [ ! -f /firmware/verinfo/ver_info.txt -o "$prev_version_info" != "$cur_version_info" ]; then
    rm -rf /data/misc/radio/modem_config
    mkdir /data/misc/radio/modem_config
    chmod 770 /data/misc/radio/modem_config
    cp -r /system/etc/firmware/modem_pr/mcfg/configs/* /data/misc/radio/modem_config
    chown -hR radio.radio /data/misc/radio/modem_config
    cp /firmware/verinfo/ver_info.txt /data/misc/radio/ver_info.txt
    chown radio.radio /data/misc/radio/ver_info.txt
fi
cp /firmware/image/modem_pr/mbn_ota.txt /data/misc/radio/modem_config
chown radio.radio /data/misc/radio/modem_config/mbn_ota.txt
echo 1 > /data/misc/radio/copy_complete

# Check build variant for printk logging
# Current default minimum boot-time-default
buildvariant=`getprop ro.build.type`
case "$buildvariant" in
    "userdebug" | "eng")
        #set default loglevel to KERN_INFO
        echo "6 6 1 7" > /proc/sys/kernel/printk
        ;;
    *)
        #set default loglevel to KERN_WARNING
        echo "4 4 1 4" > /proc/sys/kernel/printk
        ;;
esac
