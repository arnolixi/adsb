# adsb

*登录到树莓派中，需要确认树莓派设备可以正常访问互联网*
*安装脚本完成后 即可访问http://树莓派ip:8080*

## 全量安装
> 新的树莓派系统，需要安装dump1090程序
```bash
sudo apt -y install git
sudo git clone https://github.com/arnolixi/adsb.git
cd adsb
sudo bash all_install.sh
```

## 共享数据
> 先用的树莓派设备，已经安装了 dump1090 或 tar1090 等程序

```bash
sudo apt -y install git
sudo git clone https://github.com/arnolixi/adsb.git
cd adsb
sudo bash install.sh
```
