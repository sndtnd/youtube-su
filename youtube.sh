#!/bin/bash
mapfile -t creds < <(cat ~/.youtube-su.rc )
email=$(echo "${creds[0]}")
password=$(echo "${creds[1]}")
#email=""
#password=""
cd /tmp/
mkdir youtube-su
cd youtube-su
echo -n "" > youtube.list
time youtube-dl --get-id -t -i -c -u "$email" -p "$password" http://www.youtube.com/feed/subscriptions >> youtube.list
#sed -i -e "s/\-/\\-/g;s/\&/\\&/g;s/'/'/g" youtube.list
#sed -e 's/\-/\\-/g' /tmp/youtube-su/youtube.list
