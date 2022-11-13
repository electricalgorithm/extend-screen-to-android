#!/usr/bin/env bash

DISPLAY_DEVICE=$1
DISPLAY_HEIGHT=$2
DISPLAY_WIDTH=$3
DISPLAY_REFERSH=$4

# Check if the display is correctly given.
xrandr | grep -q $DISPLAY_DEVICE
if [ $? -ne 0 ]; then
    echo "Display $DISPLAY_DEVICE not found."
    exit 1
fi

# Print information about the script.
echo "Welcome to the extendto!"
echo "This script will extend the current directory to an Android device."
echo "Please make sure you have the device connected and the USB debugging is enabled."

echo "To extend your screen virtually to a Android device, you should have those packages:"
echo "  - adb"
echo "  - android-tools-adb"
echo "  - android-tools-fastboot"
echo "  - x11vnc"

# Check if dependencies are installed.
dpkg -s adb x11vnc &> /dev/null
if [ $? -ne 0 ]; then
    echo "Some packages are not installed. Installation of them is starting."
    # Installing dependencies.
    sudo apt-get install adb android-tools-adb android-tools-fastboot x11vnc -y &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to install dependencies."
        exit 1
    fi
    echo "Dependencies installed successfully."
else
    echo "Dependencies are already installed."
fi

# Reverse port forwarding.
adb reverse tcp:5900 tcp:5900 &> /dev/null
if [ $? -ne 0 ]; then
    echo "Failed to reverse port forwarding."
    exit 1
fi
echo "Reverse port forwarding is done successfully."

# Get modeline.
MODELINE=$(gtf $DISPLAY_HEIGHT $DISPLAY_WIDTH $DISPLAY_REFERSH | sed -n 3p | sed "s/  Modeline //g")
echo $MODELINE
MODELINE_NAME=$(echo $MODELINE | sed 's/^"\(.*\)".*/\1/')
echo $MODELINE_NAME
# Create a new mode on xrandr.
xrandr --newmode $MODELINE
# Add the new mode to the display.
xrandr --addmode $DISPLAY_DEVICE $MODELINE_NAME
# Extend the display.
xrandr --output $DISPLAY_DEVICE --mode $MODELINE_NAME --right-of eDP-1

# Start x11vnc.
x11vnc -clip $DISPLAY_WIDTH"x"$DISPLAY_HEIGHT"+1920+0" &> /dev/null
if [ $? -ne 0 ]; then
    echo "Failed to start x11vnc."
    exit 1
fi
echo "x11vnc is started successfully. CTRL+C to stop."

