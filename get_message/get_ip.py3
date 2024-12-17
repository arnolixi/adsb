import socket
import fcntl
import struct
import urllib.request
import urllib.parse
import sys,os
import configparser
import hashlib
import json
import uuid

config = configparser.ConfigParser()
config.read_file(open(os.path.join(sys.path[0],'config.ini'),"r"))

uuid_file=os.path.join(sys.path[0],'UUID')

if os.path.exists(uuid_file) :
    with open(uuid_file, 'r') as file_object:
        mid = file_object.read()
else :
    mid = uuid.uuid1().hex[16:]
    with open(uuid_file , 'w') as file_object:
        file_object.write(mid)

def send_message(source_data):
    source_data=source_data.replace('\n','$')
    f=urllib.request.urlopen(
            url = config.get("global","ipurl"),
            data =  source_data.encode(),
            timeout = 60
            )
    tmp_return=f.read().decode()

    request_json=json.loads(tmp_return)
    request_md5=request_json['md5']
    del request_json['md5']

    tmp_hash=''
    for i in request_json:
        if tmp_hash=='' :
            tmp_hash=tmp_hash+request_json[i]
        else :
            tmp_hash=tmp_hash+','+request_json[i]

    md5=hashlib.md5(tmp_hash.encode('utf-8')).hexdigest()

    if (md5 == request_md5):
        operate(request_json)
    else :
        print('MD5 ERR')

    print("return: "+tmp_return)

def get_ip_address(ifname):
    skt = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    pktString = fcntl.ioctl(skt.fileno(), 0x8915, struct.pack('256s', ifname[:15].encode('utf-8')))
    ipString  = socket.inet_ntoa(pktString[20:24])
    return ipString

def operate(request_json):
    if request_json['type'] == 'reboot' :
        os.system('/sbin/reboot')
    elif request_json['type'] == 'code' :
        with open ( urllib.parse.unquote( request_json['path'] ) , 'w' ) as fileHandle:
            fileHandle.write( urllib.parse.unquote( request_json['content'] ) )
    else :
        print('OK')

eth=get_ip_address('eth0')

send_message(mid+'|'+eth+'|')

