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

import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.hardware.input.InputManager;
import android.os.Build;
import android.os.IBinder;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.SystemClock;
import android.os.UserHandle;
import android.preference.PreferenceManager;
import android.service.gesture.IGestureService;
import android.util.Log;
import android.view.InputDevice;
import android.view.InputEvent;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;

import java.io.File;

import com.cyanogenmod.settings.device.utils.Constants;

import org.cyanogenmod.internal.util.FileUtils;

public class Startup extends BroadcastReceiver {

    private static final String TAG = Startup.class.getSimpleName();

    @Override
    public void onReceive(final Context context, final Intent intent) {
        final String action = intent.getAction();
        if (cyanogenmod.content.Intent.ACTION_INITIALIZE_CM_HARDWARE.equals(action)) {

            // Disable button settings if needed
            if (!hasButtonProcs()) {
                disableComponent(context, ButtonSettings.class.getName());
            } else {
                enableComponent(context, ButtonSettings.class.getName());

                // Restore nodes to saved preference values
                for (String pref : Constants.sButtonPrefKeys) {
                    String value;
                    String node;
                    if (Constants.sStringNodePreferenceMap.containsKey(pref)) {
                        value = Constants.getPreferenceString(context, pref);
                        node = Constants.sStringNodePreferenceMap.get(pref);
                    } else {
                        value = Constants.isPreferenceEnabled(context, pref) ?
                                "1" : "0";
                        node = Constants.sBooleanNodePreferenceMap.get(pref);
                    }
                    if (!FileUtils.writeLine(node, value)) {
                        Log.w(TAG, "Write to node " + node +
                            " failed while restoring saved preference values");
                    }
                }
            }
	}
    }

    private void sendInputEvent(InputEvent event) {
        InputManager inputManager = InputManager.getInstance();
        inputManager.injectInputEvent(event,
                InputManager.INJECT_INPUT_EVENT_MODE_WAIT_FOR_FINISH);
    }

    static boolean hasButtonProcs() {
        return (new File(Constants.BUTTON_SWAP_NODE).exists() ||
            new File(Constants.FP_HOME_NODE).exists());
    }

    private void disableComponent(Context context, String component) {
        ComponentName name = new ComponentName(context, component);
        PackageManager pm = context.getPackageManager();
        pm.setComponentEnabledSetting(name,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP);
    }

    private void enableComponent(Context context, String component) {
        ComponentName name = new ComponentName(context, component);
        PackageManager pm = context.getPackageManager();
        if (pm.getComponentEnabledSetting(name)
                == PackageManager.COMPONENT_ENABLED_STATE_DISABLED) {
            pm.setComponentEnabledSetting(name,
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                    PackageManager.DONT_KILL_APP);
        }
    }
}
