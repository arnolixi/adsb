#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $DIR
tar czf /tmp/adsb.tar.gz dump1090  get_message nginx  rtl-sdr  system_init
tar xf /tmp/adsb.tar.gz -C /root/
cd /root/system_init
bash init.sh
apt-get install  librtlsdr-dev libusb-1.0-0-dev libev-dev libssl-dev nginx  -y
apt-get remove ntp
cd /root/get_message/
mv rtl-sdr-blacklist.conf /etc/modprobe.d/
mv dump.sh /etc/init.d/dump
mv updatecode /etc/cron.d
mv taskcode   /etc/cron.d
chown -R root:root /etc/cron.d/taskcode
chown -R root:root /etc/cron.d/updatecode
chmod +x /etc/init.d/dump
mv task.sh /root/
chmod +x /root/task.sh
ldconfig
cd /root/dump1090/
make clean
make -j 4

cd /root/
mv -f  /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak
mv -f /etc/nginx/conf.d /etc/nginx/conf.d.bak 
cp -af nginx/*  /etc/nginx/
systemctl enable nginx
systemctl restart  nginx

cd /root/get_message/
python --version 2>/dev/null
if [ $? -eq 0 ]; then
    version=$(python -c 'import sys; print(sys.version_info[0])')
    if [ $version -eq 2 ]; then
        echo "Python 2 is installed"
	mv send_message.py2 send_message.py
        mv get_ip.py2  get_ip.py
    elif [ $version -eq 3 ]; then
        echo "Python 3 is installed"
	mv send_message.py3 send_message.py
	mv get_ip.py3  get_ip.py
    else
        echo "Unknown Python version: $version"
    fi
    python /root/get_message/get_ip.py
    UUID=`cat /root/get_message/UUID`
    echo "您当前共享数据的UUID为: $UUID"
else
    echo "Python is not installed"
fi
