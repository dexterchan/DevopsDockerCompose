
## init a new config file
```
docker run --rm influxdb:alpine influxd config > influxdb.conf
```

## CREATE/UPDATE InfluxDB Meta Database
```
docker run --rm -e INFLUXDB_HTTP_AUTH_ENABLED=true \
         -e INFLUXDB_ADMIN_USER=admin \
         -e INFLUXDB_ADMIN_PASSWORD=admin123 \
         -v $PWD/influxdbdata:/var/lib/influxdb \
         -v $PWD/scripts:/docker-entrypoint-initdb.d \
         influxdb:alpine /init-influxdb.sh
#Verify
cat $PWD/data/meta/meta.db | grep one_week
expected:
Binary file (standard input) matches
```

## Run
```
docker-compose up -d
```

## testing
```
lsof -i:8086
curl -u admin:admin123 -G http://localhost:8086/query --data-urlencode "q=SHOW DATABASES"
```

##  telegraf
```
docker run --rm  telegraf:alpine telegraf config > telegraf.conf

Modify telegraf.conf
## HTTP Basic Auth
username = "admin"
password = "admin123"
```
### TELEGRAF RUN
```
docker run -d --name=telegraf \
      --net=container:influxdb \
      -e HOST_PROC=/host/proc \
      -v /proc:/host/proc:ro \
      -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
      telegraf:alpine
# verify the run
docker exec -it influxdb bash
influx -username admin -password admin123

> use telegraf
Using database telegraf
> SELECT * FROM cpu WHERE time > now() - 1m
```

# Reference
[Reference 1](https://thenewstack.io/how-to-setup-influxdb-telegraf-and-grafana-on-docker-part-1/)<br>
[Reference 2](https://thenewstack.io/how-to-setup-influxdb-telegraf-and-grafana-on-docker-part-2)<br>

[Reference 3](https://github.com/DataDog/java-dogstatsd-client)<br>

[Grafana Telegraf Dashboard](https://grafana.com/grafana/dashboards/1443)<br>
[Grafana Jmeter Dashboard](https://grafana.com/grafana/dashboards/5496)<br>
[Grafana JVM Metric](https://grafana.com/grafana/dashboards/9600)