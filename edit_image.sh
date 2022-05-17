# Mount img to change its content. Usage:
# bash edit_image.sh IMAGEFILE.img boot or rootfs

# Unmount "/mnt/img" if no argument is given

if ! [[ $1 ]] ; then
  sudo umount /mnt/img
  echo "/mnt/img unmounted"
  exit 1
else
  IMGFILE=$1
fi

# Check if first argument is an exiting file

if [ -f "$IMGFILE" ]; then
  file ${IMGFILE}
else
  echo "$1 is not a valid filename"
  exit 1
fi

# Check if second argument is "boot". If not, mount rootfs

if [[ $2 == "boot" ]] ; then
  sudo mount ${IMGFILE} -o offset=$[512*8192] /mnt/img
  echo "
    Boot partition mounted in /mnt/img. To unmount type

    sudo umount /mnt/img

    or run this script without an argument

    "
  gnome-terminal --working-directory=/mnt/img 

elif [[ $2 == "rootfs" ]] ; then
  sudo mount ${IMGFILE} -o offset=$[512*98304] /mnt/img
  echo "

    Image mounted in /mnt/img. To unmount type

    sudo umount /mnt/img

    or run this script without an argument

    "
  gnome-terminal --working-directory=/mnt/img/home/pi/
  # code /mnt/img/home/pi/recorder.sh 
  # code /mnt/img/home/pi/.profile

else
  echo "
  Second argument should be either 'rootfs' or 'boot'
  "

fi
