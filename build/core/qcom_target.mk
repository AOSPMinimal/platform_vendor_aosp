# Set device-specific HALs into project pathmap
define set-device-specific-path
$(if $(USE_DEVICE_SPECIFIC_$(1)), \
    $(if $(DEVICE_SPECIFIC_$(1)_PATH), \
        $(eval path := $(DEVICE_SPECIFIC_$(1)_PATH)), \
        $(eval path := $(TARGET_DEVICE_DIR)/$(2))), \
    $(eval path := $(3))) \
$(call project-set-path,qcom-$(2),$(strip $(path)))
endef

BOARD_USES_QTI_HARDWARE := true

pathmap_PROJ := \
    qcom-audio:hardware/qcom-caf/msm8996/audio \
    qcom-media:hardware/qcom-caf/msm8996/media \
    qcom-wlan:hardware/qcom-caf/wlan \
    qcom-display:hardware/qcom-caf/msm8996/display \
    qcom-bt-vendor:hardware/qcom-caf/bt \
    qcom-data-ipa-cfg-mgr:vendor/qcom/opensource/data-ipa-cfg-mgr \
    qcom-dataservices:vendor/qcom/opensource/dataservices \
    qcom-thermal-hardware/qcom-caf/thermal \
    qcom-vr:hardware/qcom-caf/vr

$(call set-device-specific-path,AUDIO,audio,hardware/qcom-caf/msm8996/audio)
$(call set-device-specific-path,DISPLAY,display,hardware/qcom-caf/msm8996/display)
$(call set-device-specific-path,MEDIA,media,hardware/qcom-caf/msm8996/media)

$(call set-device-specific-path,BT_VENDOR,bt-vendor,hardware/qcom-caf/bt)
$(call set-device-specific-path,DATA_IPA_CFG_MGR,data-ipa-cfg-mgr,vendor/qcom/opensource/data-ipa-cfg-mgr)
$(call set-device-specific-path,DATASERVICES,dataservices,vendor/qcom/opensource/dataservices)
$(call set-device-specific-path,THERMAL,thermal,hardware/qcom-caf/thermal)
$(call set-device-specific-path,VR,vr,hardware/qcom-caf/vr)
$(call set-device-specific-path,WLAN,wlan,hardware/qcom-caf/wlan)

PRODUCT_CFI_INCLUDE_PATHS += \
    hardware/qcom-caf/wlan/qcwcn/wpa_supplicant_8_lib

#
# Returns the path to the requested module's include directory,
# relative to the root of the source tree.  Does not handle external
# modules.
#
# $(1): a list of modules (or other named entities) to find the includes for
#
define include-path-for
$(foreach n,$(1),$(patsubst $(n):%,%,$(filter $(n):%,$(pathmap_INCL))))
endef

# Enter project path into pathmap
#
# $(1): name
# $(2): path
#
define project-set-path
$(eval pathmap_PROJ += $(1):$(2))
endef

# Returns the path to the requested module's include directory,
# relative to the root of the source tree.
#
# $(1): a list of modules (or other named entities) to find the projects for
define project-path-for
$(foreach n,$(1),$(patsubst $(n):%,%,$(filter $(n):%,$(pathmap_PROJ))))
endef

include vendor/aosp/build/core/utils.mk
