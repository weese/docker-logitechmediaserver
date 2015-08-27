#!/bin/bash

latest_lms=$(wget -q -O - "http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb")
mkdir -p /sources
cd /sources
wget $latest_lms
lms_deb=$(echo $latest_lms|cut -d "/" -f8)
dpkg -i $lms_deb
ls /sources/logi* -1t | tail -3| xargs -d '\n' rm -f
