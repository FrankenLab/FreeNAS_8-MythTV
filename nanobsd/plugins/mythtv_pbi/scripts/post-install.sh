#!/bin/sh

MYTHTV_HOME=/usr/pbi/mythtv-`uname -m`
MYTH_USER=mythtv

env -i ${MYTHTV_HOME}/bin/python ${MYTHTV_HOME}/mythtvUI/manage.py syncdb --migrate --noinput

# IF `uname -m` .eq. amd64
mv ${MYTHTV_HOME}/lib_x64/libGL.so ${MYTHTV_HOME}/lib/
mv ${MYTHTV_HOME}/lib_x64/libGL.so.1 ${MYTHTV_HOME}/lib/
rm -rf ${MYTHTV_HOME}/lib_x64
rm ${MYTHTV_HOME}/lib*.so*

ldconfig -m ${MYTHTV_HOME}/lib
ldconfig -m ${MYTHTV_HOME}/lib/mysql
ldconfig -m ${MYTHTV_HOME}/lib/mysql/plugin
ldconfig -m ${MYTHTV_HOME}/lib/qt4/plugins

mkdir -p ${MYTHTV_HOME}/_MythDatabase/mysql

/usr/pbi/mythtv-`uname -m`/bin/mysql_install_db --basedir=/usr/pbi/mythtv-`uname -m` --datadir=/usr/pbi/mythtv-`uname -m`/_MythDatabase --force

# Create Mythconverge from database template
cp ${MYTHTV_HOME}/share/mythtv/database/mc.sql ${MYTHTV_HOME}/_MythDatabase/mc.sql

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

mkdir -p /usr/local/lib/X11/fonts
#ln -sf /usr/local/lib/X11/fonts ${MYTHTV_HOME}/lib/X11/fonts
(cd /usr/local/lib/X11/fonts ; cp -a ${MYTHTV_HOME}/fonts/* .)

mkdir -p /usr/local/etc/fonts
cp -a ${MYTHTV_HOME}/fonts.conf /usr/local/etc/fonts/fonts.conf
${MYTHTV_HOME}/bin/fc-cache -f

rm -rf ${MYTHTV_HOME}/fonts

pw groupadd ${MYTH_USER}
pw useradd ${MYTH_USER} -g ${MYTH_USER} -G wheel -s /bin/sh -w none -d ${MYTHTV_HOME}/etc/home/mythtv
mv /root/.mythtv /root/.mythtv_OLD
ln -sf ${MYTHTV_HOME}/etc/home/mythtv /root/.mythtv
mkdir -p ${MYTHTV_HOME}/etc/home/mythtv/.fluxbox

# Need to create home directory
#pw useradd ${MYTH_USER} -g ${MYTH_USER} -G wheel -s /bin/sh -d ${MYTHTV_HOME}/etc/home/mythtv -w none
#chown -R ${MYTH_USER}:${MYTH_USER} ${MYTHTV_HOME}/etc/home/mythtv

##########################
# CLEANUP
##########################

#echo $JAIL_IP"	"`hostname` >> /etc/hosts
#echo 'mysql-server_flags=""' >> ${MYTHTV_HOME}/etc/rc.conf
#echo 'mysql-server_flags=""' >> /etc/rc.conf
