#!/bin/bash
#
# Install gpac yad
# add "bash ~/recorder.sh" to .profile
# Install SD card from here: https://spotpear.com/index/study/detail/id/141.html
### Do 'sudo nano /etc/apt/sources.list' and uncomment 'deb-src ...'
### Do 'sudo nano /etc/apt/apt.conf.d/10defaultRelease' and replace 'stable' with 'stretch'
### To  deisable bluetooth and wifi, add this to '/boot/config.txt':
### dtoverlay=pi3-disable-wifi
### dtoverlay=pi3-disable-bt

# Edit for video settings

video_width=1640
video_height=1232
fps=30

# video_width=1920 video_height=1080
# fps=90 video_width=640 video_height=480

bitrate=1500000

convert_to_mp4=true
mp4_fps=$fps

# Edit for file numbering
count_from=1000

main () {
while true; do
  ans=$(zenity --info --title 'Record a video' \
      --text 'Choose video duration in minutes' \
      --ok-label Quit \
      --extra-button 90 \
      --extra-button 30 \
      --extra-button 1 \
      --extra-button "Focus" \
       )

### Quit if "Quit" is pressed
re='^[0-9]+$'

if ! [[ $ans =~ $re ]] ; then
    if [[ $ans = "Focus" ]] ; then
        raspivid -t 100000 -w 1920 -h 1080 --roi 0.6,0.5,0.25,0.25 -p 0,0,480,270 & \
        yad --info --timeout=100 --posy=273 \
            --button="Close this window":"killall raspivid & killall yad"
        main
        break
    else
        break
    fi
fi

### Create "count" file for counting if does not exist
if [ -f count ]; then
    echo "count file exists."
else
    echo "count file does not exist. Creating ..."
    echo ${count_from} > count
fi

### Write into USB if available

if [ -d $HOME/usb ]; then
    echo "$HOME/usb exists"
else
    mkdir ~/usb
fi

if [ -b /dev/sd*1 ]; then
    USB_DRIVE=$(echo /dev/sd*1)
    sudo mount $USB_DRIVE $HOME/usb -o umask=000
    VID_DIR=$HOME/usb
    ls $VID_DIR
else
    VID_DIR=$HOME/Videos
fi

### Add 1 to count
FNUMBER=$(< count)
FNUMBER=$((FNUMBER + 1))
echo ${FNUMBER} > count

VLENGTH=$((ans * 60000))
# echo ${VLENGTH} > ans

yad --timeout-indicator=top --posx=90 --posy=225 \
    --timeout=$((ans * 60 + 5)) \
    --text="Recording ${VID_DIR}/bees_${FNUMBER}.h264" \
    --button 'Cancel video recording:killall raspivid & killall yad'  & \

raspivid -t ${VLENGTH} -b ${bitrate} -sa -100 -fps ${fps} -w ${video_width} -h ${video_height} -p 0,0,480,225 -o ${VID_DIR}/bees_${FNUMBER}.h264

if $convert_to_mp4 ; then
    MP4Box -add ${VID_DIR}/bees_${FNUMBER}.h264:fps=${mp4_fps} ${VID_DIR}/bees_${FNUMBER}.mp4 && \
    yad --info --center --text "<big><big><big><big>Video converted to \n\nbees_${FNUMBER}.mp4</big></big></big></big>" \
        --title="Info" \
        --button="<big><big><big><big>OK</big></big></big></big>" --borders=20
fi

sudo umount $HOME

done
}

export -f main

copy_to_usb() {
if [ -b /dev/sd*1 ]; then
    USB_DRIVE=$(echo /dev/sd*1)
    sudo mount $USB_DRIVE $HOME/usb -o umask=000
    yad --info --text="<big><big>Copying video files to USB drive.\nDo not unplug.</big></big>"
    cp ~/Videos/*mp4 ~/usb
    mkdir ~/Videos_${FNUMBER}
    mv ~/Videos/*.* ~/Videos_${FNUMBER}
    yad --info --text="<big><big>Copying complete. \n\nSafe to unplug.</big></big>"
else
    yad --info --text="No USB drive detected"
fi
}

export -f copy_to_usb

while true; do
    main
    yad --info --center --borders=20 \
        --button="<big><big><big><big>Poweroff</big></big></big></big>":"poweroff" \
        --button="<big><big><big><big>Back</big></big></big></big>"       
done
