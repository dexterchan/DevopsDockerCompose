#!/bin/bash

# Prepare scrape folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORK_DIR=`mktemp -d -p "$DIR"`

# download the cert
curl -k -fso /dev/null -w "\n%{certs}\n" https://slack.com > $WORK_DIR/slack_certs.crt

cat $WORK_DIR/slack_certs.crt

# mount the certificate to the container
cat << EOF | tee $WORK_DIR/run_update.sh
update-ca-certificates
sleep infinity
EOF

docker run --name grafana -itd --rm --user=root --entrypoint "" \
    -v $WORK_DIR/slack_certs.crt:/usr/local/share/ca-certificates/slack_ca.crt\ \
    -v $WORK_DIR/run_update.sh:/tmp/run_update.sh \
     grafana/grafana-oss bash /tmp/run_update.sh


docker commit $(docker ps | grep grafana | cut -d ' ' -f1)  boar/grafana-oss

# clean up
rm -Rf $WORK_DIR
docker stop grafana

docker inspect boar/grafana-oss | jq -r ".[0].Id"