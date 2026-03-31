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

# ──────────────────────────────────────────────
# Ctrl+C handler
# ──────────────────────────────────────────────
function ctrl_c() {
  echo -e "\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm
  exit 1
}

trap ctrl_c INT
tput civis

# ──────────────────────────────────────────────
# Función 1: Solo puertos abiertos
# ──────────────────────────────────────────────
function openPorts() {
  tput civis
  echo -e "\n${blueColour}[*] Escaneando puertos abiertos en 127.0.0.1 ...${endColour}\n"
  for port in $(seq 1 65535); do
    (echo '' >/dev/tcp/127.0.0.1/$port) 2>/dev/null &&
      echo -e "${greenColour}[+]${endColour} Puerto ${yellowColour}${port}${endColour} -> ${greenColour}OPEN${endColour}" &
  done
  wait
  echo -e "\n${grayColour}[*] Escaneo completado.${endColour}\n"
  tput cnorm
}

# ──────────────────────────────────────────────
# Función 2: Puertos abiertos + servicio
# ──────────────────────────────────────────────
function openPortsWithService() {
  tput civis
  echo -e "\n${blueColour}[*] Escaneando puertos abiertos con servicios en 127.0.0.1 ...${endColour}\n"
  for port in $(seq 1 65535); do
    (echo '' >/dev/tcp/127.0.0.1/$port) 2>/dev/null && {
      service=$(getent services $port/tcp 2>/dev/null | awk '{print $1}')
      [[ -z "$service" ]] && service="desconocido"
      echo -e "${greenColour}[+]${endColour} Puerto ${yellowColour}${port}${endColour} -> ${greenColour}OPEN${endColour} (${purpleColour}${service}${endColour})"
    } &
  done
  wait
  echo -e "\n${grayColour}[*] Escaneo completado.${endColour}\n"
  tput cnorm
}

# ──────────────────────────────────────────────
# Función 3: Hosts activos en la red local
# ──────────────────────────────────────────────
function activeHosts() {
  tput cnorm
  echo -e "\n${blueColour}[*] Detectando hosts activos en la red local${endColour}"
  echo -e "${grayColour}  Si presionas Enter se usará el rango por defecto: ${yellowColour}192.168.1${endColour}\n"

  local network
  while true; do
    read -r -p "$(echo -e "  ${turquoiseColour}Ingresa el rango de red ${grayColour}(ej: 192.168.1)${turquoiseColour}: ${endColour}")" network
    [[ -z "$network" ]] && network="192.168.1"

    if [[ "$network" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
      local o1="${BASH_REMATCH[1]}" o2="${BASH_REMATCH[2]}" o3="${BASH_REMATCH[3]}"
      if ((o1 <= 255 && o2 <= 255 && o3 <= 255)); then
        break
      fi
    fi

    echo -e "  ${redColour}[!] Formato inválido. Ingresa 3 octetos válidos (ej: 192.168.1)${endColour}"
  done

  tput civis
  echo -e "\n${blueColour}[*] Escaneando ${turquoiseColour}${network}.1${blueColour} - ${turquoiseColour}${network}.254${endColour} ...\n"

  for i in $(seq 1 254); do
    timeout 1 bash -c "ping -c 1 ${network}.${i}" &>/dev/null &&
      echo -e "${greenColour}[+]${endColour} Host ${turquoiseColour}${network}.${i}${endColour} está ${greenColour}ACTIVO${endColour}" &
  done
  wait
  echo -e "\n${grayColour}[*] Escaneo de red completado.${endColour}\n"
  tput cnorm
}

# ──────────────────────────────────────────────
# Menú interactivo
# ──────────────────────────────────────────────
declare -a MENU_OPTIONS=(
  "Escanear puertos abiertos (sin servicio)"
  "Escanear puertos abiertos con servicio"
  "Detectar hosts activos en la red local"
  "Salir"
)

function printMenu() {
  local selected=$1

  clear

  echo -e "${blueColour}╔══════════════════════════════════════╗${endColour}"
  echo -e "${blueColour}║         Port Scanner & Net Tool      ║${endColour}"
  echo -e "${blueColour}╚══════════════════════════════════════╝${endColour}"
  echo -e "${grayColour}  Usa ↑↓ o j/k para navegar, Enter para seleccionar${endColour}\n"

  for i in "${!MENU_OPTIONS[@]}"; do
    if [[ $i -eq $selected ]]; then
      echo -e "  ${greenColour}> ${MENU_OPTIONS[$i]}${endColour}"
    else
      echo -e "  ${grayColour}  ${MENU_OPTIONS[$i]}${endColour}"
    fi
  done
  echo ""
}

function main() {
  local selected=0
  local total=${#MENU_OPTIONS[@]}

  while true; do
    tput civis
    printMenu $selected

    # Leer tecla
    IFS= read -r -s -n1 key

    # Detectar secuencia de escape (flechas)
    if [[ $key == $'\x1b' ]]; then
      IFS= read -r -s -n2 -t 0.1 seq
      key="${key}${seq}"
    fi

    case "$key" in
    $'\x1b[A' | k) # Flecha arriba o k
      ((selected--))
      [[ $selected -lt 0 ]] && selected=$((total - 1))
      ;;
    $'\x1b[B' | j) # Flecha abajo o j
      ((selected++))
      [[ $selected -ge $total ]] && selected=0
      ;;
    '') # Enter
      tput cnorm
      case $selected in
      0) openPorts ;;
      1) openPortsWithService ;;
      2) activeHosts ;;
      3)
        echo -e "\n${redColour}[!] Saliendo...${endColour}\n"
        tput cnorm
        exit 0
        ;;
      esac
      echo -e "${yellowColour}Presiona Enter para volver al menú...${endColour}"
      read -r -s
      tput civis
      ;;
    q | Q)
      echo -e "\n${redColour}[!] Saliendo...${endColour}\n"
      tput cnorm
      exit 0
      ;;
    esac
  done
}

main
