# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gnutls"
PKG_VERSION="3.8.10"
PKG_SHA256="db7fab7cce791e7727ebbef2334301c821d79a550ec55c9ef096b610b03eb6b7"
PKG_LICENSE="LGPL2.1"
PKG_SITE="https://gnutls.org"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/gnutls/v${PKG_VERSION:0:3}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="autotools:host libidn2:host nettle:host zlib:host"
PKG_DEPENDS_TARGET="autotools:host gcc:host libidn2 nettle zlib"
PKG_LONGDESC="A library which provides a secure layer over a reliable transport layer."

PKG_CONFIGURE_OPTS_COMMON="--disable-doc \
                           --disable-full-test-suite \
                           --disable-libdane \
                           --disable-padlock \
                           --disable-rpath \
                           --disable-tests \
                           --disable-tools \
                           --disable-valgrind-tests \
                           --with-idn \
                           --with-included-libtasn1 \
                           --with-included-unistring \
                           --without-p11-kit \
                           --without-tpm"

PKG_CONFIGURE_OPTS_HOST="${PKG_CONFIGURE_OPTS_COMMON}"
PKG_CONFIGURE_OPTS_TARGET="${PKG_CONFIGURE_OPTS_COMMON}"

post_configure_target() {
  libtool_remove_rpath libtool
}
