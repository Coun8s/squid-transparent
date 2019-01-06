#!/bin/bash
ln -sf /usr/share/zoneinfo/"$TZ" /etc/localtime

if [ ! -f "/etc/squid/ssl_cert/"$SSL_CERT".pem" ]; then
	openssl req -new -newkey rsa:"$SSL_RSA" -sha256 -days "$SSL_DAYS" -nodes -x509 -extensions v3_ca -keyout /etc/squid/ssl_cert/"$SSL_CERT".pem -out /etc/squid/ssl_cert/"$SSL_CERT".pem -subj /C="$SSL_C"/ST="$SSL_ST"/L="$SSL_L"/O="$SSL_O"/OU="$SSL_OU"/CN="$HOSTNAME"
	sed -i "s/https_port 3130 intercept.*/https_port 3130 intercept ssl-bump generate-host-certificates\=on dynamic_cert_mem_cache_size\=32MB connection-auth\=off cert\=\/etc\/squid\/ssl_cert\/${SSL_CERT}.pem/g" /etc/squid/squid.conf
fi
if [ ! -d "/var/cache/squid/00" ]; then
	/usr/sbin/squid --foreground -z
fi
exec /usr/sbin/squid -sYC -N