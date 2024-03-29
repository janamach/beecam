#!/bin/bash
#
# Install gpac yad
# Do 'echo "bash ~/beecam/recorder_jessie.sh" >> ~/.profile'
# Install SD card from here: https://spotpear.com/index/study/detail/id/141.html
### Do 'sudo nano /etc/apt/sources.list' and uncomment 'deb-src ...'
### Do 'sudo nano /etc/apt/apt.conf.d/10defaultRelease' and replace 'stable' with 'stretch'
### To  deisable bluetooth and wifi, add this to '/boot/config.txt':
### dtoverlay=pi3-disable-wifi
### dtoverlay=pi3-disable-bt
## Disable screensaved by editing /etc/lightdm/lightdm.conf and replacing
## "xserver-command=X" with "xserver-command=X -s 0 -p 0 -dpms"

# Edit for video settings

fps=15
saturation=0 # For black and white use -100. default is 0
exposure_mode="auto"

# video_width=1920 video_height=1080
# fps=90 video_width=640 video_height=480

bitrate=10000000
TIME_MIN=180

convert_to_mp4=false
mp4_fps=$fps
EXTRA_PARAM="" #"-ISO 800 -ss 10000 -co 10 -sh 100"

main () {
while true; do
  video_width=$(zenity --info --title 'Record a video' \
      --text 'Choose video width' \
      --ok-label Quit \
      --extra-button 3280 \
      --extra-button 1280 \
      --extra-button 1920 \
      --extra-button "Focus" \
       )

### Quit if "Quit" is pressed
re='^[0-9]+$'

if ! [[ $video_width =~ $re ]] ; then
    if [[ $video_width = "Focus" ]] ; then
        raspivid -t 100000 -w 1920 -h 1080 --roi 0.6,0.5,0.25,0.25 -p 0,0,480,270 & \
        yad --info --timeout=100 --posy=273 \
            --button="<big><big><big><b>Close this window</b></big></big></big>":"killall raspivid & killall yad"
        main
        break
    else
        break
    fi
elif [[ $video_width = 3280 ]] ; then
    export video_height=2464
elif [[ $video_width = 1280 ]] ; then
    export video_height=720
else
    export video_height=1080
fi

VLENGTH=$((TIME_MIN * 60000))
# echo ${VLENGTH} > ans
VID_DIR="/home/pi/Videos/"
FNUMBER="`date +%Y%m%d_%H%M%S`_${fps}_fps"

yad --timeout-indicator=top --posx=90 --posy=245 --text-align=center \
    --timeout=$((TIME_MIN * 60 + 5)) \
    --text="<big><big><b><span color='red'>${FNUMBER}.h264</span></b></big></big>" \
    --button '<big><big><b>Cancel video recording</b></big></big>:killall raspivid & killall yad'  & \

raspivid -t ${VLENGTH} -b ${bitrate} -sa ${saturation} -ex ${exposure_mode} -fps ${fps} ${EXTRA_PARAM} -w ${video_width} -h ${video_height} -p 0,0,480,245 -o ${VID_DIR}/${FNUMBER}.h264

if $convert_to_mp4 ; then
    yad --info --center --text="<big><big><big><b>\nConverting to mp4.\n\nPlease wait...</b></big></big></big>" --no-buttons --text-align=center --borders=20 &\
    MP4Box -add ${VID_DIR}/${FNUMBER}.h264:fps=${mp4_fps} ${VID_DIR}/${FNUMBER}.mp4 && \
    yad --info --center --text "<big><big><big><big>Video converted to \n\n<span color='red'><b>${FNUMBER}.mp4</b></span></big></big></big></big>" \
        --title="Info" --text-align=center \
        --button="<big><big><big><big>OK</big></big></big></big>:killall yad" --borders=20
fi

done
}

export -f main

while true; do
    main
    yad --info --center --borders=20 \
        --button="<big><big><big><b>Poweroff</b></big></big></big>":"poweroff" \
        --button="<big><big><big>Back</big></big></big>" \
        --button="<big><big><big>Restart</big></big></big>":"reboot"
done
