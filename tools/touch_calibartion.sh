#! /bin/bash

########################################
#
# /etc/xdg/weston/touch_calibartion.sh
#
########################################

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Script is starting......."
FILE="/etc/udev/rules.d/touchscreen.rules"
STRING="LIBINPUT_CALIBRATION_MATRIX"
if tail $FILE | grep $STRING ; then
    echo "FOUND"
    sed -i '$d' $FILE
fi

variable=$(weston-touch-calibrator 2>&1 | grep device | awk -F' {1,}' '{print $2}' | sed -e 's/^"//' -e 's/"$//')
echo $variable

weston-touch-calibrator $variable

