# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bcm2835-bootloader"
PKG_VERSION="9a6ca61ec08d12108a443df9889993140c808df5"
PKG_SHA256="d17adb3db13581bd526b832c23a5a094c2f01b20fb3d15db9324de337b5ed48e"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.broadcom.com"
PKG_URL="${DISTRO_SRC}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux bcmstat"
PKG_LONGDESC="bcm2835-bootloader: Tool to create a bootable kernel for RaspberryPi"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/bootloader
    cp -PRv LICENCE* ${INSTALL}/usr/share/bootloader
    case "${DEVICE}" in
      RPi4)
        cp -PRv fixup4x.dat ${INSTALL}/usr/share/bootloader/fixup.dat
        cp -PRv start4x.elf ${INSTALL}/usr/share/bootloader/start.elf
        ;;
      RPi5) ;;
      *)
        cp -PRv bootcode.bin ${INSTALL}/usr/share/bootloader
        cp -PRv fixup_x.dat ${INSTALL}/usr/share/bootloader/fixup.dat
        cp -PRv start_x.elf ${INSTALL}/usr/share/bootloader/start.elf
        ;;
    esac

    find_file_path bootloader/update.sh ${PKG_DIR}/files/update.sh && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

    if find_file_path bootloader/canupdate.sh; then
      cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
      sed -e "s/@PROJECT@/${DEVICE:-${PROJECT}}/g" \
          -i ${INSTALL}/usr/share/bootloader/canupdate.sh
    fi

    find_file_path config/distroconfig.txt ${PKG_DIR}/files/distroconfig.txt && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
    find_file_path config/distroconfig-composite.txt ${PKG_DIR}/files/distroconfig-composite.txt && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
    find_file_path config/config.txt ${PKG_DIR}/files/config.txt && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
}
