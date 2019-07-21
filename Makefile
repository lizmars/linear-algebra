CC = gcc

CFLAGS= -fPIC -O0 -g -Wall -c -fpermissive
CFLAGS_ARM64 = -mcpu=cortex-a8 -march=armv64 -mfpu=neon -marm -c
OBJ_DIR=./obj

OUT_DIR=lib

OUT_STATIC_x86_64_NAME = $(OUT_DIR)/libLinearAlgebraSimulator.a
OUT_STATIC_ARM64_NAME = $(OUT_DIR)/libLinearAlgebraIPhone.a
OUT_STATIC_NAME = $(OUT_DIR)/libLinearAlgebra.a
OUT_DYNAMIC_NAME = $(OUT_DIR)/libLinearAlgebra.dylib

XCODE_OUT_x86_64_NAME = $(OUT_DIR)/iphonesimulator/liblinearAlgebra.a
XCODE_OUT_ARM64_NAME = $(OUT_DIR)/iphoneos/liblinearAlgebra.a

XCODE_PROJECT_NAME = linearAlgebra

RM = rm -f

default: all
		@echo Make Complete

all: $(OUT_STATIC_NAME)

# creating dynamic library from static
# TODO: example with .dylib
$(OUT_DYNAMIC_NAME):
	# libtool -dynamic -o $(OUT_DIR)/$(OUT_DYNAMIC_NAME) $^
	xcrun --sdk iphoneos clang -arch x86_64 -arch arm64 -shared -all_load \
	    -o $(OUT_DYNAMIC_NAME) $(OUT_STATIC_NAME)

# creating "fat" library (arm64 + x86_64)
$(OUT_STATIC_NAME): dirmake $(OUT_STATIC_ARM64_NAME) $(OUT_STATIC_x86_64_NAME)
	lipo -create $(OUT_STATIC_ARM64_NAME) $(OUT_STATIC_x86_64_NAME) -output $(OUT_STATIC_NAME)

# creating static library for the 64-bit iOS simulator
# Note: we're not building i386 arch (32-bit simulator) due to Xode (v10.0.2) stopped supporting it
$(OUT_STATIC_x86_64_NAME):
	xcodebuild -target $(XCODE_PROJECT_NAME) CONFIGURATION_BUILD_DIR=$(OUT_DIR)/iphonesimulator SKIP_INSTALL=no -configuration Release -arch x86_64 only_active_arch=no defines_module=yes -sdk "iphonesimulator"
	cp $(XCODE_OUT_x86_64_NAME) $(OUT_STATIC_x86_64_NAME)

# creating static library for the 64-bit ARM processor in iPhone 5S
# our library won't support devices older then iPhone 5 (architectures: arm7, arm7s)
# arm7: Used in the oldest iOS 7-supporting devices
# arm7s: As used in iPhone 5 and 5
$(OUT_STATIC_ARM64_NAME):
	# libtool -static -arch_only arm64 -o $(OUT_STATIC_ARM64_NAME) $^
	xcodebuild -target $(XCODE_PROJECT_NAME) CONFIGURATION_BUILD_DIR=$(OUT_DIR)/iphoneos SKIP_INSTALL=no -configuration Release -arch arm64 only_active_arch=no defines_module=yes -sdk "iphoneos"
	cp $(XCODE_OUT_ARM64_NAME) $(OUT_STATIC_ARM64_NAME)


#Compiling every *.c to *.o
$(OBJ_DIR)/%.o: src/%.c dirmake
	$(CC) -c $(INC) $(CFLAGS) $(CFLAGS_ARM64) -o $@  $<

dirmake:
	@mkdir -p $(OUT_DIR)/iphonesimulator
	@mkdir -p $(OUT_DIR)/iphoneos
	@mkdir -p $(OBJ_DIR)

clean:
	$(RM) $(OBJ_DIR)/*.o $(OUT_DIR)/*.a $(OUT_DIR)/*.dylib Makefile.bak
	rm -r $(OUT_DIR)/iphoneos
	rm -r $(OUT_DIR)/iphonesimulator
	rm -r build/

rebuild: clean build
