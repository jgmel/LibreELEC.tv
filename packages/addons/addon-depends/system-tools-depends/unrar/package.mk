# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="unrar"
PKG_VERSION="7.1.9"
PKG_SHA256="cbb5c7b65b720e59ffa47b2d00b8d1022a961da7ae1db27b6986c43671719483"
PKG_LICENSE="free"
PKG_SITE="https://www.rarlab.com/rar_add.htm"
PKG_URL="https://www.rarlab.com/rar/unrarsrc-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="unrar extract, test and view RAR archives"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+pic -sysroot -parallel"

unpack() {
  mkdir -p ${PKG_BUILD}/unrar lib
  tar -xf ${SOURCES}/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.gz -C ${PKG_BUILD}/
  cp -a ${PKG_BUILD}/unrar ${PKG_BUILD}/lib
}

make_target() {
  make CXX="${CXX}" \
     CXXFLAGS="${TARGET_CXXFLAGS}" \
     RANLIB="${RANLIB}" \
     AR="${AR}" \
     STRIP="${STRIP}" \
     -C unrar \
     -f makefile

  make CXX="${CXX}" \
     CXXFLAGS="${TARGET_CXXFLAGS}" \
     RANLIB="${RANLIB}" \
     AR="${AR}" \
     -C lib \
     -f makefile lib
}

post_make_target() {
  rm -f libunrar.so
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/include/unrar ${INSTALL}/usr/lib ${INSTALL}/usr/bin
  cp -p lib/*.hpp ${INSTALL}/usr/include/unrar/
  cp -p lib/libunrar.a ${INSTALL}/usr/lib/
  cp -p unrar/unrar ${INSTALL}/usr/bin/
}
