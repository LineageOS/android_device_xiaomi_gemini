#!/system/bin/sh
# Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
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

dir0=/data/usf
pcm_ind_file=$dir0/pcm_inds.txt
pcm_file=/proc/asound/pcm

tx_rx_patterns=(tx2- rx2-)
dev_ids=("0" "0")
cards=("0" "0")
found_num=0

# Run usf_settings script
if [ -f /system/etc/usf_settings.sh ]; then
  /system/bin/sh /system/etc/usf_settings.sh
fi

while read pcm_entry; do
    for i in 0 1; do
        echo $pcm_entry
        id="${pcm_entry##*"${tx_rx_patterns[$i]}"}"
        case "$pcm_entry" in
            "$id")
            ;;

            *)
            cards[$i]=${pcm_entry:0:2}
            dev_ids[$i]=${pcm_entry:3:2}
            found_num=$(( $found_num + 1))
            i=2
            ;;
        esac

        case $i in
            2)
            break
            ;;
        esac
    done

    case $found_num in
        2)
        break
        ;;
    esac

done < $pcm_file

echo ${dev_ids[0]}" "${dev_ids[1]}" "${cards[0]}" "${cards[1]}>$pcm_ind_file
chmod 0644 $pcm_ind_file

# Post-boot start of selected USF based calculators
for i in $(cat $dir0/auto_start.txt); do
   start $i
done
