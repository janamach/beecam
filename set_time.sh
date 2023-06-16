# This GUI uses yad to set time using "sudo date -s 'YYYY-MM-DD HH:MM:SS'“. The add has drop-down menus:
date_array=($(yad \
    --form --center \
    --borders=20 \
    --columns 2 \
    --separator="\\n" \
    --item-separator="," \
    --field="<big><b>Year</b></big>":NUM 2023,2015..2025,1 \
    --field="<big><b>Month</b></big>":NUM 06,1..12,1 \
    --field="<big><b>Day</b></big>":NUM 16,1..31,1 \
    --field="<big><b>Hour</b></big>":NUM 17,0..23,1 \
    --field="<big><b>Minute</b></big>":NUM 05,0..59,1 \
    --field="<big><b>Second</b></big>":NUM 05,0..59,1 ))

# The array is comma-separated, so we need to convert it to a strong in format "YYYY-MM-DD HH:MM:SS"
declare -p date_array
date_string="${date_array[0]}-${date_array[1]}-${date_array[2]} ${date_array[3]}:${date_array[4]}:${date_array[5]}"
echo $date_string