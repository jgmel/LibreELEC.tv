# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2022-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mold"
PKG_VERSION="2.40.2"
PKG_SHA256="28c7976c39e53ee440217b6b9f036a8cf13e3b2f93e8da83e19c66f4fc9a774c"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/rui314/mold"
PKG_URL="https://github.com/rui314/mold/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="cmake:host zlib:host zstd:host openssl:host tbb:host mimalloc:host"
PKG_LONGDESC="mold is a faster drop-in replacement for existing Unix linkers"

PKG_CMAKE_OPTS_HOST="-DCMAKE_INSTALL_LIBDIR="${TOOLCHAIN}/${TARGET_NAME}/lib"
                     -DCMAKE_INSTALL_BINDIR="${TARGET_NAME}/bin" \
                     -DCMAKE_INSTALL_LIBEXECDIR="${TARGET_NAME}" \
                     -DMOLD_LTO=ON \
                     -DMOLD_MOSTLY_STATIC=ON \
                     -DMOLD_USE_SYSTEM_MIMALLOC=ON \
                     -DMOLD_USE_SYSTEM_TBB=ON"

post_makeinstall_host() {
  ln -sf ${TOOLCHAIN}/${TARGET_NAME}/bin/mold ${TARGET_PREFIX}ld.mold
}
