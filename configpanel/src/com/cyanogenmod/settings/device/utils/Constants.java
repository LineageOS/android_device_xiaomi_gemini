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

package com.cyanogenmod.settings.device.utils;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.preference.SwitchPreference;

public class Constants {

    // Preference keys
    public static final String BUTTON_SWAP_KEY = "button_swap";
    public static final String FP_HOME_KEY = "fp_home";
    public static final String FP_WAKEUP_KEY = "fp_wakeup";

    // Nodes
    public static final String BUTTON_SWAP_NODE = "/proc/touchpanel/reversed_keys_enable";
    public static final String FP_WAKEUP_NODE = "/sys/devices/soc/soc:fpc_fpc1020/enable_wakeup";
    public static final String VIRTUAL_KEYS_NODE = "/proc/touchpanel/capacitive_keys_enable";

    // Intents
    public static final String FP_HOME_CUSTOM_INTENT = "com.cyanogenmod.settings.device.FP_HOME_SETTING";
    public static final String FP_HOME_CUSTOM_INTENT_EXTRA = "fp_home_pref_value";

    // Holds <preference_key> -> <proc_node> mapping
    public static final Map<String, String> sBooleanNodePreferenceMap = new HashMap<>();
    public static final Map<String, String> sStringNodePreferenceMap = new HashMap<>();

    // Holds <preference_key> -> <default_values> mapping
    public static final Map<String, Object> sNodeDefaultMap = new HashMap<>();

    // Holds <preference_key> -> <user_set_values> mapping
    public static final Map<String, Object[]> sNodeUserSetValuesMap = new HashMap<>();

    // Holds <preference_key> -> <dependency_check> mapping
    public static final Map<String, String[]> sNodeDependencyMap = new HashMap<>();

    public static final String[] sButtonPrefKeys = {
        BUTTON_SWAP_KEY,
        FP_WAKEUP_KEY,
    };

    static {
        sBooleanNodePreferenceMap.put(BUTTON_SWAP_KEY, BUTTON_SWAP_NODE);
        sBooleanNodePreferenceMap.put(FP_WAKEUP_KEY, FP_WAKEUP_NODE);

        sNodeDefaultMap.put(BUTTON_SWAP_KEY, false);
        sNodeDefaultMap.put(FP_WAKEUP_KEY, true);

        sNodeDependencyMap.put(FP_HOME_KEY, new String[]{ VIRTUAL_KEYS_NODE, "1" });
    }

    public static boolean isPreferenceEnabled(Context context, String key) {
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        return preferences.getBoolean(key, (Boolean) sNodeDefaultMap.get(key));
    }

    public static String getPreferenceString(Context context, String key) {
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        return preferences.getString(key, (String) sNodeDefaultMap.get(key));
    }

    public static void updateDependentPreference(Context context, SwitchPreference b,
            String key, Boolean shouldSetEnabled) {
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        boolean prefActualValue = preferences.getBoolean(key, false);

        if (shouldSetEnabled) {
            if (sNodeUserSetValuesMap.get(key) != null &&
                    (Boolean) sNodeUserSetValuesMap.get(key)[1] &&
                    (Boolean) sNodeUserSetValuesMap.get(key)[1] != prefActualValue) {
                b.setChecked(true);
                sNodeUserSetValuesMap.put(key, new Boolean[]{ prefActualValue, false });
            }
        } else {
            if (b.isEnabled() && prefActualValue)
                sNodeUserSetValuesMap.put(key, new Boolean[]{ prefActualValue, true });
            b.setEnabled(false);
            b.setChecked(false);
        }
    }
}
