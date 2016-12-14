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

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.UserHandle;
import android.util.Log;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;

import cyanogenmod.hardware.CMHardwareManager;
import cyanogenmod.providers.CMSettings;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = KeyHandler.class.getSimpleName();
    private static final String FP_HOME_INTENT = "com.cyanogenmod.settings.device.FP_HOME_SETTING";
    private static final String FP_HOME_INTENT_EXTRA = "fp_home_pref_value";

    private static boolean mFingerprintHomeButtonEnabled;
    private static boolean mScreenTurnedOn = true;
    private static int mLongPressOnHomeBehavior = -1;
    private static final int KEY_ACTION_NOTHING = 0;
    private static final boolean DEBUG = false;

    private final Context mContext;

    private final BroadcastReceiver mUpdateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(FP_HOME_INTENT)) {
                mFingerprintHomeButtonEnabled = intent.getBooleanExtra(
                        FP_HOME_INTENT_EXTRA, false);
                if (mFingerprintHomeButtonEnabled) {
                    CMSettings.System.putIntForUser(mContext.getContentResolver(),
                            CMSettings.System.KEY_HOME_LONG_PRESS_ACTION,
                            mLongPressOnHomeBehavior, UserHandle.USER_CURRENT);
                } else {
                    mLongPressOnHomeBehavior = CMSettings.System.getIntForUser(
                            mContext.getContentResolver(),
                            CMSettings.System.KEY_HOME_LONG_PRESS_ACTION,
                            mLongPressOnHomeBehavior, UserHandle.USER_CURRENT);
                    CMSettings.System.putIntForUser(mContext.getContentResolver(),
                            CMSettings.System.KEY_HOME_LONG_PRESS_ACTION,
                            KEY_ACTION_NOTHING, UserHandle.USER_CURRENT);
                }
            } else if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
                mScreenTurnedOn = false;
            } else if (intent.getAction().equals(Intent.ACTION_SCREEN_ON)) {
                mScreenTurnedOn = true;
            }
        }
    };

    public KeyHandler(Context context) {
        mContext = context;

        mContext.registerReceiver(mUpdateReceiver, new IntentFilter(FP_HOME_INTENT));
        IntentFilter filter = new IntentFilter();
        filter.addAction(Intent.ACTION_SCREEN_OFF);
        filter.addAction(Intent.ACTION_SCREEN_ON);
        mContext.registerReceiver(mUpdateReceiver, filter);

        mLongPressOnHomeBehavior = CMSettings.System.getIntForUser(mContext.getContentResolver(),
                CMSettings.System.KEY_HOME_LONG_PRESS_ACTION,
                mLongPressOnHomeBehavior, UserHandle.USER_CURRENT);
    }

    public boolean handleKeyEvent(KeyEvent event) {
        CMHardwareManager hardware = CMHardwareManager.getInstance(mContext);
        boolean virtualKeysEnabled = hardware.get(CMHardwareManager.FEATURE_KEY_DISABLE);

        if (!hasSetupCompleted()) {
            return false;
        }

        if (event.getKeyCode() == KeyEvent.KEYCODE_HOME) {
            if (event.getScanCode() == 96) {
                // this is the home key event coming from the fingerprint HAL
                if (DEBUG) Log.d(TAG, "Fingerprint home button tapped");

                if (!mFingerprintHomeButtonEnabled) {
                    // ensure that long press on home button is disabled
                    CMSettings.System.putIntForUser(mContext.getContentResolver(),
                            CMSettings.System.KEY_HOME_LONG_PRESS_ACTION,
                            KEY_ACTION_NOTHING, UserHandle.USER_CURRENT);
                }
                return virtualKeysEnabled || !mFingerprintHomeButtonEnabled;
            }
            if (event.getScanCode() == 102) {
                // this is the real home key event coming from the mechanical button
                if (DEBUG) Log.d(TAG, "Mechanical home button pressed");

                return mScreenTurnedOn &&
                        (virtualKeysEnabled || mFingerprintHomeButtonEnabled);
            }
        }
        return false;
    }

    private boolean hasSetupCompleted() {
        return CMSettings.Secure.getInt(mContext.getContentResolver(),
                CMSettings.Secure.CM_SETUP_WIZARD_COMPLETED, 0) != 0;
    }
}
