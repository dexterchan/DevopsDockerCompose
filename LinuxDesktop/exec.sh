#!/bin/sh

docker run -d \
  --name=rdesktop \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3389:3389 \
  --restart unless-stopped \
  lscr.io/linuxserver/rdesktop:latest