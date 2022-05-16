#!/bin/bash
#
# Spin-off of recorder.sh. The purpose of this file is to identify the right video resolution for an  experiment.

fps=30
bitrate=1500000
convert_to_mp4=true
mp4_fps=$fps
ans=30

# Edit for file numbering
count_from=1000

main () {
while true; do
  ABCD=$(zenity --info --title 'Record a video' \
      --text 'Choose video option' \
      --ok-label Quit \
      --extra-button A \
      --extra-button B \
      --extra-button C \
      --extra-button D \
       )

if [[ $ABCD = "A" ]] ; then
    video_width=1640
    video_height=1232
elif [[ $ABCD = "B" ]] ; then
    video_width=1280
    video_height=720
elif [[ $ABCD = "C" ]] ; then
    video_width=1920
    video_height=1080
elif [[ $ABCD = "D" ]] ; then
    video_width=640
    video_height=480            
else
    break
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

VLENGTH=$((30 * 60000))
# echo ${VLENGTH} > ans

yad --timeout-indicator=top --posx=120 --posy=225 \
    --timeout=$((ans * 60 + 5)) --borders=20 \
    --text="Recording ${ans}_${FNUMBER}.h264" \
    --button 'Cancel video recording:killall raspivid & killall yad'  & \

raspivid -t ${VLENGTH} -b ${bitrate} -sa -100 -fps ${fps} -w ${video_width} -h ${video_height} -p 0,0,480,235 -o ~/Videos/${ans}_${FNUMBER}.h264

if $convert_to_mp4 ; then
    MP4Box -add ~/Videos/${ans}_${FNUMBER}.h264:fps=${mp4_fps} ~/Videos/${ans}_${FNUMBER}.mp4 && \
    yad --info --center --text "<big><big><big><big>Video converted to \n\n${ans}_${FNUMBER}.mp4</big></big></big></big>" \
        --title="Info" \
        --button="<big><big><big><big>OK</big></big></big></big>" --borders=20
fi
done
}

export -f main

while true; do
    main
    yad --info --center --borders=20 \
        --button="<big><big><big><big>Poweroff</big></big></big></big>":"poweroff" \
        --button="<big><big><big><big>Back</big></big></big></big>"
done
