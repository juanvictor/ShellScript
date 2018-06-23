#!/bin/bash

#MEMORIA RAM
ram_total=$(free -m | grep Mem | tr -s ' ' | cut -d ' ' -f2)
ram_usado=$(free -m | grep Mem | tr -s ' ' | cut -d ' ' -f3)
ram_usado_porcentaje=$(expr $ram_usado \* 100 / $ram_total)
ram_libre_porcentaje=$(expr 100 - $ram_usado_porcentaje)

#CONECTIVIDAD
conectividad="NO"
myping=$(ping -c 1 google.com 2> /dev/null)
if [ $? -eq 0 ] ; then
       conectividad="OK"
fi

#ESPACIO EN DISCO
df > espacio_disco_lista
espacio_disco=espacio_disco_lista
sw=0
sumatorio=0
for valor in $(cat espacio_disco_lista | tr -s ' ' | cut -d ' ' -f2)
do
	if [ $sw -eq 0 ]
	then
		sw=1
	else	
		let sumatoria=sumatoria+$valor
	fi
done
let disco_total=sumatoria/1024/1024

sw=0
sumatorio1=0
for valor in $(cat espacio_disco_lista | tr -s ' ' | cut -d ' ' -f3)
do
	if [ $sw -eq 0 ]
	then
		sw=1
	else	
		let sumatoria1=sumatoria1+$valor
	fi
done
disco_usado=$(expr $sumatoria1 \* 100 / $sumatoria)
disco_libre=$(expr 100 - $disco_usado)

rm espacio_disco_lista

#CPU
cantidad_cpu=$(nproc)
cpu_usado=$(top -n 1 | grep %Cpu | tr -s ' ' | cut -d ' ' -f2)
cpu_libre=$(top -n 1 | grep %Cpu | tr -s ' ' | cut -d ' ' -f8)

#INFORMACION SISTEMA
sistema=$(uname -n)
dominio=""
version=$(lsb_release -d | tr -s '\t' ":" | cut -d ':' -f2)
nucleo=$(uname -r)
arquitectura=$(uname -m)
glibc=$(gcc --version | grep gcc)

#USUARIOS
usuarios=$(cat /etc/passwd | wc -l)

#PROCESOS
numero_procesos=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f2)
procesos_ejecutando=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f4)
procesos_durmiendo=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f7)
procesos_parados=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f10)
procesos_zombie=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f13)

#RED
red_ip=$(ifconfig | tr ':' ' ' | grep 'inet\>' | sed -n 1p | tr -s ' ' | cut -d ' ' -f4)
red_mascara=$(ifconfig | tr ':' ' ' | grep 'inet\>' | sed -n 1p | tr -s ' ' | cut -d ' ' -f8)
red_enlace=$(ip route show | grep default | tr -s ' ' | cut -d ' ' -f3)
red_dns=$(cat /etc/resolv.conf | grep nameserver | tr -s ' ' | sed -n 1p | cut -d ' ' -f2)
red_bytes_tx=$(ifconfig | tr ':' ' ' | grep TX | sed -n 1p | tr -s ' ' | cut -d ' ' -f4)
red_bytes_rx=$(ifconfig | tr ':' ' ' | grep RX | sed -n 1p | tr -s ' ' | cut -d ' ' -f4)


echo "--------------------------------------------------------"
echo -e "MEMORIA\t\t\t| INFORMACION SISTEMA"
echo -e "Total:\t\t$ram_total\t| Sistema:\t$sistema"
echo -e "Usado:\t\t$ram_usado_porcentaje %\t| Dominio:\t$dominio"
echo -e "Libre:\t\t$ram_libre_porcentaje %\t| Versión:\t$version"
echo -e "\t\t\t| Núcleo:\t$nucleo"
echo -e "ESPACIO EN DISCO RAIZ\t| Arquitectura:\t$arquitectura"
echo -e "Total:\t\t$disco_total GB\t| GLibC:\t$glibc"
echo -e "Usado:\t\t$disco_usado %\t|\t"
echo -e "Libre:\t\t$disco_libre %\t| USUARIOS"
echo -e "\t\t\t| Usuarios:\t$usuarios"
echo -e "CPU\t\t\t|"
echo -e "Cantidad:\t$cantidad_cpu\t| PROCESOS"
echo -e "Usado:\t\t$cpu_usado %\t| Total:\t$numero_procesos"
echo -e "Inactivo:\t$cpu_libre %\t| Ejecutando:\t$procesos_ejecutando"
echo -e "\t\t\t| Durmiendo:\t$procesos_durmiendo"
echo -e "\t\t\t| Parados:\t$procesos_parados"
echo -e "\t\t\t| Zombies:\t$procesos_zombie"
echo -e "RED"
echo -e "IP:\t\t$red_ip"
echo -e "Mascara:\t$red_mascara"
echo -e "Enlace:\t\t$red_enlace"
echo -e "DNS:\t\t$red_dns"
echo -e "Bytes TX:\t$red_bytes_tx"
echo -e "Bytes RX:\t$red_bytes_rx"
echo ""
echo -e "Conectividad:\t$conectividad"
