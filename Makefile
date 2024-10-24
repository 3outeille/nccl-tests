#
# Copyright (c) 2017, NVIDIA CORPORATION. All rights reserved.
#
# See LICENCE.txt for license information
#

# Debug mode flag (0 or 1)
DEBUG ?= 0

# Determine build directory based on build type
ifeq ($(DEBUG), 1)
    BUILDDIR ?= build/debug
    BUILD_FLAGS := DEBUG=1 NVCC_GENCODE="-g -G"
else
    BUILDDIR ?= build/release
    BUILD_FLAGS :=
endif

override BUILDDIR := $(abspath $(BUILDDIR))

TARGETS=src

.PHONY: all clean debug show-config help clean-all clean-debug clean-release

# Default release build
default: src.build

# Debug build
debug:
	@$(MAKE) src.build DEBUG=1

# Main targets
all:   ${TARGETS:%=%.build}
clean: ${TARGETS:%=%.clean}

# Clean variants
clean-all:
	rm -rf build

clean-debug:
	rm -rf build/debug

clean-release:
	rm -rf build/release

# Build rules
%.build:
	@echo "Building in $(BUILDDIR)"
	${MAKE} -C $* build BUILDDIR=${BUILDDIR} $(BUILD_FLAGS)

%.clean:
	${MAKE} -C $* clean BUILDDIR=${BUILDDIR}

# Show configuration
show-config:
	@echo "Build Configuration:"
	@echo "  Build Type: $(if $(filter 1,$(DEBUG)),debug,release)"
	@echo "  Build Dir:  $(BUILDDIR)"
	@echo "  Flags:      $(BUILD_FLAGS)"

# Help
help:
	@echo "Available targets:"
	@echo "  make              - Build release version"
	@echo "  make debug        - Build debug version"
	@echo "  make clean        - Clean current build"
	@echo "  make clean-all    - Clean all builds"
	@echo "  make clean-debug  - Clean debug build"
	@echo "  make clean-release- Clean release build"
	@echo "  make show-config  - Show current build configuration"
	@echo "  make help         - Show this help message"