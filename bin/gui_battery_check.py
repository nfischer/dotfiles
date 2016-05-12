#!/usr/bin/python

"""
Output my battery info to a GUI notification
"""

import dbus
import subprocess

def notify(summary, body='', app_name='', app_icon='',
           timeout=3000, actions=[], hints=[], replaces_id=0):
    """Send a system notification"""
    _bus_name = 'org.freedesktop.Notifications'
    _object_path = '/org/freedesktop/Notifications'
    _interface_name = _bus_name

    session_bus = dbus.SessionBus()
    obj = session_bus.get_object(_bus_name, _object_path)
    interface = dbus.Interface(obj, _interface_name)
    interface.Notify(app_name, replaces_id, app_icon,
                     summary, body, actions, hints, timeout)


## Main ##

# Call battery_check shell script to get info

PROC = subprocess.Popen("battery_check", stdout=subprocess.PIPE)
# TODO(nate): parse text more cleanly
info = PROC.communicate()[0]
info = info.replace('\n    ', '\n')

notify(str(info))
