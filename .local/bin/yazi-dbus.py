#!/usr/bin/env python3
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
import subprocess
import urllib.parse
import os

class FileManager(dbus.service.Object):
    def __init__(self, bus, path):
        super().__init__(bus, path)

    def process_uri(self, uri):
        uri = urllib.parse.unquote(uri)
        if uri.startswith('file://localhost/'):
            path = uri[16:]
        elif uri.startswith('file://'):
            path = uri[7:]
        else:
            path = uri
        return os.path.expanduser(path)

    @dbus.service.method('org.freedesktop.FileManager1', in_signature='ass', out_signature='')
    def ShowItems(self, uris, startup_id):
        ...

    @dbus.service.method('org.freedesktop.FileManager1', in_signature='ass', out_signature='')
    def ShowItems(self, uris, startup_id):
        if not uris:
            return
        
        file_path = self.process_uri(uris[0])
        script_path = os.path.expanduser('~/.local/bin/open-in-filemanager')
        subprocess.Popen([script_path, file_path])

    @dbus.service.method('org.freedesktop.FileManager1', in_signature='ass', out_signature='')
    def ShowFolders(self, uris, startup_id):
        # Steam often calls ShowFolders instead of ShowItems
        self.ShowItems(uris, startup_id)

    @dbus.service.method('org.freedesktop.FileManager1', in_signature='ass', out_signature='')
    def ShowItemProperties(self, uris, startup_id):
        pass

if __name__ == '__main__':
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    session_bus = dbus.SessionBus()
    name = dbus.service.BusName('org.freedesktop.FileManager1', session_bus)
    object = FileManager(session_bus, '/org/freedesktop/FileManager1')
    loop = GLib.MainLoop()
    loop.run()
