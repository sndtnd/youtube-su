#!/bin/bash
mapfile -t creds < <(cat ~/.youtube-su.rc )
email=$(echo "${creds[0]}")
password=$(echo "${creds[1]}")
#email=""
#password=""
mapfile -t link < <(cat /tmp/youtube-su/youtube.list)
for i in "${link[@]}"
do
#if grep "${i##*\?}" ~/.watched.youtube.txt
if grep "$i" ~/.watched.youtube.txt
then
echo "Watched $i already"
else
echo "$(youtube-dl -e "http://youtube.com/watch?v=$i")" > /tmp/youtube-su/.current.youtube.txt
echo "http://youtube.com/watch?v=$i" >> /tmp/youtube-su/.current.youtube.txt

mplayer -vf scale=456:233 -cache 8912 -cookies -cookies-file /tmp/youtube-su/cookie.txt $(youtube-dl -u "$email" -p "$password" --prefer-free-formats --max-quality 22 -g --cookies \
/tmp/youtube-su/cookie.txt "http://youtube.com/watch?v=$i") &
mplayerpid=$!
until wmctrl -l -p | grep -i "mplayer" &>/dev/null
do
echo "Waiting for mplayer"
sleep .5
done
wid=$(wmctrl -l -p | grep -i "mplayer" | sed -e 's/\ .*//g')
wmctrl -r "$wid" -i -b toggle,sticky,above
mapfile -t geo < <(wmctrl -l -G | grep -i "mplayer" )
let dim1=$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f5)
let dim2=$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f6)
let x=$(xdpyinfo | grep 'dimensions:' | cut -f 2 -d ':' | cut -c5-8)-${dim1}-6
#echo "0,$x,0,$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f5),$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f6)"
wmctrl -r "$wid" -i -e "0,$x,0,${dim1},${dim2}"
echo "mplayer made above and sticky"
while ps "$mplayerpid" &>/dev/null
do
sleep .5
done
echo "$(youtube-dl -e "http://youtube.com/watch?v=$i")" >> ~/.watched.youtube.txt
echo "http://youtube.com/watch?v=$i" >> ~/.watched.youtube.txt
echo "" >> ~/.watched.youtube.txt

fi
done

