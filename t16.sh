#!/bin/bash

#solicitar la dirección IP o el rango de IPs al usuario
read -p "Introduce la dirección IP o el rango de IPs a escanear: " ip_range

#solicitar el rango de puertos al usuario
read -p "Introduce el rango de puertos a escanear (por ejemplo, 1-1000) : " port_range

#escaneo de puertos utilizando nmap
echo "escaneando puertos con nmap…"
nmap -p $port_range -oG - | grep "/open" > nmap_results.txt

#leer los resultados de nmap y usar netcat para verificar los puertos abiertos
echo "Verificando puertos abiertos con netcat…"
while read -r line; do
	ip=$(echo $line | grep -oP '\d+/open' | cut -d '/' -f l)
	for port in $ports; do
		nc -zv $ip $port 2>&1 | grep -q "open" && echo "Puerto $port está abierto"
	done
done < nmap_results.txt