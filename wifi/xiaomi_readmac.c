/*
 * Copyright (C) 2016 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "xiaomi_readmac"
#define LOG_NDEBUG 0

#include <cutils/log.h>

#include <string.h>

#define MAC_ADDR_SIZE 6
#define WLAN_MAC_BIN "/persist/wlan_mac.bin"

extern int qmi_nv_read_wlan_mac(char** mac);

static int check_wlan_mac_bin_file()
{
    char content[1024];
    FILE *fp;

    fp = fopen(WLAN_MAC_BIN, "r");
    if (fp != NULL) {
        memset(content, 0, sizeof(content));
        fread(content, 1, sizeof(content)-1, fp);
        fclose(fp);

        if (strstr(content, "Intf0MacAddress") == NULL) {
            ALOGV("%s is missing Intf0MacAddress entry value", WLAN_MAC_BIN);
            return 1;
        }

        if (strstr(content, "Intf1MacAddress") == NULL) {
            ALOGV("%s is missing Intf1MacAddress entry value", WLAN_MAC_BIN);
            return 1;
        }

        return 0;
    }
    return 1;
}

int main(int argc, char *argv[])
{
    unsigned char wlan_addr[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    char* nv_wlan_mac = NULL;
    int ret, i;
    FILE *fp;

    // Read WLAN MAC address from modem NV
    ret = qmi_nv_read_wlan_mac(&nv_wlan_mac);
    if (!nv_wlan_mac) {
        ALOGE("qmi_nv_read_wlan_mac error %d", ret);
        return 1;
    }
    for (i = 0; i < MAC_ADDR_SIZE; i++) {
        wlan_addr[i] = nv_wlan_mac[i];
    }

    // Store WLAN MAC address in the persist file, if needed
    if (check_wlan_mac_bin_file()) {
        fp = fopen(WLAN_MAC_BIN, "w");
        fprintf(fp, "Intf0MacAddress=%02X%02X%02X%02X%02X%02X\n",
                wlan_addr[0], wlan_addr[1], wlan_addr[2], wlan_addr[3], wlan_addr[4], wlan_addr[5]);
        fprintf(fp, "Intf1MacAddress=%02X%02X%02X%02X%02X%02X\n",
                wlan_addr[0], wlan_addr[1], wlan_addr[2], wlan_addr[3], wlan_addr[4], (unsigned char)(wlan_addr[5]+1));
        fprintf(fp, "END\n");
        fclose(fp);

        ALOGV("%s was successfully generated", WLAN_MAC_BIN);
    } else {
        ALOGV("%s already exists and is valid", WLAN_MAC_BIN);
    }

    return 0;
}
