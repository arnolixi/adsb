#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $DIR
tar czf /tmp/adsb.tar.gz install_share.sh get_message  system_init
tar xf /tmp/adsb.tar.gz  -C /root/
cd /root/system_init/
bash init.sh
cd /root/get_message
mv share.sh  /root/task.sh
chmod +x /root/task.sh
mv taskcode /etc/cron.d/
mv updatecode /etc/cron.d/
chown -R root:root /etc/cron.d/taskcode
chown -R root:root /etc/cron.d/updatecode

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
else
    echo "Python is not installed"
fi

python /root/get_message/get_ip.py
UUID=`cat /root/get_message/UUID`
echo "您当前共享数据的UUID为: $UUID"
