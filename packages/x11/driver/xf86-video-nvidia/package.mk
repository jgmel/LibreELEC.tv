# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-nvidia"
PKG_VERSION="575.64.05"
PKG_SHA256="f261d894c33cdd64da46c092458ca1e510dd08c0edda7458dd15c786887ccf75"
PKG_ARCH="x86_64"
PKG_LICENSE="nonfree"
PKG_SITE="https://www.nvidia.com/en-us/drivers/unix/"
PKG_URL="http://us.download.nvidia.com/XFree86/Linux-x86_64/${PKG_VERSION}/NVIDIA-Linux-x86_64-${PKG_VERSION}-no-compat32.run"
PKG_DEPENDS_TARGET="util-macros xorg-server libvdpau libglvnd"
PKG_LONGDESC="The Xorg driver for NVIDIA GPUs supporting the GeForce 600 Series & above."
PKG_TOOLCHAIN="manual"

PKG_IS_KERNEL_PKG="yes"

if [ "${VULKAN_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" ${VULKAN} vulkan-tools"
fi

unpack() {
  [ -d ${PKG_BUILD} ] && rm -rf ${PKG_BUILD}

  sh ${SOURCES}/${PKG_NAME}/${PKG_SOURCE_NAME} --extract-only --target ${PKG_BUILD}
}

make_target() {
  unset LDFLAGS

  cd kernel
    make module CC=${CC} LD=${LD} SYSSRC=$(kernel_path) SYSOUT=$(kernel_path)
    ${STRIP} --strip-debug nvidia.ko
  cd ..
}

makeinstall_target() {
  # Linux kernel modules
  mkdir -p ${INSTALL}/$(get_full_module_dir)/nvidia
    cp -P kernel/*.ko ${INSTALL}/$(get_full_module_dir)/nvidia

  # GSP firmware files
  mkdir -p ${INSTALL}/$(get_full_firmware_dir)/nvidia/${PKG_VERSION}
    cp firmware/gsp*.bin           ${INSTALL}/$(get_full_firmware_dir)/nvidia/${PKG_VERSION}

  # X driver
  mkdir -p ${INSTALL}/${XORG_PATH_MODULES}/drivers
    cp -P nvidia_drv.so ${INSTALL}/${XORG_PATH_MODULES}/drivers/nvidia-main_drv.so
    ln -sf /var/lib/nvidia_drv.so ${INSTALL}/${XORG_PATH_MODULES}/drivers/nvidia_drv.so

  # GLX extension module for X
  mkdir -p ${INSTALL}/${XORG_PATH_MODULES}/extensions
  # rename to avoid conflicts with X.Org-Server module libglx.so
    cp -P libglxserver_nvidia.so.${PKG_VERSION} ${INSTALL}/${XORG_PATH_MODULES}/extensions/libglx_nvidia.so

  # Xorg config
  mkdir -p ${INSTALL}/etc/X11
    cp ${PKG_DIR}/config/*.conf ${INSTALL}/etc/X11

  # GLX
  mkdir -p ${INSTALL}/usr/lib
    cp -P libGLX_nvidia.so.${PKG_VERSION} ${INSTALL}/usr/lib/libGLX_nvidia.so.0

  # GLVND
  mkdir -p ${INSTALL}/usr/share/glvnd/egl_vendor.d
    cp -p 10_nvidia.json ${INSTALL}/usr/share/glvnd/egl_vendor.d

  # OpenGL / EGL
  mkdir -p ${INSTALL}/usr/lib
    cp -p libEGL_nvidia.so.${PKG_VERSION}  ${INSTALL}/usr/lib/
    ln -sf libEGL_nvidia.so.${PKG_VERSION} ${INSTALL}/usr/lib/libEGL_nvidia.so.0
    ln -sf libEGL_nvidia.so.0              ${INSTALL}/usr/lib/libEGL_nvidia.so

  # OpenGL core
  mkdir -p ${INSTALL}/usr/lib
    cp -p libnvidia-eglcore.so.${PKG_VERSION}  ${INSTALL}/usr/lib/
    cp -P libnvidia-glcore.so.${PKG_VERSION}   ${INSTALL}/usr/lib
    cp -p libnvidia-glsi.so.${PKG_VERSION}     ${INSTALL}/usr/lib

  # Install Vulkan ICD & SPIR-V lib
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    mkdir -p ${INSTALL}/usr/lib
      cp -P libnvidia-glvkspirv.so.${PKG_VERSION} ${INSTALL}/usr/lib
    mkdir -p ${INSTALL}/usr/share/vulkan/icd.d
      cp -P nvidia_icd.json ${INSTALL}/usr/share/vulkan/icd.d
    mkdir -p ${INSTALL}/usr/share/vulkan/implicit_layer.d
      cp -P nvidia_layers.json ${INSTALL}/usr/share/vulkan/icd.d
  fi

  # nvidia-gpucomp
  mkdir -p ${INSTALL}/usr/lib
    cp -P libnvidia-gpucomp.so.${PKG_VERSION} ${INSTALL}/usr/lib

  # nvidia-tls
  mkdir -p ${INSTALL}/usr/lib
    cp -P libnvidia-tls.so.${PKG_VERSION} ${INSTALL}/usr/lib

  # NVIDIA Management Library (NVML) / System Management Interface
  mkdir -p ${INSTALL}/usr/bin
    ln -s /var/lib/nvidia-smi ${INSTALL}/usr/bin/nvidia-smi
    cp nvidia-smi ${INSTALL}/usr/bin/nvidia-main-smi

  mkdir -p ${INSTALL}/usr/lib
    cp -P libnvidia-ml.so.${PKG_VERSION} ${INSTALL}/usr/lib
    ln -sf /var/lib/libnvidia-ml.so.1 ${INSTALL}/usr/lib/libnvidia-ml.so.1

  # Tool for manipulating X server configuration files
  mkdir -p ${INSTALL}/usr/bin
    ln -s /var/lib/nvidia-xconfig ${INSTALL}/usr/bin/nvidia-xconfig
    cp nvidia-xconfig ${INSTALL}/usr/bin/nvidia-main-xconfig

  # VDPAU
  mkdir -p ${INSTALL}/usr/lib/vdpau
    cp libvdpau_nvidia.so* ${INSTALL}/usr/lib/vdpau/libvdpau_nvidia-main.so.1
    ln -sf /var/lib/libvdpau_nvidia.so ${INSTALL}/usr/lib/vdpau/libvdpau_nvidia.so
    ln -sf /var/lib/libvdpau_nvidia.so.1 ${INSTALL}/usr/lib/vdpau/libvdpau_nvidia.so.1

  # App profiles
  mkdir -p ${INSTALL}/usr/share/nvidia
    cp -P nvidia-application-profiles-${PKG_VERSION}-rc ${INSTALL}/usr/share/nvidia
}
