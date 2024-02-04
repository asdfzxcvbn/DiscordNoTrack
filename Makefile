TARGET := iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = Discord
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DiscordNoTrack

$(TWEAK_NAME)_FILES = DiscordNoTrack.xm dummyDelegate.m
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_LOGOS_DEFAULT_GENERATOR = internal

include $(THEOS_MAKE_PATH)/tweak.mk
