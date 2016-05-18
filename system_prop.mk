# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.disable=0 \
    audio.offload.buffer.size.kb=32 \
    audio.offload.video=true \
    audio.offload.pcm.16bit.enable=true \
    audio.offload.pcm.24bit.enable=true \
    audio.offload.track.enable=false \
    audio.offload.multiaac.enable=true \
    audio.offload.multiple.enabled=false \
    audio.offload.gapless.enabled=true \
    audio.deep_buffer.media=true \
    audio.safx.pbe.enabled=true \
    audio.parser.ip.buffer.size=262144 \
    audio.dolby.ds2.enabled=false \
    audio.dolby.ds2.hardbypass=false \
    tunnel.audio.encode=true \
    use.voice.path.for.pcm.voip=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.audio.ssr=false \
    ro.qc.sdk.audio.fluencetype=fluence \
    persist.audio.fluence.voicecall=true \
    persist.audio.fluence.voicerec=false \
    persist.audio.fluence.speaker=true \
    persist.audio.ssr.3mic=false

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    ro.btconfig.if=uart \
    ro.btconfig.vendor=qcom \
    ro.btconfig.chip=QCA6164 \
    ro.btconfig.dev=/dev/ttyHS0 \
    qcom.bluetooth.soc=rome

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.stats.test=5

# CNE and DPM
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1 \
    persist.dpm.feature=5 \
    persist.dpm.nsrm.bkg.evt=3955 \
    persist.env.fastdorm.enabled=false

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    debug.egl.hw=1 \
    debug.mdpcomp.logs=0 \
    debug.sf.hw=1 \
    dev.pm.dyn_samplingrate=1 \
    persist.hwc.mdpcomp.enable=true \
    debug.gralloc.enable_fb_ubwc=1
    ro.opengles.version=196609 \
    ro.sf.lcd_density=480

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=1 \
    ro.gps.agps_provider=1

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    media.aac_51_output_enabled=true \
    media.stagefright.enable-player=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-aac=true \
    media.stagefright.enable-qcp=true \
    media.stagefright.enable-fma2dp=true \
    media.stagefright.enable-scan=true \
    mm.enable.smoothstreaming=true \
    mmp.enable.3g2=true \
    mm.enable.qcom_parser=1048575 \
    persist.mm.enable.prefetch=true

# NFC
PRODUCT_PROPERTY_OVERRIDES += \
    ro.nfc.port=I2C \
    persist.nfc.smartcard.config=SIM1,SIM2,eSE1

# NITZ
PRODUCT_PROPERTY_OVERRIDES += \
    persist.rild.nitz_plmn="" \
    persist.rild.nitz_long_ons_0="" \
    persist.rild.nitz_long_ons_1="" \
    persist.rild.nitz_long_ons_2="" \
    persist.rild.nitz_long_ons_3="" \
    persist.rild.nitz_short_ons_0="" \
    persist.rild.nitz_short_ons_1="" \
    persist.rild.nitz_short_ons_2="" \
    persist.rild.nitz_short_ons_3=""

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so

# Qualcomm
PRODUCT_PROPERTY_OVERRIDES += \
    com.qc.hardware=true \
    ro.qc.sdk.sensors.gestures=true

# Qualcomm Assertive Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qualcomm.cabl=0 \
    ro.qcom.ad=1 \
    ro.qcom.ad.calib.data=/system/etc/calib.cfg \
    ro.qcom.ad.sensortype=2

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    DEVICE_PROVISIONED=1 \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    ril.subscription.types=RUIM \
    ro.baseband.arch=msm \
    ro.ril.gprsclass=10 \
    ro.ril.hsxpa=1 \
    ro.telephony.default_network=20 \
    ro.telephony.default_cdma_sub=0 \
    ro.telephony.call_ring.multiple=false \
    ro.use_data_netmgrd=true \
    persist.data.netmgrd.qos.enable=true \
    persist.data.mode=concurrent \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1 \
    persist.fd.scroff.timer=3000 \
    persist.fd.scron.timer=10000 \
    persist.logd.size.radio=4M \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.calls.on.ims=0 \
    persist.radio.jbims=0 \
    persist.radio.csvt.enabled=false \
    persist.radio.data_no_toggle=1 \
    persist.radio.force_on_dc=true \
    persist.radio.rat_on=combine \
    persist.radio.mt_sms_ack=20 \
    persist.radio.multisim.config=dsds \
    persist.radio.custom_ecc=1 \
    persist.radio.sib16_support=1 \
    persist.radio.NO_STAPA=1 \
    persist.radio.VT_HYBRID_ENABLE=1 \
    sys.ims.DATA_DAEMON_STATUS=1 \
    telephony.lteOnCdmaDevice=1

# Vendor specific
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.gt_library=libqti-gt.so \
    ro.vendor.at_library=libqti-at.so \
    sys.games.gt.prof=1

# Wifi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0

# WiFi display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    sdm.perf_hint_window=50 \
    ro.vendor.wl_library=libqti-wl.so
