FreeNAS_8-MythTV
=====================

Need to make sure and set the following variable ON in /usr/ports/multimedia/mythtv/Makefile
before building plugin:

MYSQL_LOCAL

Need to edit nginx.conf and change

client_max_body_size 250m; 

to 512m in versions of FreeNAS before 8.3-RC1 in order to upload/install the MythTV plugin
See ticket https://support.freenas.org/ticket/1814

Need to check for existing Xvfb display, possibly from other plugin and use that, or close ours when done.

Need to create separate pluging for Xvfb/x11vnc/Fluxbox

Note: fc-cache fc-list
