#!/bin/sh
spawn-fcgi -s /var/run/fcgiwrap.socket -M 0700 -u nginx -g www-data /usr/bin/fcgiwrap
