from django.db import models


class MythTV(models.Model):
    """
    Django model describing every tunable setting for mythtv
    """

    enable = models.BooleanField(default=False)
    x11_DISPLAY = models.CharField(max_length=500, default=':1', blank=True)
    xvfb_enable = models.BooleanField(default=True)
    mythsetup_enable = models.BooleanField(
	default=True,
        help_text=("Run MythTV-Setup")
	)
    mythbackend_enable = models.BooleanField(
	default=False,
        help_text=("Run MythBackend (Only Check ONE!)")
	)
