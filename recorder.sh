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

fps=90
video_width=1920
video_height=1080
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

### Add 1 to count
FNUMBER=$(< count)
FNUMBER=$((FNUMBER + 1))
echo ${FNUMBER} > count

VLENGTH=$((ans * 60000))
# echo ${VLENGTH} > ans

yad --timeout-indicator=top --posx=120 --posy=225 \
    --timeout=$((ans * 60 + 5)) --borders=20 \
    --text="Recording bees_${FNUMBER}.h264" \
    --button 'Cancel video recording:killall raspivid & killall yad'  & \

raspivid -t ${VLENGTH} -b ${bitrate} -sa -100 -fps ${fps} -w ${video_width} -h ${video_height} -p 0,0,480,235 -o ~/Videos/bees_${FNUMBER}.h264

if $convert_to_mp4 ; then
    MP4Box -add ~/Videos/bees_${FNUMBER}.h264:fps=${mp4_fps} ~/Videos/bees_${FNUMBER}.mp4 && \
    yad --info --text "Video converted to bees_${FNUMBER}.mp4" --title="Info" --button="OK" --borders=20 --center
fi

done
}

export -f main

while true; do
    main
    yad --info --center --borders=20 \
        --button="Poweroff":"poweroff" \
        --button="Back"
done
