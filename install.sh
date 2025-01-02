#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $DIR
tar czf /tmp/adsb.tar.gz install.sh get_message  system_init
tar xf /tmp/adsb.tar.gz  -C /root/
cd /root/system_init/
bash init.sh
cd /root/get_message
mv /root/share.sh /root/share.sh.bak  2> /dev/null
mv share.sh  /root/share.sh
chmod +x /root/share.sh
mv sharecode /etc/cron.d/sharecode
mv updatecode /etc/cron.d/updatecode
chown -R root:root /etc/cron.d/updatecode /etc/cron.d/sharecode
chmod 644 /etc/cron.d/updatecode /etc/cron.d/sharecode

# 检测Python环境版本号
PyPath=""
if which python > /dev/null 2>&1; then
    PyPath=$(which python)
elif which python3 > /dev/null 2>&1; then
    PyPath=$(which python3)
elif which python2 > /dev/null 2>&1; then
    PyPath=$(which python2)
else
    echo "需要安装python环境"
    exit 1
fi
version=$(eval "$PyPath -c 'import sys; print(sys.version_info[0])'")
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
	echo "未知的python版本，请联系脚本作者!或自行修改python脚本"
	exit 1
fi

python /root/get_message/get_ip.py
UUID=`cat /root/get_message/UUID`
echo "您当前(自动生成)共享数据的UUID为: $UUID"

read -p "如果你想修改数据共享UUID？(请输入 Y/y/yes 进行确认修改， 直接回车默认不修改): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
if [ "$answer" == "y" ] || [ "$answer" == "yes" ]; then
    # 用户输入了 "Y"、"y" 或者 "yes" ,则继续让用户输入 UUID
     read -p "请输入你的UUID: " uuid_str
     echo -n "$uuid_str" > /root/get_message/UUID
     echo "您当前(已经更改)共享数据的UUID为: `cat /root/get_message/UUID`"
     echo "UUID如上，如果有异常请手动修改文件 /root/get_message/UUID"
fi

