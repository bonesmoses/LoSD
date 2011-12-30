LoS Daemon
==========

This is LoSD, the Loss of Service Repair Daemon for the Epic 4G Touch

INTRODUCTION
------------

This software is meant to fix persistent loss of service, and ghost loss
of service issues plaguing the Epic 4G Touch, though it can probably be
easily adapted to other devices. It does this by either:

1. Restarting problematic radio daemons when detected.
2. Rebooting when all attempts to fix have failed.

In addition, it can create a log dump of various system logs for
debugging purposes.

REQUIREMENTS
------------

* Phone must be rooted.
* An init.d compatible kernel.
* Busybox must be installed.

Many ROMs and custom kernels do this automatically, but check the feature
of your basic tool-chain before installing.

USAGE
-----

    LoSD [dump]

If you just obtained the script, simply place it somewhere on your android
phone that is mounted as an executable partition, and execute it in a shell:

    LoSD &

At that point, it will begin checking for loss of service and repairing it
when encountered. If you installed the flashable zip, your phone will
automatically launch the LoS daemon at every boot.

If called with the 'dump' command, LoSD will dump all debugging logs and exit,
creating a timestamped directory in LOGPATH, as well as a tar archive named
logs.tar.gz. This lets a user capture situations where LoSD did not detect
a LoS, and send the logs for analysis.

CONFIGURATION
-------------

There are several settings you can apply to the LoS daemon while it's
working. These settings should be placed in a file named LoSD.ini in the
/data/local/LoSD directory of your phone. If you change any settings,
you must either restart the daemon, or reboot your phone.

Currently recognized settings:

* **DEBUG**

    Many log entries are only informative in nature and can be very noisy.
    If you are having trouble and want to see LoSD activity reported in the
    system logs and LoSD.log, set this to 1. Default is 0.

* **DUMPLOGS**

    Whether or not logs should be dumped during a LoS repair or system reboot.
    Should be 0 for false, or 1 for true. Default is curently 0.

* **LOGPATH**

    Full path to where logs should be dumped. This is also where LoSD keeps
    its own LoSD.log file. Default is /data/local/LoSD because the daemon
    knows that directory exists. Feel free to place it somewhere on your
    SD card.

* **RESTARTS**

    How may times should the daemon attempt to restart the radio before giving
    up and initiating a system reboot. Default is 2. This setting was primarily
    defined because ghost LoS can sometimes degrade into full LoS, and
    subsequent radio restarts may be necessary to regain service.

* **RESTART_LIMIT**

    How many successful radio restarts before LoSD considers the phone state
    tainted? Too many RILD restarts may damage other services, or cause other
    unknown side effects. After this limit is reached, further LoS events
    will *not* result in an RILD restart, but a full reboot. Default is 3.

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

By default, LoSD will not dump system logs when it repairs a LoS. But you
may have enabled it on your own if you modified the configuration file. If
you're in a spotty coverage area, the log directory may start to fill
with several timestamped log dumps, each of which are around 5MB. If you'd
like to stop this, please ensure your LoSD.ini configuration file does not
contain the following line:

    DUMPLOGS=1

Such a line will enable log dumping, which again, is disabled by default!

> Q: I think I have LoS the daemon didn't detect. How do I get logs?

Very easily! LoSD has a built-in logging command! Just type this into a
terminal, or an 'adb shell':

    su
    LoSD dump

This will create a timestamped directory just like LoSD had detected it. In
addition, a file named logs.tar.gz will be dropped in your LOGPATH directory
(that's /data/local/LoSD by default) you can send to us. We recommend putting
it in dropbox, or some other binary-file hosting site.

CREDITS
-------

* Author: Trifthen
* Inspiration: [-viperboy-](http://forum.xda-developers.com/member.php?u=518868)
* RILD restart method: [HaiKaiDo](http://forum.xda-developers.com/member.php?u=2422984)

