#!/usr/bin/python

import dbus
import sys

DEFAULT_TIMEOUT = 4000
def notify(summary, body='', app_name='', app_icon='',
        timeout=DEFAULT_TIMEOUT, actions=[], hints=[], replaces_id=0):
    _bus_name = 'org.freedesktop.Notifications'
    _object_path = '/org/freedesktop/Notifications'
    _interface_name = _bus_name

    session_bus = dbus.SessionBus()
    obj = session_bus.get_object(_bus_name, _object_path)
    interface = dbus.Interface(obj, _interface_name)
    interface.Notify(app_name, replaces_id, app_icon,
            summary, body, actions, hints, timeout)

# If run as a script, just display the argv as summary
if __name__ == '__main__':
    notify(summary=' '.join(sys.argv[1:]))
