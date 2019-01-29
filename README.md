# squid-transparent v. 4.4
Dockerfile for transparent proxy Squid with SSL Bump

## Quick Start

Create volumes:
```bash
  $ sudo docker volume create squid-logs
  $ sudo docker volume create squid-etc
  $ sudo docker volume create squid-cache
```
Start container:
```bash
$ sudo docker run -d --name squid-transparent --restart always --net host \
  -p 3129:3129 -p 3130:3130 -p 3131:3131 \
  --volume squid-logs:/var/log/squid \
  --volume squid-etc:/etc/squid \
  --volume squid-cache:/var/cache/squid \
  -e SSL_RSA=2048 \
  -e SSL_DAYS=365 \
	-e SSL_C=RU \
	-e SSL_ST=Saratov \
	-e SSL_L=Saratov \
	-e SSL_O=MyCompany \
	-e SSL_OU=MyCompany \
	-e SSL_CERT=SquidCA \
	-e TZ=Europe/Saratov
  Coun8s/squid-transparent:latest
```
TZ name must match the file from /usr/share/zoneinfo/. Example: Europe/Moscow or America/New_York.

SSL_* used to generate a certificate for Squid. Any value can be used. 

Add the following rules to your iptables:
```bash
  iptables -t nat -A PREROUTING -p tcp -m tcp -s 192.168.0.0/24 --dport 80 -j REDIRECT --to-ports 3129
  iptables -t nat -A PREROUTING -p tcp -m tcp -s 192.168.0.0/24 --dport 443 -j REDIRECT --to-ports 3130
```
