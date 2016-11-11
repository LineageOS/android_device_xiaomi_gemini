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

# Update the panel color property and Leds brightness 
for i in $(seq 5); do
    if [ -f /sys/bus/i2c/devices/12-004a/panel_color ]; then
	# Atmel mXT
	color=`cat /sys/bus/i2c/devices/12-004a/panel_color`
	if [ -n "$color" ]; then
	    break
	else
	    sleep 1
	    continue
	fi
    elif [ -f /sys/bus/i2c/devices/12-0020/panel_color ]; then
	# Synaptics DSX
	color=`cat /sys/bus/i2c/devices/12-0020/panel_color`
	if [ -n "$color" ]; then
	    break
	else
	    sleep 1
	    continue
	fi
    else
	color="0"
	sleep 1
    fi
done

case "$color" in
    "1")
        setprop sys.panel.color WHITE
	echo 40 > /sys/class/leds/red/max_brightness
        echo 60 > /sys/class/leds/green/max_brightness
        echo 60 > /sys/class/leds/blue/max_brightness
        ;;
    "2")
        setprop sys.panel.color BLACK
	echo 35 > /sys/class/leds/red/max_brightness
        echo 75 > /sys/class/leds/green/max_brightness
        echo 40 > /sys/class/leds/blue/max_brightness
        ;;
    "7")
        setprop sys.panel.color PURPLE
	echo 40 > /sys/class/leds/red/max_brightness
        echo 140 > /sys/class/leds/green/max_brightness
        echo 120 > /sys/class/leds/blue/max_brightness
        ;;
    "8")
        setprop sys.panel.color GOLDEN
	echo 45 > /sys/class/leds/red/max_brightness
        echo 80 > /sys/class/leds/green/max_brightness
        echo 70 > /sys/class/leds/blue/max_brightness
        ;;
    *)
        setprop sys.panel.color UNKNOWN
	echo 35 > /sys/class/leds/red/max_brightness
        echo 75 > /sys/class/leds/green/max_brightness
        echo 40 > /sys/class/leds/blue/max_brightness
        ;;
esac
