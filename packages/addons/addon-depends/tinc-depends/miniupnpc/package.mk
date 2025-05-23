# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="miniupnpc"
PKG_VERSION="2.3.2"
PKG_SHA256="985de16d2e5449c3ba0d3663a0c76cb2bff82472a0eb7a306107d93f44586ffe"
PKG_LICENSE="BSD"
PKG_SITE="http://miniupnp.free.fr"
PKG_URL="http://miniupnp.free.fr/files/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The MiniUPnP project offers software which supports the UPnP Internet Gateway Device (IGD) specifications"

PKG_CMAKE_OPTS_TARGET="-DUPNPC_BUILD_SHARED=OFF -DUPNPC_BUILD_STATIC=ON"
