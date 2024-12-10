

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