#!/bin/bash -e
#
# Copyright (c) 2019-2020 Peter Yang <turmary@126.com>
# Copyright (c) 2013-2017 Robert Nelson <robertcnelson@gmail.com>
# Portions copyright (c) 2014 Charles Steinkuehler <charles@steinkuehler.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

#This script assumes, these packages are installed, as network may not be setup
#dosfstools initramfs-tools rsync u-boot-tools

source $(dirname "$0")/functions.sh

find_boot_drive() {
	local drive drive_nr

	drive_nr=4
	if [ -f /etc/fstab ]; then
		drive=$(grep "/boot" /etc/fstab | awk '{print $1}')
		if [[ "$drive" =~ ^/dev/mmcblk[0-9]p[0-9]+$ ]]; then
			drive_nr=$(echo "$drive" | sed -re 's,^/dev/mmcblk[0-9]p,,g')
		fi
	fi
	boot_drive=${root_drive%?}${drive_nr}
}

partition_device() {
	empty_line
	generate_line 80 '='
	echo_broadcast "Partitionning ${destination}"
	generate_line 40

	echo_broadcast "==> Partitionning"
	generate_line 60
	sfdisk -d ${source} | egrep -v "last-lba:" | sfdisk -f ${destination}
	generate_line 60
	flush_cache
	empty_line
	echo_broadcast "==> Partitionning Completed"
	echo_broadcast "==> Generated Partitions:"
	generate_line 60
	LC_ALL=C sfdisk -l ${destination}
	generate_line 60
	generate_line 80 '='
	boot_partition="${destination}$(echo ${boot_drive} | sed -re 's,^/dev/mmcblk[0-9],,g')"
	rootfs_partition="${destination}$(echo ${root_drive} | sed -re 's,^/dev/mmcblk[0-9],,g')"
}

_dd_bootloader() {
	empty_line
	generate_line 80 '='
	echo_broadcast "Writing bootloader to [${destination}]"
	generate_line 40

	if [ "x${bootloader_location}" = "xdd_spl_uboot_boot" ] ; then
		_build_uboot_spl_dd_options

		echo_broadcast "==> Copying SPL U-Boot with dd if=${dd_spl_uboot_backup} of=${destination} ${dd_spl_uboot}"
		generate_line 60
		dd if=${dd_spl_uboot_backup} of=${destination} ${dd_spl_uboot}
		generate_line 60
	fi

	if [ "x${bootloader_location}" = "xpart_spl_uboot_boot" ] ; then
		# eMMC boot partition
		echo 0 > /sys/block/${destination#/dev/}boot0/force_ro
		dd if=${dd_spl_uboot_backup} of=${destination}boot0 conv=notrunc
		echo 0 > /sys/block/${destination#/dev/}boot1/force_ro
		dd if=${dd_spl_uboot_backup} of=${destination}boot1 conv=notrunc

		# enable the boot for eMMC specific boot partition
		mmc bootpart enable 1 1 ${destination}
	fi

	_build_uboot_dd_options

	echo_broadcast "==> Copying U-Boot with dd if=${dd_uboot_backup} of=${destination} ${dd_uboot}"
	generate_line 60
	dd if=${dd_uboot_backup} of=${destination} ${dd_uboot}
	generate_line 60
	echo_broadcast "Writing bootloader completed"
	generate_line 80 '='
}

cylon_leds () {
	if [ -e /sys/class/leds/blue/trigger ] ; then
		BLUE=/sys/class/leds/blue
		echo none > ${BLUE}/trigger

		STATE=1
		while : ; do
			case $STATE in
			1)	echo 255 > ${BLUE}/brightness
				STATE=2
				;;
			*)	echo   0 > ${BLUE}/brightness
				STATE=1
				;;
			esac
			sleep 0.1
		done
	fi
}

feed_watchdog() {
	local WDOG=/dev/watchdog0
	if [ ! -c $WDOG ]; then
		return
	fi
	while :; do
		echo -n $'\x00' > $WDOG
		sleep 30
	done
	return
}

end_script() {
	empty_line

	echo_broadcast '==> Displaying mount points'
	generate_line 80
	mount
	generate_line 80
	empty_line
	generate_line 80 '='
	echo_broadcast "eMMC has been flashed: please wait for device to power down."
	generate_line 80 '='

	/sbin/fsck ${boot_partition} || true
	/sbin/fsck ${rootfs_partition} || true
	flush_cache

	if [ -e /proc/$CYLON_PID ]; then
		echo_broadcast "==> Stopping Cylon LEDs ..."
		kill $CYLON_PID > /dev/null 2>&1
	fi
	if [ -e /sys/class/leds/blue/trigger ] ; then
		echo 255 > /sys/class/leds/blue/brightness
	fi

	while :; do
		sleep 1
	done
}

#mke2fs -c
#Check the device for bad blocks before creating the file system.
#If this option is specified twice, then a slower read-write test is
#used instead of a fast read-only test.

mkfs_options=""
#mkfs_options="-c"
#mkfs_options="-cc"

check_if_run_as_root

startup_message
prepare_environment

# prevent the watchdog reset
feed_watchdog & FWDOG_PID=$!

countdown 5
check_running_system
activate_cylon_leds
prepare_drive
#
