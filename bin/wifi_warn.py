#!/usr/bin/python

import dbus
import os
import re
import subprocess

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
    PROC1 = subprocess.Popen(["hostname", "-I"], stdout=subprocess.PIPE)
    IP_ADDR = PROC1.communicate()[0]

    try:
        if IP_ADDR != '\n':
            FNULL = open(os.devnull, 'w')
            PROC2 = subprocess.Popen(["iwconfig"], stdout=subprocess.PIPE, stderr=FNULL)
            OUTPUT = PROC2.communicate()[0]
            FNULL.close()

            # Find SSID
            m = re.search('ESSID:"(.*)"', OUTPUT)
            SSID = OUTPUT[m.start(1):m.end(1)]
            # Find ACCESS_POINT
            m = re.search('Access Point: (..:..:..:..:..:..)', OUTPUT)
            ACCESS_POINT = OUTPUT[m.start(1):m.end(1)]
            if SSID == 'ThetaChi' and ACCESS_POINT != 'C0:56:27:5F:95:16':
                # We might crash
                MSG_STRING = 'Warning: You may not be connected to a valid access point'
                notify(summary=MSG_STRING)
                exit(1)
        else:
            exit(0)
    except Exception as e:
        exit(0)

    exit(0)
