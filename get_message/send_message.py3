import socket
import urllib.request, urllib.parse
import sys
import configparser
import zlib
import base64
import os
import uuid

serverHost = 'localhost'
serverPort = 30003

config = configparser.ConfigParser()
config.read_file(open(sys.path[0]+'/config.ini',"r"))

uuid_file=sys.path[0]+'/UUID'

if os.path.exists(uuid_file) :
    with open(uuid_file, 'r') as file_object:
        mid = file_object.read()
else :
    mid = uuid.uuid1().hex[16:]
    with open(uuid_file , 'w') as file_object:
        file_object.write(mid)

def insert_mid(file_path='', mid=''):
    lines = []
    try:
        with open(file_path, 'r') as f:
            for line in f:
                lines.append(line)
    except IOError:
        pass

    if len(lines) >= 26:
        if lines[26].find('<h5>') < 0:
            lines.insert(26, '<h5>UUID: %s</h5>\n' %mid)
            with open(file_path, 'w+') as f:
                for line in lines:
                    f.write(line)

insert_mid(file_path=r'/root/dump1090/public_html/gmap.html', mid=mid)

sockobj = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
sockobj.connect((serverHost,serverPort))

def send_message(source_data):
    try:
        source_data=base64.b64encode(zlib.compress(source_data.encode())).decode()
        data =  urllib.parse.urlencode({'from':mid,'code':source_data}).encode()
        f=urllib.request.urlopen(url = config.get("global","sendurl"),data = data,timeout = 2)
        print("return: "+f.read().decode())
        return True
    except Exception as e:
        print(str(e))
        return True

tmp_buf=''

while 1:
    buf = sockobj.recv(1024).decode()
    if not buf: break
    if len(buf) != 0:
        tmp_buf=tmp_buf+buf
        if buf[len(buf)-1] == '\n':
            if send_message(tmp_buf) :
                tmp_buf=''


