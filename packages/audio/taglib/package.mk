# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="taglib"
PKG_VERSION="2.1.1"
PKG_SHA256="3716d31f7c83cbf17b67c8cf44dd82b2a2f17e6780472287a16823e70305ddba"
PKG_LICENSE="LGPL"
PKG_SITE="https://taglib.org"
PKG_URL="https://taglib.org/releases/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cmake:host utfcpp zlib"
PKG_LONGDESC="TagLib is a library for reading and editing the meta-data of several popular audio formats."

PKG_CMAKE_OPTS_TARGET="-DBUILD_EXAMPLES=OFF \
                       -DBUILD_SHARED_LIBS=OFF \
                       -DBUILD_TESTING=OFF \
                       -DENABLE_CCACHE=ON \
                       -DWITH_ZLIB=ON"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
  # pkgconf hack
  sed -e "s:\(['=\" ]\)/usr:\\1${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/bin/taglib-config
  sed -e "s:\([':\" ]\)-I/usr:\\1-I${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/lib/pkgconfig/taglib.pc
  sed -e "s:\([':\" ]\)-L/usr:\\1-L${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/lib/pkgconfig/taglib.pc
  sed -e "s:\([':\" ]\)-I/usr:\\1-I${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/lib/pkgconfig/taglib_c.pc
  sed -e "s:\([':\" ]\)-L/usr:\\1-L${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/lib/pkgconfig/taglib_c.pc
}
