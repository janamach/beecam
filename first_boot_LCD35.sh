# First:
# cp .profile .profile_original
# echo "bash ~/first_boot_LCD35.sh" > .profile

sudo apt update
sudo apt dist-upgrade -y

cd beecam
git pull

cd LCD-show
bash LCD35-show 180 & echo '\
   sudo sed -i "s/start_x=0/start_x=1/g" /boot/config.txt && \
   mv .profile_original .profile && sudo reboot' \
   > ~/.profile
sudo reboot
