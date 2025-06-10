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
apt -y install python3 python3-pip python3-venv python3-pygame supervisor mpv ntfs-3g exfat-fuse
apt -y install python3-dev python3-setuptools
apt -y install python3-rpi.gpio python3-pigpio python3-gpiozero
apt -y install raspi-gpio pigpio

# Start GPIO daemon
systemctl enable pigpiod
systemctl start pigpiod

echo "Installing video_looper program..."
echo "=================================="

# change the directory to the script location
cd "$(dirname "$0")"

# Create required directories
mkdir -p /mnt/usbdrive0
mkdir -p /home/KT/video

# Create group if it doesn't exist and set ownership
groupadd -f KT
usermod -a -G KT KT
usermod -a -G gpio KT
chown -R KT:KT /home/KT/video

# Create and activate virtual environment
VENV_PATH="/home/KT/video_looper_env"
python3 -m venv $VENV_PATH
chown -R KT:KT $VENV_PATH

# Install packages in virtual environment
su - KT << EOF
source $VENV_PATH/bin/activate
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install .
deactivate
EOF

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
environment=PYTHONPATH=/usr/lib/python3/dist-packages:%(ENV_PYTHONPATH)s
EOF

# Copy configuration file
cp ./assets/video_looper.ini /boot/video_looper.ini

echo "Configuring video_looper to run on start..."
echo "==========================================="

# Ensure log file exists and has correct permissions
touch /var/log/video_looper.log
chown KT:KT /var/log/video_looper.log

# Restart supervisor
systemctl restart supervisor

echo "Finished!"
