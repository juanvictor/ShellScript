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
	disco_total=$(df -h / | grep /dev | tr -s ' ' ';' | cut -d ';' -f2)
	disco_usado=$(df -h / | grep /dev | tr -s ' ' ';' | cut -d ';' -f5)
	disco_usado_sin_porcentaje=$(df -h / | grep /dev | tr -s ' ' ';' | cut -d ';' -f5 | cut -d '%' -f1)
	disco_libre=$(expr 100 - $disco_usado_sin_porcentaje)

#CPU
	cantidad_cpu=$(nproc)
	cpu_usado=$(top -n 1 | grep %Cpu | tr -s ' ' | cut -d ' ' -f2)
	cpu_libre=$(top -n 1 | grep %Cpu | tr -s ' ' | cut -d ' ' -f8)

#INFORMACION SISTEMA
	sistema=$(hostname -s)
	dominio=$(hostname -d)
	version=$(cat /etc/issue | cut -d ' ' -f 1-3)
	nucleo=$(uname -r)
	arquitectura=$(uname -m)

#USUARIOS
	usuarios=$(cat /etc/passwd | wc -l)
	usuarios_activo=$(uptime | tr -s ' ' | cut -d ' ' -f5)

#PROCESOS
	numero_procesos=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f2)
	procesos_ejecutando=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f4)
	procesos_durmiendo=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f6)
	procesos_parados=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f8)
	procesos_zombie=$(top -n 1 | grep Ta | tr -s ' ' | cut -d ' ' -f10)

#RED
	red_ip=$(ip route show | grep kernel | cut -d ' ' -f9)
	red_mascara=$(ip route show | grep kernel | cut -d '/' -f2 | cut -d ' ' -f1)
	red_enlace=$(ip route show | grep default | tr -s ' ' | cut -d ' ' -f3)
	red_dns=$(cat /etc/resolv.conf | grep nameserver | tr -s ' ' | sed -n 1p | cut -d ' ' -f2)	
	# red_bytes_tx=$(ifconfig | tr ':' ' ' | grep TX | sed -n 1p | tr -s ' ' | cut -d ' ' -f4)
	# red_bytes_rx=$(ifconfig | tr ':' ' ' | grep RX | sed -n 1p | tr -s ' ' | cut -d ' ' -f4)

echo "--------------------------------------------------------"
echo "MEMORIA\t\t\t| INFORMACION DEL SISTEMA"
echo "Total:\t\t$ram_total\t| Sistema:\t$sistema"
echo "Usado:\t\t$ram_usado_porcentaje %\t| Dominio:\t$dominio"
echo "Libre:\t\t$ram_libre_porcentaje %\t| Versión:\t$version"
echo "\t\t\t| Núcleo:\t$nucleo"
echo "ESPACIO EN DISCO RAIZ\t| Arquitectura:\t$Arquitectura"
echo "Total:\t\t$disco_total\t|"
echo "Usado:\t\t$disco_usado\t| USUARIOS"
echo "Libre:\t\t$disco_libre%\t| Numero de usuarios:\t$usuarios"
echo "\t\t\t| Usuarios activos:\t$usuarios_activo"
echo "CPU\t\t\t| "
echo "Cantidad:\t$cantidad_cpu\t| PROCESOS"
echo "Usado:\t\t$cpu_usado %\t| Total:\t$numero_procesos"
echo "Inactivo:\t$cpu_libre %\t| Ejecutando:\t$procesos_ejecutando"
echo "\t\t\t| Durmiendo:\t$procesos_durmiendo"
echo "\t\t\t| Parados:\t$procesos_parados"
echo "\t\t\t| Zombies:\t$procesos_zombie"
echo "RED"
echo "IP:\t\t$red_ip"
echo "Mascara:\t$red_mascara"
echo "Enlace:\t\t$red_enlace"
echo "DNS:\t\t$red_dns"
# echo "Bytes TX:\t$red_bytes_tx"
# echo "Bytes RX:\t$red_bytes_rx"
echo ""
echo "Conectividad:\t$conectividad"
