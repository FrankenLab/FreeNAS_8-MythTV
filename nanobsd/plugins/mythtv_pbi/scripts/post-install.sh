#!/bin/sh

MYTHTV_HOME=/usr/pbi/mythtv-`uname -m`

#echo libz.so.4 libz.so.5 > /etc/libmap.conf
#echo libz.so.4 libz.so.5 > ${MYTHTV_HOME}/etc/libmap.conf

##########################
# INSTALL FONTS FOR X11
##########################

#mkdir -p /usr/local/lib/X11/fonts
#(cd /usr/local/lib/X11/fonts ; cp -a ${MYTHTV_HOME}/fonts/* .)
#rm -rf ${MYTHTV_HOME}/fonts

#(cd /usr/local/lib/X11/fonts ; tar xf ${MYTHTV_HOME}/fonts.tar)
#rm ${MYTHTV_HOME}/fonts.tar

# Copy template RC script over existing script
cp -a ${MYTHTV_HOME}/rc_mythtvd ${MYTHTV_HOME}/etc/rc.d/mythtvd
cp -a ${MYTHTV_HOME}/rc_mythtvd /usr/local/etc/rc.d/mythtvd
chmod 755 /usr/local/etc/rc.d/mythtvd

mkdir -p ${MYTHTV_HOME}/etc/home/mythtv/.fluxbox
#pw groupadd jdown
#pw useradd jdown -g jdown -G wheel -s /bin/sh -d ${MYTHTV_HOME}/etc/home/mythtv -w none
#chown -R jdown:jdown ${MYTHTV_HOME}/etc/home/mythtv

#mkdir -p ${MYTHTV_HOME}/downloads
#chown jdown:jdown ${MYTHTV_HOME}/downloads
#chmod 775 ${MYTHTV_HOME}/downloads

#mkdir -p /var/run/JDownloader /var/log/JDownloader
#touch /var/run/JDownloader/JDownloader.pid /var/log/JDownloader/JDownloader.log
#chown -R jdown:jdown /var/run/JDownloader /var/log/JDownloader

##########################
# LINKS
##########################

#ln -sf ${MYTHTV_HOME}/bin/unrar /usr/local/bin/unrar
#ln -sf ${MYTHTV_HOME}/etc/rc.d/mythtvd /usr/local/etc/rc.d/mythtvd

ldconfig -m ${MYTHTV_HOME}/lib

#find /usr/pbi/${MYTHTV_HOME}/lib -name "libXrender.*" -exec ln -sf {} /usr/local/lib/ \;
#find /usr/pbi/${MYTHTV_HOME}/lib -name "libmawt.*" -exec ln -sf {} /usr/local/lib/ \;
#find /usr/pbi/${MYTHTV_HOME}/lib -name "libXtst.*" -exec ln -sf {} /usr/local/lib/ \;
#find /usr/pbi/${MYTHTV_HOME}/lib -name "libXi.*" -exec ln -sf {} /usr/local/lib/ \;

##########################
# CLEANUP
##########################

#echo $JAIL_IP"	"`hostname` >> /etc/hosts

echo 'mythtv_flags=""' > ${MYTHTV_HOME}/etc/rc.conf
echo 'mythtv_flags=""' > /etc/rc.conf

${MYTHTV_HOME}/bin/python ${MYTHTV_HOME}/mythtvUI/manage.py syncdb --migrate --noinput
