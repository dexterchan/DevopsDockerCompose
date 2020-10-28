
## init a new config file
```
docker run --rm influxdb:alpine influxd config > influxdb.conf
```

## CREATE/UPDATE InfluxDB Meta Database
```
docker run --rm -e INFLUXDB_HTTP_AUTH_ENABLED=true \
         -e INFLUXDB_ADMIN_USER=admin \
         -e INFLUXDB_ADMIN_PASSWORD=admin123 \
         -v $PWD/data:/var/lib/influxdb \
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
curl -G http://localhost:8086/query --data-urlencode "q=SHOW DATABASES"
```

# Reference
[Reference 1](https://thenewstack.io/how-to-setup-influxdb-telegraf-and-grafana-on-docker-part-1/)
[Reference 2](https://thenewstack.io/how-to-setup-influxdb-telegraf-and-grafana-on-docker-part-2)

[Reference 3](https://github.com/DataDog/java-dogstatsd-client)