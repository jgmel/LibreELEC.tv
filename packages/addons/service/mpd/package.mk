# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mpd"
PKG_VERSION="0.24.4"
PKG_SHA256="86035d6c63af32afa77fd5eb5ecd1c6afaef7cc352b28064edf51eea60f40d66"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.musicpd.org"
PKG_URL="http://www.musicpd.org/download/mpd/$(get_pkg_version_maj_min)/mpd-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain alsa-lib avahi boost curl faad2 ffmpeg flac glib lame libcdio libfmt \
                    libgcrypt libiconv libid3tag libmad libmpdclient libopenmpt libsamplerate \
                    libvorbis libnfs libogg mpd-mpc opus pulseaudio samba wavpack nlohmann-json"
PKG_SECTION="service.multimedia"
PKG_SHORTDESC="Music Player Daemon (MPD): a free and open Music Player Server"
PKG_LONGDESC="Music Player Daemon (${PKG_VERSION}) is a flexible and powerful server-side application for playing music"
PKG_BUILD_FLAGS="-sysroot"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Music Player Daemon (MPD)"
PKG_ADDON_TYPE="xbmc.service"

PKG_MESON_OPTS_TARGET="-Dadplug=disabled \
                       -Dalsa=enabled \
                       -Dao=disabled \
                       -Daudiofile=disabled \
                       -Dbzip2=enabled \
                       -Dcdio_paranoia=disabled \
                       -Dchromaprint=disabled \
                       -Dcue=true \
                       -Dcurl=enabled \
                       -Ddatabase=true \
                       -Ddocumentation=disabled \
                       -Ddsd=true \
                       -Dexpat=enabled \
                       -Dfaad=enabled \
                       -Dffmpeg=enabled \
                       -Dfifo=true \
                       -Dflac=enabled \
                       -Dfluidsynth=disabled \
                       -Dfuzzer=false \
                       -Dgme=disabled \
                       -Dhttpd=true \
                       -Dhtml_manual=false \
                       -Diconv=disabled \
                       -Dicu=disabled \
                       -Did3tag=enabled \
                       -Dipv6=enabled \
                       -Diso9660=enabled \
                       -Djack=disabled \
                       -Dlame=enabled \
                       -Dlibmpdclient=enabled \
                       -Dlibsamplerate=enabled \
                       -Dlocal_socket=false \
                       -Dmad=enabled \
                       -Dmanpages=false \
                       -Dmikmod=disabled \
                       -Dmms=disabled \
                       -Dmodplug=disabled \
                       -Dmpcdec=disabled \
                       -Dmpg123=disabled \
                       -Dneighbor=false \
                       -Dnfs=enabled \
                       -Dopenal=disabled \
                       -Dopus=enabled \
                       -Doss=disabled \
                       -Dpipe=true \
                       -Dpulse=enabled \
                       -Dqobuz=enabled \
                       -Drecorder=false \
                       -Dshine=disabled \
                       -Dshout=disabled \
                       -Dsidplay=disabled \
                       -Dsmbclient=enabled \
                       -Dsndfile=enabled \
                       -Dsndio=disabled \
                       -Dsolaris_output=disabled \
                       -Dsoxr=enabled \
                       -Dsqlite=enabled \
                       -Dsyslog=disabled \
                       -Dsystemd=disabled \
                       -Dtest=false \
                       -Dtwolame=disabled \
                       -Dupnp=disabled \
                       -Dvorbis=enabled \
                       -Dvorbisenc=enabled \
                       -Dwave_encoder=true \
                       -Dwavpack=enabled \
                       -Dwebdav=enabled \
                       -Dwildmidi=disabled \
                       -Dnlohmann_json=enabled \
                       -Dzeroconf=avahi \
                       -Dzlib=enabled \
                       -Dzzip=disabled"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -P ${PKG_INSTALL}/usr/bin/mpd ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  # copy mpd cli binary
  cp -P $(get_install_dir mpd-mpc)/usr/bin/mpc ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  patchelf --add-rpath '${ORIGIN}/../lib.private' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/{mpc,mpd}

  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private
  cp -p $(get_install_dir libmpdclient)/usr/lib/libmpdclient.so ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private
  cp -p $(get_install_dir libmpdclient)/usr/lib/libmpdclient.so.2 ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private
}
