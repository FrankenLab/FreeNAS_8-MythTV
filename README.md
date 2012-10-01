FreeNAS_8-JDownloader
=====================

Need to make sure and set the following variable ON in /usr/ports/multimedia/mythtv/Makefile
before building plugin:

MYSQL_LOCAL

Need to edit nginx.conf and change

client_max_body_size 250m; 

to 512m in versions of FreeNAS before 8.3-RC1 in order to upload/install the MythTV plugin
See ticket https://support.freenas.org/ticket/1814

Need to stop Xvfb/x11vnc/mythtv-setup or backend from mysql-server when stopping from GUI
Need to make sure it was "our" plugin that started it, else leave it running

Need to check for existing Xvfb display, possibly from other plugin and use that, or close ours when done.

Should change _poststop to PREstop so apps that are using database can close gracefully
