#!/bin/bash
email=""
password=""
mapfile -t link < <(cat /tmp/youtube-su/youtube.list)
for i in "${link[@]}"
do
if grep "${i##*\?}" ~/.watched.youtube.txt
then
echo "Watched $i already"
else
echo "$(youtube-dl -e http://youtube.com/watch?v=$i)" > /tmp/youtube-su/.current.youtube.txt
echo "http://youtube.com/watch?v=$i" >> /tmp/youtube-su/.current.youtube.txt

mplayer -vf scale=456:233 -cache 8912 -cookies -cookies-file /tmp/youtube-su/cookie.txt $(youtube-dl -u "$email" -p "$password" --prefer-free-formats --max-quality 22 -g --cookies \
/tmp/youtube-su/cookie.txt "http://youtube.com/watch?v=$i") &
mplayerpid=$!
until wmctrl -l -p | grep "mplayer2" &>/dev/null
do
sleep .3
done
wid=$(wmctrl -l -p | grep "mplayer2" | sed -e 's/\ .*//g')
wmctrl -r "$wid" -i -b toggle,sticky,above
mapfile -t geo < <(wmctrl -l -G | grep mplayer2 )
let x=$(xdpyinfo | grep 'dimensions:' | cut -f 2 -d ':' | cut -c5-8)-$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f5)-6
echo "0,$x,0,$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f5),$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f6)"
wmctrl -r "$wid" -i -e "0,$x,0,$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f5),$(echo ${geo[0]} | sed -e 's/ /,/g' | cut -d , -f6)"
echo "mplayer made above and sticky"
while ps "$mplayerpid" &>/dev/null
do
sleep .5
done
echo "$(youtube-dl -e http://youtube.com/watch?v=$i)" >> ~/.watched.youtube.txt
echo "http://youtube.com/watch?v=$i" >> ~/.watched.youtube.txt
echo "" >> ~/.watched.youtube.txt

fi
done

