#!/bin/bash

#Colours
readonly greenColour="\e[0;32m\033[1m"
readonly endColour="\033[0m\e[0m"
readonly redColour="\e[0;31m\033[1m"
readonly blueColour="\e[0;34m\033[1m"
readonly yellowColour="\e[0;33m\033[1m"
readonly purpleColour="\e[0;35m\033[1m"
readonly turquoiseColour="\e[0;36m\033[1m"
readonly grayColour="\e[0;37m\033[1m"

function ctrl_c() {
  echo -e "\n\n [!] Saliendo... \n"
  tput cnorm # Mostrar el curso
  exit 1
}

trap ctrl_c INT

tput civis # Ocultar el cursor # Ocultar el cursor

# validadion de puertos abiertos
# for port in $(seq 1 65535); do
#   (echo '' >/dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[+] $port -> OPEN" &
# done
# wait

# Validacion de puertos abierto y el servicio que corre
for port in $(seq 1 65535); do
  (echo '' >/dev/tcp/127.0.0.1/$port) 2>/dev/null &&
    service=$(getent services $port | awk '{print $1}') &&
    echo "[+] $port -> OPEN ($service)" &
done
wait

# Validacion de host activos en una red
# for i in $(seq 1 255); do
#   timeout 1 bash -c "ping -c 1 192.168.1.$i" &>/dev/null && echo "[+] Host 192.168.1.$i is UP" &
# done
# wait # Uso de hilos para que no espere a que termine uno por uno

# tput cnorm # Mostrar el curso
