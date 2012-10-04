# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'MythTV'
        db.create_table('freenas_mythtv', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('enable', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('x11_DISPLAY', self.gf('django.db.models.fields.CharField')(default=':1', max_length=500, blank=False)),
            ('xvfb_enable', self.gf('django.db.models.fields.BooleanField')(default=True)),
            ('mythservices_list', self.gf('django.db.models.fields.CharField')(default='', max_length=12)),
        ))
        db.send_create_signal('freenas', ['MythTV'])


    def backwards(self, orm):
        # Deleting model 'MythTV'
        db.delete_table('freenas_mythtv')


    models = {
        'freenas.mythtv': {
            'Meta': {'object_name': 'MythTV'},
            'enable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        }
    }
