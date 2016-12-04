/*=============================================================================
  Copyright (c) 2016, The Linux Foundation. All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:
  * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.
  * Neither the name of The Linux Foundation nor the names of its
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  =============================================================================*/

#ifndef __IZATREMOTEAPIS_H__
#define __IZATREMOTEAPIS_H__

#include <gps_extended_c.h>

namespace qc_loc_fw {
    class InPostcard;
}

namespace izat_remote_api {

class IzatNotifierProxy;

struct OutCard;

class IzatNotifier  {
protected:
    IzatNotifierProxy* const mNotifierProxy;
    IzatNotifier(const char* const tag, const OutCard* subCard);
    virtual ~IzatNotifier();
public:
    virtual void handleMsg(qc_loc_fw::InPostcard * const in_card) = 0;
};


class LocationUpdater : public IzatNotifier {
    static const char* const sLatTag;
    static const char* const sLonTag;
    static const char* const sAccuracyTag;
    static const OutCard* sSubscriptionCard;
protected:
    inline LocationUpdater() : IzatNotifier(sName, sSubscriptionCard) {}
    virtual inline ~LocationUpdater() {}
public:
    static const char sName[];
    virtual void handleMsg(qc_loc_fw::InPostcard * const in_card) final;
    virtual void locationUpdate(UlpLocation& location, GpsLocationExtended& locExtended) = 0;
};

class SstpUpdater : public IzatNotifier {
    static const char* const sLatTag;
    static const char* const sLonTag;
    static const char* const sUncTag;
    static const char* const sUncConfTag;

protected:
    inline SstpUpdater() : IzatNotifier(sName, nullptr) {}
    virtual inline ~SstpUpdater() {}
public:
    static const char sName[];
    virtual void handleMsg(qc_loc_fw::InPostcard * const in_card) final;
    void stop();
    virtual void errReport(const char* errStr) = 0;
    virtual void siteUpdate(const char* name, double lat, double lon,
                            float unc, int32_t uncConfidence) = 0;
    virtual void mccUpdate(uint32_t mcc, const char* confidence) = 0;
};

} // izat_remote_api

#endif //__IZATREMOTEAPIS_H__

