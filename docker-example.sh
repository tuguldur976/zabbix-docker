docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net

docker run --name mysql-server -t \
    -e MYSQL_DATABASE="zabbixdb" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="Passw0rd" \
    -e MYSQL_ROOT_PASSWORD="StrongPassword" \
    --network=zabbix-net \
    -p 3306:3306 \
    -d mysql:8.0 \
    --character-set-server=utf8 --collation-server=utf8_bin \
    --default-authentication-plugin=mysql_native_password

docker run --name zabbix-server-mysql -t \
    -e DB_SERVER_HOST="mysql-server" \
    -e MYSQL_DATABASE="zabbixdb" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="Passw0rd" \
    -e MYSQL_ROOT_PASSWORD="StrongPassword" \
    --network=zabbix-net \
    -p 10051:10051 \
    --restart unless-stopped \
    -d zabbix/zabbix-server-mysql:ubuntu-6.0-latest

docker run --name zabbix-web-nginx-mysql -t \
      -e ZBX_SERVER_HOST="zabbix-server-mysql" \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbixdb" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="Passw0rd" \
      -e MYSQL_ROOT_PASSWORD="StrongPassword" \
      -e PHP_TZ="Asia/Ulaanbaatar" \
      --network=zabbix-net \
      -p 80:8080 \
      --restart unless-stopped \
      -d zabbix/zabbix-web-nginx-mysql:ubuntu-6.0-latest

docker exec -ti zabbix /bin/bash