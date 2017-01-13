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

package com.android.internal.telephony;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Parcel;

/**
 * Custom Qualcomm RIL for Xiaomi Mi 5
 *
 * {@hide}
 */
public class GeminiRIL extends RIL implements CommandsInterface {

    public GeminiRIL(Context context, int preferredNetworkType, int cdmaSubscription) {
        super(context, preferredNetworkType, cdmaSubscription);
    }

    public GeminiRIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        super(context, preferredNetworkType, cdmaSubscription, instanceId);
    }

    @Override
    protected RILRequest
    processSolicited (Parcel p) {
        int serial, error;
        boolean found = false;
        int dataPosition = p.dataPosition(); // Save off position within the parcel
        serial = p.readInt();
        error = p.readInt();
        RILRequest rr = null;

        // Pre-process the reply before popping it
        synchronized (mRequestList) {
            RILRequest tr = mRequestList.get(serial);
            if (tr != null && tr.mSerial == serial) {
                if (error == 0 || p.dataAvail() > 0) {
                    try {
                        switch (tr.mRequest) {
                            // Get those we're interested in
                            case RIL_REQUEST_DATA_REGISTRATION_STATE:
                                rr = tr;
                                break;
                        }
                    } catch (Throwable thr) {
                        // Exceptions here usually mean invalid RIL responses
                        if (tr.mResult != null) {
                            AsyncResult.forMessage(tr.mResult, null, thr);
                            tr.mResult.sendToTarget();
                        }
                        return tr;
                    }
                }
            }
        }

        if (rr == null) {
            // Nothing we care about, go up
            p.setDataPosition(dataPosition);

            // Forward responses that we're not overriding to the super class
            return super.processSolicited(p);
        }
        rr = findAndRemoveRequestFromList(serial);
        if (rr == null) {
            return rr;
        }

        Object ret = null;
        if (error == 0 || p.dataAvail() > 0) {
            switch (rr.mRequest) {
                case RIL_REQUEST_DATA_REGISTRATION_STATE:
                    ret = responseDataRegistrationState(p);
                    break;
                default:
                    throw new RuntimeException("Unrecognized solicited response: " + rr.mRequest);
            }
            //break;
        }
        if (RILJ_LOGD) riljLog(rr.serialString() + "< " + requestToString(rr.mRequest)
                               + " " + retToString(rr.mRequest, ret));
        if (rr.mResult != null) {
            AsyncResult.forMessage(rr.mResult, ret, null);
            rr.mResult.sendToTarget();
        }

        return rr;
    }

    private Object
    responseDataRegistrationState(Parcel p) {
        String response[] = (String[]) responseStrings(p); // All data from parcel get popped

        /* Our RIL reports a value of 20 for DC-HSPAP.
           However, this isn't supported in AOSP. So, map it to HSPAP instead */
        if (response.length > 4 && response[0].equals("1") && response[3].equals("20")) {
            response[3] = "15";
        }

        return response;
    }
}
