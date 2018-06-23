#!/bin/bash
cat cadenas | tr 'i' '!' | tr 'l' '1' | tr 'o' '0' | tr 'b' '3' | tr 's' '5' | tr 'b' '8' | tr 'a' '@' | tr 't' '7' | tr 'h' '#' > cadena
ARCHIVO=cadena
NUMFILAS=$(cat $ARCHIVO | wc -l)
ALEATORIO1=$((RANDOM%$NUMFILAS))
ALEATORIO2=$((RANDOM%$NUMFILAS))
CONTADOR=0;
for VALOR in $(cat $ARCHIVO)
do
	CADENA[$CONTADOR]=$VALOR
	let CONTADOR=CONTADOR+1
#	echo $VALOR
done

echo "${CADENA[$ALEATORIO1]}${CADENA[$ALEATORIO2]}"
#echo ${CADENA[$ALEATORIO1]}
#echo ${CADENA[$ALEATORIO2]}
# echo $CONTADOR
#echo -e "Numero de filas = $NUMFILAS \r\nNumero aleatorio 1 = $ALEATORIO1 \r\nNumero aleatorio 2 = $ALEATORIO2"
rm cadena
