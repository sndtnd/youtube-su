#!/bin/bash
email=""
password=""
cd /tmp/
mkdir youtube-su
cd youtube-su
echo "" > youtube.list
youtube-dl --max-quality 22 --prefer-free-formats --get-id -t -i -c -u "$email" -p "$password" http://www.youtube.com/feed/subscriptions >> youtube.list
