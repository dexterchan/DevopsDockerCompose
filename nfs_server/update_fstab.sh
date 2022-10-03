#!/bin/sh
PATH_NFS=$1
cat << EOF |  tee -a /etc/fstab
${PATH_NFS} /srv/nfs4  none   bind   0   0
EOF

cat << EOF |  tee -a /etc/exports
/srv/nfs4         172.16.0.0/16(rw,sync,no_subtree_check,crossmnt,fsid=0)
EOF