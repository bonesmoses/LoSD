LoS Daemon
==========

This is LoSD, the Loss of Service Repair Daemon for the Epic 4G Touch

INTRODUCTION
------------

This software is meant to fix persistent loss of service, and ghost loss
of service issues plaguing some systems. It does this by either:

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
when encountered.

LOGS
----

You can get logs from the system for this service by using logcat through ADB:

    logcat -s LoSD:*

This will only show LoSD-related events. You may want to do this to make sure
LoSD is running properly the first few times you run it.

CREDITS
-------

* Author: Trifthen
* Inspiration: [-viperboy-](http://forum.xda-developers.com/member.php?u=518868)
* RILD restart method: [HaiKaiDo](http://forum.xda-developers.com/member.php?u=2422984)

