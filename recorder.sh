#!/bin/bash
#
# Install gpac yad
# add "bash ~/recorder.sh" to .profile
# Install SD card from here: https://spotpear.com/index/study/detail/id/141.html
# Do 'sudo nano /etc/apt/sources.list' and uncomment 'deb-src ...'

while true; do
  ans=$(zenity --info --title 'Record a video' \
      --text 'Choose video duration in minutes' \
      --ok-label Quit \
      --extra-button 30 \
      --extra-button 10 \
      --extra-button 5 \
      --extra-button 2 \
      --extra-button "Power off" \
       )

### Quit if "Quit" is pressed
re='^[0-9]+$'

if ! [[ $ans =~ $re ]] ; then
    if [[ $ans = "Power off" ]] ; then
        echo "Power off"; poweroff; exit 1
    else
        echo "Quitting ..." >&2; exit 1
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

raspivid -t ${VLENGTH} -b 1500000 -sa -100 -fps 30 -w 1920 -h 1080 -p 10,10,160,90 -o ~/Videos/bees_${FNUMBER}.h264 & \
    ( for i in `seq 1 100`; do echo $i ; echo "#Recording $ans minutes. Progress: $i %";  sleep $((ans * 60 / 100)); done ) \
    | yad --progress --center --borders=20 --button 'Cancel video recording:killall raspivid & killalll yad'

MP4Box -add ~/Videos/bees_${FNUMBER}.h264:fps=29.997 ~/Videos/bees_${FNUMBER}.mp4 && \
    yad --info --text "Video converted to mp4" --title="Info" --button="OK" --borders=20 --center
# zenity --info --text="Recording video" --display=:0.0

done
