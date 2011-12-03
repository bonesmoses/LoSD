LoS Daemon
==========

This is LoSD, the Loss of Service Repair Daemon for the Epic 4G Touch

INTRODUCTION
------------

This software is meant to fix persistent loss of service, and ghost loss
of service issues plaguing the Epic 4G Touch, though it can probably be
easily adapted to other devices. It does this by either:

1. Killing problematic radio daemons when detected.
2. Rebooting when all attempts to fix have failed.
3. Create a log dump of various system logs for debugging purposes.

REQUIREMENTS
------------

For this to utility to function properly, your phone must be rooted and
busybox must be installed. Many ROMs and custom kernels do this automatically,
but check the feature list before installing.

USAGE
-----

If you just obtained the script, simply place it somewhere on your android
phone that is mounted as an executable partition, and execute it in a shell:

    LoSD &

At that point, it will begin checking for loss of service and repairing it
when encountered. If you installed the flashable zip, your phone will
automatically launch the LoS daemon at every boot.

CONFIGURATION
-------------

There are several settings you can apply to the LoS daemon while it's
working. These settings should be placed in a file named LoSD.ini in the
/data/local/LoSD directory of your phone. If you change any settings,
you must either restart the daemon, or reboot your phone.

Currently recognized settings:

* **DEBUG**

    Many log entries are only informative in nature. To prevent these from
    being entered into the system logs and LoSD.log, set this to 0.
    Default is 1.

* **DUMPLOGS**

    Whether or not logs should be dumped during a LoS repair or system reboot.
    Should be 0 for false, or 1 for true. Default is curently 1.

* **LOGPATH**

    Full path to where logs should be dumped. This is also where LoSD keeps
    its own LoSD.log file. Default is /usr/local/LoSD because the daemon
    knows that directory exists. Feel free to place it somewhere on your
    SD card.

* **RESTARTS**

    How may times should the daemon attempt to restart the radio before giving
    up and initiating a system reboot. Default is 2. This setting was primarily
    defined because ghost LoS can sometimes degrade into full LoS, and
    subsequent radio restarts may be necessary to regain service.

* **SLEEP**

    How long to wait between radio checks, in seconds. Default is two minutes.

**Example:**

    DUMPLOGS=0
    LOGPATH=/sdcard/los

Again, if these settings are changed, you must either restart the LoS daemon,
or restart the phone. To restart the daemon, execute the following in an ADB
shell or terminal:

    su
    killall LoSD
    nohup LoSD &

The `nohup` is there to prevent the command from attaching to your TTY, so
you can disconnect without your session hanging. Feel free to omit this if
you were just going to close your TTY.

LOGS
----

You can get logs from the system for this service by using logcat through ADB:

    logcat -s LoSD:*

This will only show LoSD-related events. You may want to do this to make sure
LoSD is running properly the first few times you run it.

FAQ
---

> Q: Will this restart the radio or the phone if I lose 4G?

No. 4G is actually a separate radio from the CDMA radio used for texts and
phone calls. This script ignores the 4G radio entirely and can not trigger
no matter what happens to the 4G radio.

> Q: Will this restart the radio or the phone if I'm using WiFi?

No. Turning on WiFi *will* disable your 3G data, but will leave the CDMA
radio in an available state so you can still receive phone calls and texts.
The LoS daemon knows the difference, so feel free to use your WiFi as you
please. LoSD may restart your radio while you're on WiFi, but only because
your CDMA radio stopped responding and you wouldn't have received any texts
or phone calls if it didn't try and fix the radio.

> Q: Where do I find the logs?

Logs produced when the radio is restarted, or the phone is rebooted, are
stored by default in /data/local/LoSD in a directory time and date stamped
for when the fix was attempted, or a reboot was triggered.

> Q: Help! My log directory is getting huge!

If you're in a spotty coverage area, the log directory may start to fill
with several timestamped log dumps, each of which are around 5MB. If you'd
like to stop this, please create a file named LoSD.ini in your
/data/local/LoSD directory, and make sure it contains the following line:

    DUMPLOGS=0

This will disable log dumping during LoS repair. The current default is to
log because the script is still in beta status. When we're sure the check is
more stable, it will be disabled by default, and you'll have to manually
re-enable them if you want dumps.

> Q: I think I have LoS the daemon didn't detect. How do I get logs?

Very easily! Just do this with ADB:

    adb bugreport > los.log

Or with a terminal:

    su
    bugreport > /sdcard/los.log

And use your favorite site (pastebin, etc) to host the file for us to
analyze.

CREDITS
-------

* Author: Trifthen
* Inspiration: [-viperboy-](http://forum.xda-developers.com/member.php?u=518868)
* RILD restart method: [HaiKaiDo](http://forum.xda-developers.com/member.php?u=2422984)

