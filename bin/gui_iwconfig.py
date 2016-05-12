#!/usr/bin/python

"""
Output my wireless connection info
"""

import os
import re
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

FNULL = open(os.devnull, 'w')
PROC1 = subprocess.Popen('iwconfig', stdout=subprocess.PIPE, stderr=FNULL)
OUTPUT1 = PROC1.communicate()[0]

PROC2 = subprocess.Popen('ifconfig', stdout=subprocess.PIPE, stderr=FNULL)
OUTPUT2 = PROC2.communicate()[0]
FNULL.close()

try:
    m = re.search('Access Point: (..:..:..:..:..:..)', OUTPUT1)
    ACCESS_POINT = OUTPUT1[m.start(1):m.end(1)]
except AttributeError:
    ACCESS_POINT = 'Unknown'

try:
    m = re.search('ESSID:"(.*)"', OUTPUT1)
    SSID = OUTPUT1[m.start(1):m.end(1)]
except AttributeError:
    SSID = 'Unknown'

try:
    m = re.search('Link Quality=(../..) ', OUTPUT1)
    LINK_QUALITY = OUTPUT1[m.start(1):m.end(1)]
except AttributeError:
    LINK_QUALITY = 'Unknown'

try:
    m = re.search('wlan0.*\n.*inet addr:([0-9.]+) ', OUTPUT2)
    IP_ADDRESS = OUTPUT2[m.start(1):m.end(1)]
except AttributeError:
    IP_ADDRESS = 'Unknown'

AP_STR = ACCESS_POINT

LINK_STR = 'Link: '+LINK_QUALITY
OUTPUT = '\n'.join(['SSID: '+SSID, AP_STR, IP_ADDRESS, LINK_STR])

notify(str(OUTPUT))
