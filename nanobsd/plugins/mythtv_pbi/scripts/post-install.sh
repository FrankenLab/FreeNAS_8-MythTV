#!/bin/sh

MYTHTV_HOME=/usr/pbi/mythtv-`uname -m`
MYTH_USER=mythtv

env -i ${MYTHTV_HOME}/bin/python ${MYTHTV_HOME}/mythtvUI/manage.py syncdb --migrate --noinput

# IF `uname -m` .eq. amd64
mv ${MYTHTV_HOME}/lib_x64/libGL.so ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/lib_x64/libGL.so.1 ${MYTHTV_HOME}/lib/
rm -rf ${MYTHTV_HOME}/lib_x64

ldconfig -m ${MYTHTV_HOME}/lib
ldconfig -m ${MYTHTV_HOME}/lib/mysql
ldconfig -m ${MYTHTV_HOME}/lib/mysql/plugin
ldconfig -m ${MYTHTV_HOME}/lib/qt4/plugins

mkdir -p ${MYTHTV_HOME}/_MythDatabase/mysql

/usr/pbi/mythtv-`uname -m`/bin/mysql_install_db --basedir=/usr/pbi/mythtv-`uname -m` --datadir=/usr/pbi/mythtv-`uname -m`/_MythDatabase --force

# Create Mythconverge from database template
cp ${MYTHTV_HOME}/share/mythtv/database/mc.sql ${MYTHTV_HOME}/_MythDatabase/mc.sql
/usr/pbi/mythtv-`uname -m`/bin/mysql -umythtv -pmythtv < ${MYTHTV_HOME}/_MythDatabase/mc.sql

# Database needs to be running for next command
# Probably should run from sbin/mythtv
#${MYTHTV_HOME}/bin/mysql_update


mkdir -p ${MYTHTV_HOME}/_Recordings
chmod 777 ${MYTHTV_HOME}/_Recordings

mv ${MYTHTV_HOME}/sbin_mythtv ${MYTHTV_HOME}/sbin/mythtv
chmod 755 ${MYTHTV_HOME}/sbin/mythtv

mv ${MYTHTV_HOME}/mysql-server ${MYTHTV_HOME}/etc/rc.d/
cp -a ${MYTHTV_HOME}/etc/rc.d/mysql-server /usr/local/etc/rc.d/
chmod 755 ${MYTHTV_HOME}/etc/rc.d/mysql-server
chmod 755 /usr/local/etc/rc.d/mysql-server

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

pw groupadd ${MYTH_USER}
pw useradd ${MYTH_USER} -g ${MYTH_USER} -G wheel -s /bin/sh -w none -d ${MYTHTV_HOME}/etc/home/mythtv
mv /root/.mythtv /root/.mythtv_OLD
ln -sf ${MYTHTV_HOME}/etc/home/mythtv /root/.mythtv
# Need to create home directory
#pw useradd ${MYTH_USER} -g ${MYTH_USER} -G wheel -s /bin/sh -d ${MYTHTV_HOME}/etc/home/mythtv -w none
#chown -R ${MYTH_USER}:${MYTH_USER} ${MYTHTV_HOME}/etc/home/mythtv

mkdir -p /var/run/MythTV /var/log/MythTV
touch /var/run/MythTV/MythTV.pid /var/log/MythTV/MythTV.log
#chown -R ${MYTH_USER}:${MYTH_USER} /var/run/MythTV /var/log/MythTV


##########################
# CLEANUP
##########################

#echo $JAIL_IP"	"`hostname` >> /etc/hosts

echo 'mythtv_flags=""' >> ${MYTHTV_HOME}/etc/rc.conf
echo 'mythtv_flags=""' >> /etc/rc.conf
