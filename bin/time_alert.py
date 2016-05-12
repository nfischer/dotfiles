#!/usr/bin/python

"""
Alert me what time it is
"""

import time
import dbus

def notify(summary, body='', app_name='', app_icon='',
           timeout=5000, actions=[], hints=[], replaces_id=0):
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

# TODO(nate): parse text more cleanly

notify("It's currently " + str(time.strftime('%a %m/%d %I:%M')) + '. Go to sleep.')
