sudo apt update
sudo apt install -y gpac yad
git clone https://github.com/janamach/beecam.git
echo bash ~/beecam/recorder.sh > .profile
echo "Expand file system"
sudo raspi-config

### Do 'sudo nano /etc/apt/sources.list' and uncomment 'deb-src ...'
### Do 'sudo nano /etc/apt/apt.conf.d/10defaultRelease'
### and replace 'stable' with 'stretch'
