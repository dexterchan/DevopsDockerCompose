#!/bin/sh
mount -a
exportfs -ar
exportfs -v
systemctl restart nfs-kernel-server.service