
# Testing
https://github.com/aussiearef/grafana-udemy

# Slack access
WE need to customize grafana image to include CA bundle from Slack.com before enabling Slack access. <br>
Otherwise, we hit CA problem:
```
Post "https://slack.com/api/chat.postMessage": t|s: failed to verify certificate: x509: certificate signed by unknown authority
```
Steps [ref](https://docs.docker.com/engine/network/ca-certs/):
Get the CA bundle from slack:
```
curl -k -fso /dev/null -w "\n%{certs}\n" https://slack.com > certs.txt
```
Volume mount the file to "/usr/local/share/ca-certificates/slack_ca.crt"
```
docker run -it --rm --user=root --entrypoint "" -v ./grafana-tmp/slack.certs.cer:/usr/local/share/ca-certificates/slack_ca.crt grafana/grafana-oss bash
```
Execute:

```
update-ca-certificates
```

Commit the image to a new container image:
```
docker commit $(docker ps | grep grafana | cut -d ' ' -f1)  boar/grafana-oss
```

#Sample loki setup docker compose yaml
```
version: "3"

networks:
  loki:

services:
  loki:
    image: grafana/loki:2.9.2
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - loki

  promtail:
    image: grafana/promtail:2.9.2
    volumes:
      - /var/log:/var/log
    command: -config.file=/etc/promtail/config.yml
    networks:
      - loki

  grafana:
    environment:
      - GF_PATHS_PROVISIONING=/etc/grafana/provisioning
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    entrypoint:
      - sh
      - -euc
      - |
        mkdir -p /etc/grafana/provisioning/datasources
        cat <<EOF > /etc/grafana/provisioning/datasources/ds.yaml
        apiVersion: 1
        datasources:
        - name: Loki
          type: loki
          access: proxy 
          orgId: 1
          url: http://loki:3100
          basicAuth: false
          isDefault: true
          version: 1
          editable: false
        EOF
        /run.sh
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    networks:
      - loki

```