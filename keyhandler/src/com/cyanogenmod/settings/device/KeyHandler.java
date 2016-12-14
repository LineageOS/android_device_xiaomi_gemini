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

package com.cyanogenmod.settings.device;

import android.content.Context;
import android.util.Log;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;

import cyanogenmod.providers.CMSettings;
import org.cyanogenmod.internal.util.FileUtils;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = KeyHandler.class.getSimpleName();
    private static final String VIRTUAL_KEYS_NODE = "/proc/touchpanel/capacitive_keys_enable";
    private static final String FP_HOME_NODE = "/sys/devices/soc/soc:fpc_fpc1020/homebutton";
    private static final boolean DEBUG = true;

    private final Context mContext;

    public KeyHandler(Context context) {
        mContext = context;
    }

    private boolean hasSetupCompleted() {
        return CMSettings.Secure.getInt(mContext.getContentResolver(),
                CMSettings.Secure.CM_SETUP_WIZARD_COMPLETED, 0) != 0;
    }

    public boolean handleKeyEvent(KeyEvent event) {
        boolean fpHomeButtonEnabled = FileUtils.readOneLine(FP_HOME_NODE).equals("1");
        boolean virtualKeysEnabled = FileUtils.readOneLine(VIRTUAL_KEYS_NODE).equals("0");

        if (!hasSetupCompleted()) {
            return false;
        }

        if (event.getKeyCode() == KeyEvent.KEYCODE_HOME) {
            if (event.getScanCode() == 96 && (virtualKeysEnabled || !fpHomeButtonEnabled)) {
                // this is the home key event coming from the fingerprint HAL
                if (DEBUG) Log.d(TAG, "Fingerprint home button tapped");
                return true;
            }
            if (event.getScanCode() == 102 && fpHomeButtonEnabled) {
                // this is the real home key event coming from the mechanical button
                if (DEBUG) Log.d(TAG, "Mechanical home button pressed.");
                return true;
            }
        }

        return false;
    }
}
