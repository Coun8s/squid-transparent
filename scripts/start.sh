#!/bin/bash
if [[ $(ls -l /etc/localtime | grep -oh "${TZ}") != "${TZ}" ]]; then
	ln -sf /usr/share/zoneinfo/Europe/"$TZ" /etc/localtime
fi

if [[ ! -f "/etc/squid/ssl_cert/"$SSL_CERT".crt" && ! -f "/etc/squid/ssl_cert/"$SSL_CERT".key" && ! -f "/etc/squid/ssl_cert/dhparam.pem" ]]; then
	openssl req -new -newkey rsa:"$SSL_RSA" -sha256 -days "$SSL_DAYS" -nodes -x509 -extensions v3_ca -keyout /etc/squid/ssl_cert/SquidCA.key -out /etc/squid/ssl_cert/SquidCA.crt -days "$SSL_DAYS" -subj /C="$SSL_C"/ST="$SSL_ST"/L="$SSL_L"/O="$SSL_O"/OU="$SSL_OU"/CN="$HOSTNAME"
	openssl ecparam -list_curves -out /etc/squid/ssl_cert/dhparam.pem
	sed -i "s/https_port 3130 intercept.*/https_port 3130 intercept ssl-bump generate-host-certificates\=on dynamic_cert_mem_cache_size\=32MB cert\=\/etc\/squid\/ssl_cert\/${SSL_CERT}.crt key\=\/etc\/squid\/ssl_cert\/${SSL_CERT}.key tls-dh\=\/etc\/squid\/ssl_cert\/dhparam.pem/g" /etc/squid/squid.conf
fi
if [ ! -d "/var/cache/squid/00" ]; then
	/usr/sbin/squid --foreground -z
fi
exec /usr/sbin/squid -sYC -N
