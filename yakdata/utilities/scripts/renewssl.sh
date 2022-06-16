#!/bin/bash

cp /yakdata/apps/.env /yakdata/utilities/acme/ydeploy

. "/yakdata/utilities/acme/ydeploy/.env"

echo "$DOMAIN" > /root/hostname
mv /root/hostname /etc/hostname
chmod 644 /etc/hostname

cd /yakdata/apps

docker-compose down

sleep 5

cd /yakdata/utilities/acme/ydeploy

docker network create nat
docker-compose up -d

sleep 5

docker exec acme \
   --issue \
   --force \
   -d "$DOMAIN"  \
   -m "$AdminEmail" \
   --standalone   \
   --server zerossl \
   --httpport 80

docker-compose down

cd /yakdata/utilities/acme/ycustcontrol/admin_server_specific/acme.sh/$DOMAIN

mkdir -p ../../final/

rm -f *.pem

cat fullchain.cer $DOMAIN.key > /root/$DOMAIN.chained.pem

cd /root
ls -al $DOMAIN.chained.pem

mkdir -p /yakdata/certs/old
rm -f /yakdata/certs/old/*

rm -fR /yakdata/certs/*
cp $DOMAIN.chained.pem /yakdata/certs
chmod 600 /yakdata/certs/$DOMAIN.chained.pem
ls -al /yakdata/certs/$DOMAIN.chained.pem

cd /yakdata/utilities/acme/ydeploy
docker-compose down

docker network rm nat

sleep 5

cd /yakdata/apps
docker-compose up -d

sleep 5

docker ps

# in case host name changed
reboot
