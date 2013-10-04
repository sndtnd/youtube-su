#!/bin/bash
mapfile -t creds < <(cat ~/.youtube-su.rc )
email=$(echo "${creds[0]}")
password=$(echo "${creds[1]}")
#email=""
#password=""
cd /tmp/
mkdir youtube-su
cd youtube-su
echo "" > youtube.list
time youtube-dl --max-quality 22 --prefer-free-formats --get-id -t -i -c -u "$email" -p "$password" http://www.youtube.com/feed/subscriptions >> youtube.list
sed -i -e "s/-/\\-/g;s/\&/\\&/g;s/\'/\\'/g"
