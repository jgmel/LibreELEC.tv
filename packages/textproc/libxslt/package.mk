# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libxslt"
PKG_VERSION="1.1.43"
PKG_SHA256="5a3d6b383ca5afc235b171118e90f5ff6aa27e9fea3303065231a6d403f0183a"
PKG_LICENSE="MIT"
PKG_SITE="http://xmlsoft.org/xslt/"
PKG_URL="https://download.gnome.org/sources/libxslt/$(get_pkg_version_maj_min)/libxslt-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="libxml2:host"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_LONGDESC="A XSLT C library."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_ALL="-DBUILD_SHARED_LIBS=ON \
                    -DLIBXSLT_WITH_DEBUGGER=OFF \
                    -DLIBXSLT_WITH_CRYPTO=OFF \
                    -DLIBXSLT_WITH_MODULES=OFF \
                    -DLIBXSLT_WITH_PROFILER=ON \
                    -DLIBXSLT_WITH_PYTHON=OFF \
                    -DLIBXSLT_WITH_TESTS=OFF \
                    -DLIBXSLT_WITH_THREADS=ON \
                    -DLIBXSLT_WITH_XSLT_DEBUG=OFF"

PKG_CMAKE_OPTS_HOST=${PKG_CMAKE_OPTS_ALL}

PKG_CMAKE_OPTS_TARGET=${PKG_CMAKE_OPTS_ALL}

post_makeinstall_target() {
  sed -e "s:\(['= ]\)/usr:\\1${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/bin/xslt-config

  rm -rf ${INSTALL}/usr/bin/xsltproc
  rm -rf ${INSTALL}/usr/lib/xsltConf.sh
}
