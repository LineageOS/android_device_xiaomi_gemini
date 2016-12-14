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

import android.os.Bundle;
import android.content.SharedPreferences;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceManager;
import android.preference.PreferenceActivity;
import android.preference.ListPreference;
import android.preference.SwitchPreference;
import android.text.TextUtils;
import android.view.MenuItem;

import java.io.File;

import org.cyanogenmod.internal.util.FileUtils;
import org.cyanogenmod.internal.util.ScreenType;

public class NodePreferenceActivity extends PreferenceActivity
        implements OnPreferenceChangeListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    protected void onResume() {
        super.onResume();
        updatePreferencesBasedOnDependencies();

        // If running on a phone, remove padding around the listview
        if (!ScreenType.isTablet(this)) {
            getListView().setPadding(0, 0, 0, 0);
        }
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        String node = Constants.sBooleanNodePreferenceMap.get(preference.getKey());
        if (!TextUtils.isEmpty(node)) {
            Boolean value = (Boolean) newValue;
            FileUtils.writeLine(node, value ? "1" : "0");
            return true;
        }
        node = Constants.sStringNodePreferenceMap.get(preference.getKey());
        if (!TextUtils.isEmpty(node)) {
            FileUtils.writeLine(node, (String) newValue);
            return true;
        }
        return false;
    }

    @Override
    public void addPreferencesFromResource(int preferencesResId) {
        super.addPreferencesFromResource(preferencesResId);
        // Initialize node preferences
        for (String pref : Constants.sBooleanNodePreferenceMap.keySet()) {
            SwitchPreference b = (SwitchPreference) findPreference(pref);
            if (b == null) continue;
            b.setOnPreferenceChangeListener(this);
            String node = Constants.sBooleanNodePreferenceMap.get(pref);
            if (new File(node).exists()) {
                String curNodeValue = FileUtils.readOneLine(node);
                b.setChecked(curNodeValue.equals("1"));
            } else {
                b.setEnabled(false);
            }
        }
        for (String pref : Constants.sStringNodePreferenceMap.keySet()) {
            ListPreference l = (ListPreference) findPreference(pref);
            if (l == null) continue;
            l.setOnPreferenceChangeListener(this);
            String node = Constants.sStringNodePreferenceMap.get(pref);
            if (new File(node).exists()) {
                l.setValue(FileUtils.readOneLine(node));
            } else {
                l.setEnabled(false);
            }
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
        // Respond to the action bar's Up/Home button
        case android.R.id.home:
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void updatePreferencesBasedOnDependencies() {
        for (String pref : Constants.sNodeDependencyMap.keySet()) {
            SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
            SwitchPreference b = (SwitchPreference) findPreference(pref);
            if (b == null) continue;
            String dependencyNode = Constants.sNodeDependencyMap.get(pref)[0];
            if (new File(dependencyNode).exists()) {
                String dependencyNodeValue = FileUtils.readOneLine(dependencyNode);
                boolean shouldSetEnabled = dependencyNodeValue.equals(
                        Constants.sNodeDependencyMap.get(pref)[1]);
                boolean actualPrefValue = prefs.getBoolean(pref, false);
                if (shouldSetEnabled) {
                    if (Constants.sNodeUserSetValuesMap.get(pref) != null &&
                            (Boolean) Constants.sNodeUserSetValuesMap.get(pref)[1] &&
                            (Boolean) Constants.sNodeUserSetValuesMap.get(pref)[1] != actualPrefValue) {
                        b.setChecked(true);
                        Boolean[] prefValueAndToggleFlag = { actualPrefValue, false };
                        Constants.sNodeUserSetValuesMap.put(pref, prefValueAndToggleFlag);
                    }
                } else {
                    if (b.isEnabled() && actualPrefValue) {
                        Boolean[] prefValueAndToggleFlag = { actualPrefValue, true };
                        Constants.sNodeUserSetValuesMap.put(pref, prefValueAndToggleFlag);
                    }
                    b.setEnabled(false);
                    b.setChecked(false);
                }
            }
        }
    }
}
