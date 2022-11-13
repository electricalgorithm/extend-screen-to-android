# second-screen-via-gdb
This tool lets you to create a virtual second screen display using your any device.

### Usage
1. Connect your device to your computer via USB.
2. Make sure that USB debugging is enabled on your device.
3. Open the terminal and run the following command:
```bash
~$ chmod +x extendto.sh
~$ ./extendto.sh [VIRTUAL_PORT] [WIDTH] [HEIGHT] [REFRESH_RATE]
```
4. Open the second screen using VNC Viewer on your device and enjoy!

Note: You can find any virtual (non-used by something else) display port by running the following command:
```bash
~$ xrandr | grep " disconnected"
```