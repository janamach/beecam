#!/bin/bash
#
# Install gpac
# Install touch screen driver:

  ans=$(zenity --info --title 'Record a video' \
      --text 'Choose video duration in minutes' \
      --ok-label Quit \
      --extra-button 30 \
      --extra-button 10 \
      --extra-button 5 \
      --extra-button 1 \
       )

### Quit if "Quit" is pressed
re='^[0-9]+$'
if ! [[ $ans =~ $re ]] ; then
   echo "Quitting ..." >&2; exit 1
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

raspivid -t ${VLENGTH} -b 1500000 -sa -100 -fps 30 -w 1920 -h 1080 -o ~/Videos/bees_${FNUMBER}.h264
MP4Box -add ~/Videos/bees_${FNUMBER}.h264:fps=29.997 ~/Videos/bees_${FNUMBER}.mp4
#zenity --info --text="Recording video"
