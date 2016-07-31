# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio_hal.period_size=192 \
    audio.offload.buffer.size.kb=32 \
    audio.offload.video=true \
    audio.offload.pcm.16bit.enable=true \
    audio.offload.pcm.24bit.enable=true \
    audio.offload.track.enable=false \
    audio.offload.multiaac.enable=true \
    audio.offload.multiple.enabled=true \
    audio.offload.passthrough=false \
    audio.offload.gapless.enabled=true \
    audio.deep_buffer.media=true \
    audio.safx.pbe.enabled=true \
    audio.parser.ip.buffer.size=262144 \
    audio.dolby.ds2.enabled=false \
    audio.dolby.ds2.hardbypass=false \
    ro.audio.flinger_standbytime_ms=300 \
    tunnel.audio.encode=true \
    use.voice.path.for.pcm.voip=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.audio.ssr=false \
    ro.qc.sdk.audio.fluencetype=fluence \
    persist.audio.fluence.voicecall=true \
    persist.audio.fluence.voicerec=false \
    persist.audio.fluence.speaker=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    bt.max.hfpclient.connections=1 \
    ro.bluetooth.ftm_enabled=true \
    ro.btconfig.if=uart \
    ro.btconfig.vendor=qcom \
    ro.btconfig.chip=QCA6164 \
    ro.btconfig.dev=/dev/ttyHS0 \
    qcom.bluetooth.soc=rome

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.stats.test=5

# CNE
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1

# Fingerprint
PRODUCT_PROPERTY_OVERRIDES += \
    persist.qfp=false \
    ro.hardware.fingerprint=fpc \
    sys.fpc.tu.disabled=0

# FRP
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/bootdevice/by-name/frp

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    debug.egl.hw=1 \
    debug.mdpcomp.logs=0 \
    debug.gralloc.enable_fb_ubwc=1 \
    debug.sf.hw=1 \
    dev.pm.dyn_samplingrate=1 \
    persist.hwc.mdpcomp.enable=true \
    ro.opengles.version=196609 \
    ro.sf.lcd_density=480 \
    ro.sys.display.support=63

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=1 \
    persist.loc.nlp_name=com.qualcomm.location \
    ro.gps.agps_provider=1

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    media.aac_51_output_enabled=true \
    mm.enable.smoothstreaming=true

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
    ro.min_freq_0=307200 \
    ro.min_freq_2=307200 \
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
    ril.subscription.types=NV,RUIM \
    ro.baseband.arch=msm \
    ro.ril.gprsclass=10 \
    ro.ril.hsxpa=1 \
    ro.telephony.default_network=22,22 \
    ro.telephony.default_cdma_sub=0 \
    ro.telephony.call_ring.multiple=false \
    ro.use_data_netmgrd=true \
    persist.data.netmgrd.qos.enable=true \
    persist.data.mode=concurrent \
    persist.data.qmi.adb_logmask=0 \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1 \
    persist.logd.size.radio=4M \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.force_on_dc=true \
    persist.radio.rat_on=combine \
    persist.radio.multisim.config=dsds \
    persist.radio.custom_ecc=1 \
    persist.radio.sib16_support=1 \
    persist.radio.NO_STAPA=1 \
    persist.radio.VT_HYBRID_ENABLE=1 \
    sys.ims.DATA_DAEMON_STATUS=1 \
    telephony.lteOnCdmaDevice=1,1

# RmNet Data
PRODUCT_PROPERTY_OVERRIDES += \
    persist.rmnet.data.enable=true \
    persist.data.wda.enable=true \
    persist.data.df.dl_mode=5 \
    persist.data.df.ul_mode=5 \
    persist.data.df.agg.dl_pkt=10 \
    persist.data.df.agg.dl_size=4096 \
    persist.data.df.mux_count=8 \
    persist.data.df.iwlan_mux=9 \
    persist.data.df.dev_name=rmnet_usb0

# TimeService
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

# Wifi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0
