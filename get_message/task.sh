#!/bin/bash
ps -eaf | grep dump1090 | grep -v grep
if [ $? -eq 1 ]
then
/etc/init.d/dump stop
sleep 1
/etc/init.d/dump start
echo `date "+%G-%m-%d %H:%M:%S"`" dump1090            restart"
echo "------------------------------------------------------------------------"
else
echo `date "+%G-%m-%d %H:%M:%S"`" dump1090            running"
echo "------------------------------------------------------------------------"
fi

ps -eaf | grep send_message.py | grep -v grep
# if not found - equals to 1, start it
if [ $? -eq 1 ]
then
python -O /root/get_message/send_message.py &
echo `date "+%G-%m-%d %H:%M:%S"`" send_message            restart"
echo "------------------------------------------------------------------------"
else
echo `date "+%G-%m-%d %H:%M:%S"`" send_message            running"
echo "------------------------------------------------------------------------"
fi

ps -eaf | grep get_ip.py | grep -v grep
# if not found - equals to 1, start it
if [ $? -eq 1 ]
then
python /root/get_message/get_ip.py
echo `date "+%G-%m-%d %H:%M:%S"`" get_ip            restart"
echo "------------------------------------------------------------------------"
else
echo `date "+%G-%m-%d %H:%M:%S"`" get_ip            running"
echo "------------------------------------------------------------------------"
fi



FILE_PATH="/root/get_message/UUID"
if [ -f "$FILE_PATH" ]; then
    echo "$FILE_PATH exists. Content of the file:"
    UUID=`cat "$FILE_PATH"`
    ps -eaf | grep rtty |grep -v grep
    if [ $? -eq 1 ]
    then
        /usr/local/bin/rtty -I "$UUID" -t "1dd1c98f8373988b5db55841999a37c9" -h 'adsb-rttys.feeyo.com' -p 5912 -a -av -D 
        echo `date "+%G-%m-%d %H:%M:%S"`" rtty  start"
	echo "------------------------------------------------------------------------"
    else
	echo `date "+%G-%m-%d %H:%M:%S"`" rtty  running"
	echo "------------------------------------------------------------------------"
    fi
fi
