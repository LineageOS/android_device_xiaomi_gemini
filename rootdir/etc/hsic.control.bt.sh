#!/system/bin/sh
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
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

action=`getprop bluetooth.hsic_ctrl`
last_action=`getprop hsic_ctrl.last`
wifi_status=`getprop wlan.driver.status`
wifi_action=`getprop wlan.hsic_ctrl`
wifi_type=`getprop wlan.driver.ath`

# check action from bt
if [ $wifi_type == "2" ]; then
    if [ $action == "load_wlan" ]; then
        if [ $wifi_status == "ok" ] ||
           [ $wifi_action == "wlan_loading" ] ||
           [ $last_action == "load_wlan" ]; then
           echo "Not doing anything as wlan is on or turning on"
           # do nothing
        else
            setprop wlan.hsic_ctrl "service_loading"

            # bind HSIC HCD
            echo msm_hsic_host > /sys/bus/platform/drivers/msm_hsic_host/bind

            # load WLAN driver
            insmod /system/lib/modules/wlan.ko

            # inform WLAN driver bt is on
            echo 1 > /sys/module/wlan/parameters/ath6kl_bt_on

            # unload WLAN driver
            rmmod wlan
            echo "Now hsic power control will be in auto mode"
        fi
    elif [ $action == "unbind_hsic" ]; then
        if [ "$wifi_action" == "wlan_unloading" ] ||
           [ "$last_action" == "unbind_hsic" ]; then
            echo "Not doing anything as wlan is also unloading"
            # do nothing
        else
            # unbind HSIC HCD
            echo msm_hsic_host > /sys/bus/platform/drivers/msm_hsic_host/unbind
            echo "Unbinding HSIC before BT turns off"
        fi
    fi
fi # [ $wifi_type == "2" ]

# set property to done
# setprop bluetooth.hsic_ctrl "done"

# set property to NULL
setprop wlan.hsic_ctrl ""

setprop hsic_ctrl.last $action

