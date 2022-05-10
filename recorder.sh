#!/bin/bash
#
# Install gpac yad
# add "bash ~/recorder.sh" to .profile
# add "yad --info --center --button="Poweroff":"poweroff" --borders 20" to .profile
# Install SD card from here: https://spotpear.com/index/study/detail/id/141.html
# Do 'sudo nano /etc/apt/sources.list' and uncomment 'deb-src ...'
# Do 'sudo nano /etc/apt/apt.conf.d/10defaultRelease' and replace 'stable' with 'stretch'

while true; do
  ans=$(zenity --info --title 'Record a video' \
      --text 'Choose video duration in minutes' \
      --ok-label Quit \
      --extra-button 90 \
      --extra-button 30 \
      --extra-button 1 \
      --extra-button "Focus 10s" \
       )

### Quit if "Quit" is pressed
re='^[0-9]+$'

if ! [[ $ans =~ $re ]] ; then
    if [[ $ans = "Focus 10s" ]] ; then
        raspivid -t 10000 -w 1920 -h 1080 --roi 0.5,0.5,0.25,0.25
	bash ~/recorder.sh
        exit 1
    else
        exit 1
    fi
fi

### Create "count" file for counting if does not exist
if [ -f count ]; then
    echo "count file exists."
else
    echo "count file does not exist. Creating ..."    
    echo 0 > count
fi

### Add 1 to count
FNUMBER=$(< count)
FNUMBER=$((FNUMBER + 1))
echo ${FNUMBER} > count

VLENGTH=$((ans * 60000))
# echo ${VLENGTH} > ans

yad --timeout-indicator=top --posx=120 --posy=230 --timeout=$((ans * 60 + 5)) --borders=20 --text="Recording bees_${FNUMBER}.h264" --button 'Cancel video recording:killall raspivid & killall yad'  & \
raspivid -t ${VLENGTH} -b 1500000 -sa -100 -fps 30 -w 1920 -h 1080 -p 48,0,400,225 -o ~/Videos/bees_${FNUMBER}.h264

MP4Box -add ~/Videos/bees_${FNUMBER}.h264:fps=29.997 ~/Videos/bees_${FNUMBER}.mp4 && \
    yad --info --text "Video converted to bees_${FNUMBER}.mp4" --title="Info" --button="OK" --borders=20 --center

done
