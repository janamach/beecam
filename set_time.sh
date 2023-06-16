# This GUI uses yad to set time using "sudo date -s 'YYYY-MM-DD HH:MM:SS'“. The add has drop-down menus:
date_array=($(yad \
    --form --center \
    --borders=20 \
    --columns 2 \
    --separator="\\n" \
    --item-separator="," \
    --field="<big><b>Year</b></big>":NUM 2023,2015..2025,01 \
    --field="<big><b>Month</b></big>":NUM 07,01..12,01 \
    --field="<big><b>Day</b></big>":NUM 01,01..31,01 \
    --field="<big><b>Hour</b></big>":NUM 00,0..23,01 \
    --field="<big><b>Minute</b></big>":NUM 00,00..59,01 \
    --field="<big><b>Second</b></big>":NUM 00,00..59,01 ))

# The array is comma-separated, so we need to convert it to a strong in format "YYYY-MM-DD HH:MM:SS"
declare -p date_array
date_string="${date_array[0]}-${date_array[1]}-${date_array[2]} ${date_array[3]}:${date_array[4]}:${date_array[5]}"
echo $date_string
sudo date -s  $date_string > logg