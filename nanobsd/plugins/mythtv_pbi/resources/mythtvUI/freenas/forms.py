import os
import platform
import pwd

from django.utils.translation import ugettext_lazy as _

from dojango import forms
from mythtvUI.freenas import models, utils


class MythTVForm(forms.ModelForm):

    class Meta:
        model = models.MythTV
        widgets = {
            'x11_DISPLAY': forms.widgets.TextInput(),
        }
        exclude = (
            'enable',
            )

    def __init__(self, *args, **kwargs):
        self.jail = kwargs.pop('jail')
        super(MythTVForm, self).__init__(*args, **kwargs)

    def save(self, *args, **kwargs):
        obj = super(MythTVForm, self).save(*args, **kwargs)

        rcconf = os.path.join(utils.mythtv_etc_path, "rc.conf")
        with open(rcconf, "w") as f:
            if obj.enable:
                f.write('mythtv_enable="YES"\n')

            #mythtv_flags = ""
            #for value in advanced_settings.values():
            #    mythtv_flags += value + " "
            #f.write('mythtv_flags="%s"\n' % (mythtv_flags, ))

        os.system(os.path.join(utils.mythtv_pbi_path, "tweak-rcconf"))


        try:
            os.makedirs("/var/cache/MythTV")
            os.chown("/var/cache/MythTV", *pwd.getpwnam('mythtv')[2:4])
        except Exception:
            pass

        with open(utils.mythtv_config, "w") as f:
            f.write("[general]\n")
            f.write("web_root = /usr/pbi/mythtv-%s/etc/home/mythtv\n" % (
                platform.machine(),
                ))
            f.write("db_type = %s\n" % ("sqlite3", ))
            f.write("db_params = %s\n" % ("/var/cache/MythTV", ))
            f.write("Xvfb_Enable= %d\n" % (obj.xvfb_enable, ))
            f.write("MythService= %s\n" % (obj.mythservices_list, ))
            f.write("X11_Display= %s\n" % (obj.x11_DISPLAY, ))
            f.write("runas = %s\n" % ("mythtv", ))
