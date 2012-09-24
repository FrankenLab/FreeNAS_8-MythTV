#!/bin/sh

MYTHTV_HOME=/usr/pbi/mythtv-`uname -m`

# Add 2 checkboxes to GUI to select which app to start (mythtv-setup, or backend)
# Add mountpoint(s)

mv ${MYTHTV_HOME}/libGL.so ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/libGL.so.1 ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/libQtDBus.so ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/libQtDBus.so.4 ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/libQtDBus.so.4.8 ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/libQtDBus.so.4.8.2 ${MYTHTV_HOME}/lib/
ldconfig -m ${MYTHTV_HOME}/lib

mkdir ${MYTHTV_HOME}/_MythDatabase
mysql -uroot -p < ${MYTHTV_HOME}/_MythDatabase/mc.sql

mkdir -p ${MYTHTV_HOME}/_Recordings
chmod 777 ${MYTHTV_HOME}/_Recordings

mv ${MYTHTV_HOME}/sbin_mythtv ${MYTHTV_HOME}/sbin/

##########################
# INSTALL FONTS FOR X11
##########################

#mkdir -p /usr/local/lib/X11/fonts
#(cd /usr/local/lib/X11/fonts ; cp -a ${MYTHTV_HOME}/fonts/* .)
#rm -rf ${MYTHTV_HOME}/fonts

#(cd /usr/local/lib/X11/fonts ; tar xf ${MYTHTV_HOME}/fonts.tar)
#rm ${MYTHTV_HOME}/fonts.tar

# Copy template RC script over existing script
#cp -a ${MYTHTV_HOME}/rc_mythtvd ${MYTHTV_HOME}/etc/rc.d/mythtvd
#cp -a ${MYTHTV_HOME}/rc_mythtvd /usr/local/etc/rc.d/mythtvd
#chmod 755 /usr/local/etc/rc.d/mythtvd

mkdir -p ${MYTHTV_HOME}/etc/home/mythtv/.fluxbox

#pw groupadd jdown
#pw useradd jdown -g jdown -G wheel -s /bin/sh -d ${MYTHTV_HOME}/etc/home/mythtv -w none
#chown -R jdown:jdown ${MYTHTV_HOME}/etc/home/mythtv

mkdir -p /var/run/MythTV /var/log/MythTV
touch /var/run/MythTV/MythTV.pid /var/log/MythTV/MythTV.log
#chown -R jdown:jdown /var/run/MythTV /var/log/MythTV

ldconfig -m ${MYTHTV_HOME}/lib

##########################
# CLEANUP
##########################

#echo $JAIL_IP"	"`hostname` >> /etc/hosts

echo 'mythtv_flags=""' >> ${MYTHTV_HOME}/etc/rc.conf
echo 'mythtv_flags=""' >> /etc/rc.conf

${MYTHTV_HOME}/bin/python ${MYTHTV_HOME}/mythtvUI/manage.py syncdb --migrate --noinput
