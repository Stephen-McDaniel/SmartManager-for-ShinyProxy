#!/bin/bash

# update SSL if older than 60 days
# see /etc/cron.d/checkagerenewssl
# 33 8 * * 0 ydadmin  /yakdata/utilities/scripts/checkagerenewssl.sh
# Tries to run every Sunday

ENVFILE="/yakdata/apps/.env"
AGE=0
if test -f "$ENVFILE"; then
  . "$ENVFILE"
  AGE=$(($(date +%s)-$(date -r /yakdata/certs/$DOMAIN.chained.pem +%s)))
fi

# SMD - 60 days or older, update
if [ $AGE -gt 5184000 ]; then

 . /yakdata/utilities/scripts/renewssl.sh

fi
