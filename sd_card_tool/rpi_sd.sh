yad --into --center --borders=20 \
    --title='Raspberry Pi SD Card' \
    --text='<big>Insert the Raspberry Pi SD card and selection action:</big>' \
    --button="Open Videos":"nautilus /media/jana/rootfs/home/pi/Videos/" \
    --button="Unmount SD Card":"umount /media/jana/rootfs /media/jana/boot" && "yad --info --text='Done!'" 
