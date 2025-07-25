#!/bin/sh

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

[ -z "$SYSTEM_ROOT" ] && SYSTEM_ROOT=""
[ -z "$BOOT_ROOT" ] && BOOT_ROOT="/flash"
[ -z "$BOOT_PART" ] && BOOT_PART=$(df "$BOOT_ROOT" | tail -1 | awk {' print $1 '})

# identify the boot device
if [ -z "$BOOT_DISK" ]; then
  case $BOOT_PART in
    /dev/sd[a-z][0-9]*)
      BOOT_DISK=$(echo $BOOT_PART | sed -e "s,[0-9]*,,g")
      ;;
    /dev/mmcblk*)
      BOOT_DISK=$(echo $BOOT_PART | sed -e "s,p[0-9]*,,g")
      ;;
  esac
fi

# mount $BOOT_ROOT rw
mount -o remount,rw $BOOT_ROOT

# update /amlogic device trees
if [ -d $BOOT_ROOT/amlogic ]; then
  for dtbfile in $BOOT_ROOT/amlogic/*.dtb; do
    dtb=$(basename $dtbfile)
    if [ -f $SYSTEM_ROOT/usr/share/bootloader/$dtb ]; then
      echo "Updating $dtb"
      cp -p $SYSTEM_ROOT/usr/share/bootloader/$dtb $BOOT_ROOT/amlogic/
    fi
  done
fi

# update /extlinux device trees
if [ -f $BOOT_ROOT/extlinux/extlinux.conf ]; then
  for dtbfile in $BOOT_ROOT/*.dtb; do
    dtb=$(basename $dtbfile)
    if [ -f $SYSTEM_ROOT/usr/share/bootloader/$dtb ]; then
      echo "Updating $dtb"
      cp -p $SYSTEM_ROOT/usr/share/bootloader/$dtb $BOOT_ROOT/
    fi
  done
fi

# update /dtb device trees
if [ -d $BOOT_ROOT/dtb ]; then
  for dtbfile in $BOOT_ROOT/dtb/*.dtb; do
    dtb=$(basename $dtbfile)
    if [ -f $SYSTEM_ROOT/usr/share/bootloader/$dtb ]; then
      echo "Updating $dtb"
      cp -p $SYSTEM_ROOT/usr/share/bootloader/$dtb $BOOT_ROOT/dtb/
    fi
  done
fi

# update u-boot scripts
if [ -f $BOOT_ROOT/uEnv.ini ]; then
  for scriptfile in $SYSTEM_ROOT/usr/share/bootloader/*_autoscript* $SYSTEM_ROOT/usr/share/bootloader/*.scr; do
    script=$(basename $scriptfile)
    if [ -f $SYSTEM_ROOT/usr/share/bootloader/$script ]; then
      echo "Updating $script"
      cp -p $SYSTEM_ROOT/usr/share/bootloader/$script $BOOT_ROOT/
    fi
  done
fi

# mount $BOOT_ROOT ro
sync
mount -o remount,ro $BOOT_ROOT
