ifeq ($(shell [ -f ./theos/LICENSE ] && echo 1 || echo 0), 0)
all clean package install stage::
	git submodule update --init --recursive
	$(MAKE) $(MAKEFLAGS) MAKELEVEL=0 $@
else

export ARCHS = armv7 arm64

include theos/makefiles/common.mk

TOOL_NAME = gpscoords
gpscoords_FILES = main.mm
gpscoords_FRAMEWORKS = CoreLocation
gpscoords_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tool.mk

endif