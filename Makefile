ifeq ($(ROOTHIDE),1)
THEOS_PACKAGE_SCHEME = roothide
else ifeq ($(ROOTLESS),1)
THEOS_PACKAGE_SCHEME = rootless
endif

DEBUG=0
FINALPACKAGE=1
INSTALL_TARGET_PROCESSES = YouTube
export ARCHS = arm64
export TARGET := iphone:clang::26.0
PACKAGE_VERSION = 0.0.1

# ── HARDENED SYSTEM FLAGS ───────────────────────────────────────────────────
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = GlassTab
$(TWEAK_NAME)_FILES = $(wildcard *.xm)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

# roothide/theos maps the rootless path macros to jbroot automatically.
# Silence the "have you read the docs" warning.
ifeq ($(THEOS_PACKAGE_SCHEME),roothide)
$(TWEAK_NAME)_CFLAGS += -DDISABLE_ROOTLESS_COMPAT_WARNING
endif

$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

clean::
	rm -rf .theos .DS_Store
