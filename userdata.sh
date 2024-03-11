#!/bin/bash
docker pull docker pull maverick8266/petclinic:14
docker run -e MYSQL_URL=jdbc:mysql://${mysql_url}/petclinic -e DATABASE_TYPE=mysql -e SPRING.PROFILES.ACTIVE=mysql -p 80:8080 maverick8266/petclinic:14