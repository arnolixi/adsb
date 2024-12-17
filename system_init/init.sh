#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $DIR
echo "alias ll='ls -l --color'" >> /etc/profile
echo "alias ls='ls --color'" >> /etc/profile
/usr/bin/cp -f raspi.list   /etc/apt/sources.list.d/raspi.list
/usr/bin/cp -f sources.list /etc/apt/sources.list
apt-get update
tar xf rtty-arm64.tar.gz -C /usr/local/bin/
apt-get install chrony -y
echo 'server ntp.aliyun.com iburst' > /etc/chrony/sources.d/feeyo.sources
sed  -i  's/^pool/#pool/g' /etc/chrony/chrony.conf
systemctl enable chrony
systemctl restart chrony
chronyc sources
