# 🔍 bash-network-scanner

Script en Bash para el escaneo de puertos y descubrimiento de hosts en una red local. Utiliza `/dev/tcp` y `ping` de forma completamente nativa, sin dependencias externas como `nmap`.

---

## ✨ Caracteristicas

- ⚡ Escaneo en paralelo mediante hilos (`&` + `wait`) para maxima velocidad
- 🔎 Tres modos de operacion: puertos, puertos con servicio y hosts activos
- 🚫 Sin dependencias externas — solo Bash nativo
- 🖥️ Compatible con sistemas Linux

---

## ⚙️ Requisitos

- Bash 4+
- Sistema operativo Linux
- Permisos de ejecucion sobre el script

---

## 🚀 Uso

```bash
chmod +x portScan.sh
./portScan.sh
```

> 💡 El script oculta el cursor durante la ejecucion y lo restaura automaticamente al finalizar. Puedes interrumpirlo en cualquier momento con `Ctrl+C`.

---

## 🛠️ Modos de operacion

El script cuenta con **3 modos de operacion**. Solo uno debe estar activo (descomentado) a la vez; los otros dos deben permanecer comentados.

---

### Modo 1 — Escaneo de puertos abiertos

Escanea todos los puertos del `1` al `65535` en `127.0.0.1` e imprime los que se encuentran abiertos.

```bash
for port in $(seq 1 65535); do
  (echo '' >/dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[+] $port -> OPEN" &
done
wait
```

**Para activar:** descomenta este bloque y comenta los otros dos.

---

### Modo 2 — Escaneo de puertos + servicio *(activo por defecto)*

Escanea todos los puertos del `1` al `65535` en `127.0.0.1` e imprime los que estan abiertos junto con el nombre del servicio asociado a cada uno.

```bash
for port in $(seq 1 65535); do
  (echo '' >/dev/tcp/127.0.0.1/$port) 2>/dev/null &&
    service=$(getent services $port | awk '{print $1}') &&
    echo "[+] $port -> OPEN ($service)" &
done
wait
```

**Para activar:** este modo ya esta activo por defecto. Comenta los otros dos si los activaste previamente.

---

### Modo 3 — Descubrimiento de hosts en la red

Escanea los 255 posibles hosts de la subred `192.168.1.0/24` mediante `ping` e imprime cuales se encuentran activos.

```bash
for i in $(seq 1 255); do
  timeout 1 bash -c "ping -c 1 192.168.1.$i" &>/dev/null && echo "[+] Host 192.168.1.$i is UP" &
done
wait
```

**Para activar:** descomenta este bloque y comenta los otros dos.  
> ⚠️ Recuerda cambiar el prefijo `192.168.1` por el de tu red local si es diferente.

---

## 📋 Notas

- El uso de hilos (`&` + `wait`) permite ejecutar multiples conexiones de forma concurrente, reduciendo drasticamente el tiempo total de escaneo.
- El escaneo se realiza unicamente sobre `127.0.0.1` (localhost) en los modos 1 y 2. Modifica la IP segun el objetivo deseado.
- El descubrimiento de hosts (Modo 3) asume una subred `/24`. Ajusta el rango si tu red es diferente.

---

## ⚠️ Aviso legal

Este script es de uso educativo. Asegurate de tener autorizacion explicita antes de escanear cualquier red o sistema que no sea de tu propiedad. El uso no autorizado puede ser ilegal.

---

## 👤 Autor

**Eduardo Camberos**  
GitHub: [C4mb3ros](https://github.com/C4mb3ros)
