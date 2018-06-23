#!/bin/bash
declare -a BASE=(hosting servicio madrid marte jupiter mercurio sol luna pluton saturno neptuno venus europa titan servidor correo diablo satan sedna sirio triton juan victor rock video yoyo coco goku andromeda leo)

NUMERO_SIMBOLO=$(< /dev/urandom tr -dc _\$\%\&\.\,\:\;0-9 | head -c${1:-4};echo;)

TAMANIO_BASE=${#BASE[*]}

LLAVE1=$( < /dev/urandom tr -dc 0-9 | head -c${1:-2};echo;)

LLAVE1_1=$(expr substr $LLAVE1 1 1)

if [ $LLAVE1_1 -eq 0 ]; 
then 
	LLAVE1=$(expr substr $LLAVE1 2 2)
fi

while [ $LLAVE1 -ge $TAMANIO_BASE ]
do
	LLAVE1=$( < /dev/urandom tr -dc 0-9 | head -c${1:-2};echo;)
	
	LLAVE1_1=$(expr substr $LLAVE1 1 1)

	if [ $LLAVE1_1 -eq 0 ]; 
	then 
		LLAVE1=$(expr substr $LLAVE1 2 2)
	fi
done

LLAVE2=$( < /dev/urandom tr -dc 0-9 | head -c${1:-2};echo;)

LLAVE2_1=$(expr substr $LLAVE2 1 1)

if [ $LLAVE2_1 -eq 0 ]; 
then 
	LLAVE2=$(expr substr $LLAVE2 2 2)
fi

while [ $LLAVE2 -ge $TAMANIO_BASE ]
do
	LLAVE2=$( < /dev/urandom tr -dc 0-9 | head -c${1:-2};echo;)
	
	LLAVE2_1=$(expr substr $LLAVE2 1 1)

	if [ $LLAVE2_1 -eq 0 ]; 
	then 
		LLAVE2=$(expr substr $LLAVE2 2 2)
	fi
done

echo ${BASE[$LLAVE1]}${BASE[$LLAVE2]}$NUMERO_SIMBOLO