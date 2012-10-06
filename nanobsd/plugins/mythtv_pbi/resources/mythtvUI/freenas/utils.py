from subprocess import Popen, PIPE
import os
import platform

mythtv_pbi_path = "/usr/pbi/mythtv-" + platform.machine()
mythtv_etc_path = os.path.join(mythtv_pbi_path, "etc")
mythtv_mnt_path = os.path.join(mythtv_pbi_path, "mnt")
mythtv_fcgi_pidfile = "/var/run/mythtv.pid"
mythtv_fcgi_wwwdir = os.path.join(mythtv_pbi_path, "www")
mythtv_control = "/usr/local/etc/rc.d/mysql-server"
mythtv_config = os.path.join(mythtv_etc_path, "mythtv.conf")
mythtv_icon = os.path.join(mythtv_pbi_path, "default.png")
mythtv_backgnd = os.path.join(mythtv_pbi_path, "mythbkgnd.png")
mythtv_oauth_file = os.path.join(mythtv_pbi_path, ".oauth")


def get_rpc_url(request):
    return 'http%s://%s/plugins/json-rpc/v1/' % ('s' if request.is_secure() \
            else '', request.get_host(),)


def get_mythtv_oauth_creds():
    f = open(mythtv_oauth_file)
    lines = f.readlines()
    f.close()

    key = secret = None
    for l in lines:
        l = l.strip()

        if l.startswith("key"):
            pair = l.split("=")
            if len(pair) > 1:
                key = pair[1].strip()

        elif l.startswith("secret"):
            pair = l.split("=")
            if len(pair) > 1:
                secret = pair[1].strip()

    return key, secret


mythtv_advanced_vars = {
    "set_cwd": {
        "type": "checkbox",
        "on": "-a",
        },
    "debuglevel": {
        "type": "textbox",
        "opt": "-d",
        },
    "debug_modules": {
        "type": "textbox",
        "opt": "-D",
        },
    "disable_mdns": {
        "type": "checkbox",
        "on": "-m",
        },
    "non_root_user": {
        "type": "checkbox",
        "on": "-y",
        },
    "ffid": {
        "type": "textbox",
        "opt": "-b",
        },
}
