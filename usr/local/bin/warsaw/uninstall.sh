#!/bin/bash

if [ "$(whoami)" != "root" ]; then
  exit 2
fi

rm -rf /usr/local/bin/warsaw
rm -rf /usr/local/lib/warsaw
rm -rf /usr/local/etc/warsaw
rm -rf /usr/local/share/fonts/truetype/dbldwrsw.ttf
