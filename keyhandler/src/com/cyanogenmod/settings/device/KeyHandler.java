/*
 * Copyright (C) 2017 The LineageOS Project
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

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;

import org.cyanogenmod.internal.util.FileUtils;

import cyanogenmod.hardware.CMHardwareManager;
import cyanogenmod.providers.CMSettings;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = KeyHandler.class.getSimpleName();

    private static final String FP_HOME_NODE = "/sys/devices/soc/soc:fpc_fpc1020/enable_key_events";

    private static boolean sScreenTurnedOn = true;
    private static final boolean DEBUG = false;

    private final Context mContext;

    private final BroadcastReceiver mUpdateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
                sScreenTurnedOn = false;
            } else if (intent.getAction().equals(Intent.ACTION_SCREEN_ON)) {
                sScreenTurnedOn = true;
            }
        }
    };

    public KeyHandler(Context context) {
        mContext = context;

        IntentFilter filter = new IntentFilter();
        filter.addAction(Intent.ACTION_SCREEN_OFF);
        filter.addAction(Intent.ACTION_SCREEN_ON);
        mContext.registerReceiver(mUpdateReceiver, filter);
    }

    public boolean handleKeyEvent(KeyEvent event) {
        CMHardwareManager hardware = CMHardwareManager.getInstance(mContext);
        boolean virtualKeysEnabled = hardware.get(CMHardwareManager.FEATURE_KEY_DISABLE);
        boolean fingerprintHomeButtonEnabled = FileUtils.readOneLine(FP_HOME_NODE).equals("1");

        if (!hasSetupCompleted()) {
            return false;
        }

        if (event.getKeyCode() == KeyEvent.KEYCODE_HOME) {
            if (event.getScanCode() == 96) {
                if (DEBUG) Log.d(TAG, "Fingerprint home button tapped");
                return virtualKeysEnabled;
            }
            if (event.getScanCode() == 102) {
                if (DEBUG) Log.d(TAG, "Mechanical home button pressed");
                return sScreenTurnedOn &&
                        (virtualKeysEnabled || fingerprintHomeButtonEnabled);
            }
        }
        return false;
    }

    private boolean hasSetupCompleted() {
        return Settings.Secure.getInt(mContext.getContentResolver(),
                Settings.Secure.USER_SETUP_COMPLETE, 0) != 0;
    }
}
