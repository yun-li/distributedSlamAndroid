APP_STL := gnustl_static

# Android >= v2.3
APP_PLATFORM := android-9

# Build ARMv7-A and arm64-v8a machine code.
APP_ABI :=  arm64-v8a armeabi-v7a
APP_CFLAGS := -O3 -ftree-vectorize -ffast-math -funroll-loops

APP_CFLAGS += -fPIC


ifeq ($(TARGET_ARCH),arm64)
	APP_CFLAGS += -march=armv8-a -DHAVE_NEON=1 -flax-vector-conversions
else
ifeq ($(TARGET_ARCH),arm)
	APP_CFLAGS += -march=armv7-a -mfloat-abi=softfp -mtune=cortex-a9 -mfpu=vfp  -mfpu=neon -DHAVE_NEON=1 -flax-vector-conversions
endif
endif

APP_CPPFLAGS += -frtti

#$(call __ndk_info,APP_CFLAGS=$(APP_CFLAGS))
#$(call __ndk_info,APP_CPPFLAGS=$(APP_CPPFLAGS))

#-fsingle-precision-constant
