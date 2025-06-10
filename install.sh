#!/bin/sh

# Error out if anything fails.
set -e

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./install.sh"
  exit 1
fi


echo "Installing dependencies..."
echo "=========================="
# First update and install system packages
apt update
apt -y install python3 python3-pip python3-pygame supervisor mpv ntfs-3g exfat-fuse python3-venv
apt -y install python3-dev python3-setuptools
apt -y install python3-rpi.gpio python3-pigpio python3-gpiozero
apt -y install raspi-gpio pigpio

if [ "$*" != "no_hello_video" ]
then
	echo "Installing hello_video..."
	echo "========================="
	apt -y install git build-essential python3-dev
	git clone https://github.com/adafruit/pi_hello_video
	cd pi_hello_video
	./rebuild.sh
	cd hello_video
	make install
	cd ../..
	rm -rf pi_hello_video
else
    echo "hello_video was not installed"
    echo "=========================="
fi

echo "Installing video_looper program..."
echo "=================================="

# change the directoy to the script location
cd "$(dirname "$0")"

mkdir -p /mnt/usbdrive0 # This is very important if you put your system in readonly after
mkdir -p /home/KT/video # create default video directory

# Create group if it doesn't exist and set ownership
groupadd -f KT
usermod -a -G KT KT
usermod -a -G gpio KT
chown -R KT:KT /home/KT/video

# Start GPIO daemon
systemctl enable pigpiod
systemctl start pigpiod

# Create and activate virtual environment
VENV_PATH="/home/KT/video_looper_env"
python3 -m venv $VENV_PATH --system-site-packages
chown -R KT:KT $VENV_PATH

# Activate virtual environment and install packages
. $VENV_PATH/bin/activate
pip3 install setuptools
pip3 install RPi.GPIO pigpio
python3 setup.py install --force
deactivate

# Create service file for supervisor
cat > /etc/supervisor/conf.d/video_looper.conf << EOF
[program:video_looper]
command=$VENV_PATH/bin/python3 -m Adafruit_Video_Looper.video_looper
directory=/home/KT
user=KT
autostart=true
autorestart=true
stdout_logfile=/var/log/video_looper.log
redirect_stderr=true
environment=PYTHONPATH="/usr/lib/python3/dist-packages:%(ENV_PYTHONPATH)s"
EOF

cp ./assets/video_looper.ini /boot/video_looper.ini

echo "Configuring video_looper to run on start..."
echo "==========================================="

service supervisor restart

echo "Finished!"
