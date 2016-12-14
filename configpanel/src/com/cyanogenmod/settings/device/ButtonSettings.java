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

import android.os.Bundle;
import android.content.Intent;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.SwitchPreference;

import com.cyanogenmod.settings.device.utils.Constants;
import com.cyanogenmod.settings.device.utils.NodePreferenceActivity;

import org.cyanogenmod.internal.util.ScreenType;

public class ButtonSettings extends NodePreferenceActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.button_panel);
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (Constants.FP_HOME_KEY.equals(preference.getKey())) {
            final Intent intent = new Intent(Constants.FP_HOME_INTENT);
            intent.putExtra(Constants.FP_HOME_INTENT_EXTRA, (Boolean) newValue);
            intent.setFlags(Intent.FLAG_RECEIVER_REGISTERED_ONLY);
            sendBroadcast(intent);
            return true;
        }
        return super.onPreferenceChange(preference, newValue);
    }

    @Override
    public void addPreferencesFromResource(int preferencesResId) {
        super.addPreferencesFromResource(preferencesResId);
        // Initialize other preferences
        SwitchPreference b = (SwitchPreference) findPreference(Constants.FP_HOME_KEY);
        b.setOnPreferenceChangeListener(this);
    }
}
