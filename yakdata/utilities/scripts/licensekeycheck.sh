#!/bin/bash

# /yakdata/utilities/scripts/licensekeycheck.sh

filekey=/yakdata/config/licensekeys/licensekey.txt

cut -b 1- $filekey > /tmp/lk.txt
mv /tmp/lk.txt $filekey

valid1=`cksum $filekey | cut -d" " -f1`

checkFast(){
    local n bits sign=''
    (($1<0)) && sign=-
    for (( n=$sign$1 ; n>0 ; n >>= 1 )); do bits=$((n&1))$bits; done
    printf "%s\n" "$sign${bits-0}"
}

license_end=`cat $filekey  | grep -o '..........$'`
l_e_d=`date -d "$license_end 7 days" +%s`
today=`date +%s`

ldv=false

if [[ "$today" < "$l_e_d" ]] && [ "`checkFast "$valid1"`" -lt "110000110101000001" ];
then
    ldv=true
    urlplus=`cat "$filekey" | grep -Eo '(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*) -' | sort -u`

    url=${urlplus::-2}
    echo -e "\n\nLicense key valid! Thanks for being a part of the YakData Community. Visit yakdatasupport.com to keep in touch as needed.\n"
    echo "$url $valid1 $l_e_d" > /yakdata/webassets/license.status
else
    echo -e "\n\nSorry, this is not a valid license key. Please contact support at yakdatasupport.com\n"
fi
