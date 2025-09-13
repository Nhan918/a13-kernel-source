#!/bin/bash

echo -e "\n[INFO]: BUILD STARTED..!\n"

#init submodules
git submodule init && git submodule update

export KERNEL_ROOT="$(pwd)"
export ARCH=arm64
export KBUILD_BUILD_USER="@topflod"
export PLATFORM_VERSION=13

# Create necessary directories
mkdir -p "${KERNEL_ROOT}/build" "${HOME}/toolchains"

# Export toolchain paths
export PATH="${HOME}/toolchains/clang/bin:${PATH}"

# Set cross-compile environment variables
export BUILD_CROSS_COMPILE="${HOME}/toolchains/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-"

# Build options for the kernel
export BUILD_OPTIONS="
-j$(nproc) \
ARCH=arm64 \
CROSS_COMPILE=${BUILD_CROSS_COMPILE} \
CLANG_TRIPLE=aarch64-linux-gnu- \
LLVM=1 \
LLVM_IAS=1 \
"

build_kernel(){
    # Make default configuration.
    # Replace 'your_defconfig' with the name of your kernel's defconfig
    make ${BUILD_OPTIONS} exynos850-a13xx_defconfig

    # Build the kernel
    make ${BUILD_OPTIONS} Image || exit 1

    # Copy the built kernel to the build directory
    cp "${KERNEL_ROOT}/arch/arm64/boot/Image" "${KERNEL_ROOT}/build"

    echo -e "\n[INFO]: BUILD FINISHED..!"
}
build_kernel
