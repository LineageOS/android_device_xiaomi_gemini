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

import cyanogenmod.hardware.CMHardwareManager;
import cyanogenmod.providers.CMSettings;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = KeyHandler.class.getSimpleName();
    private static final boolean DEBUG = true;

    private final Context mContext;

    public KeyHandler(Context context) {
        mContext = context;
    }

    public boolean handleKeyEvent(KeyEvent event) {
        CMHardwareManager hardware = CMHardwareManager.getInstance(mContext);

        boolean fpHomeButtonEnabled = true; // TODO: get "fp_home" preference value from ConfigPanel
        boolean virtualKeysEnabled = hardware.get(CMHardwareManager.FEATURE_KEY_DISABLE);

        if (!hasSetupCompleted()) {
            return false;
        }

        if (event.getKeyCode() == KeyEvent.KEYCODE_HOME) {
            if (event.getScanCode() == 96) {
                // this is the home key event coming from the fingerprint HAL
                if (DEBUG) Log.d(TAG, "Fingerprint home button tapped");
                return virtualKeysEnabled || !fpHomeButtonEnabled;
            }
            if (event.getScanCode() == 102) {
                // this is the real home key event coming from the mechanical button
                if (DEBUG) Log.d(TAG, "Mechanical home button pressed");
                return virtualKeysEnabled || fpHomeButtonEnabled;
            }
        }
        return false;
    }

    private boolean hasSetupCompleted() {
        return CMSettings.Secure.getInt(mContext.getContentResolver(),
                CMSettings.Secure.CM_SETUP_WIZARD_COMPLETED, 0) != 0;
    }
}
