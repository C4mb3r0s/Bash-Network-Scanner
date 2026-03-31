# 🔍 bash-network-scanner

Script interactivo en Bash para el escaneo de puertos y descubrimiento de hosts en una red local. Cuenta con un menu navegable desde la terminal, salida con colores y tres modos de operacion, todo sin dependencias externas.

---

## ✨ Caracteristicas

- 🎛️ Menu interactivo navegable con flechas `↑↓` o teclas `j/k`
- ⚡ Escaneo en paralelo mediante hilos (`&` + `wait`) para maxima velocidad
- 🎨 Salida con colores para identificar resultados de forma rapida
- 🔎 Tres modos: puertos abiertos, puertos con servicio y hosts activos en la red
- ✅ Validacion de entrada para el rango de red
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

Al ejecutarlo, se desplegara un menu interactivo en la terminal:

```
╔══════════════════════════════════════╗
║         Port Scanner & Net Tool      ║
╚══════════════════════════════════════╝
  Usa ↑↓ o j/k para navegar, Enter para seleccionar

  > Escanear puertos abiertos (sin servicio)
    Escanear puertos abiertos con servicio
    Detectar hosts activos en la red local
    Salir
```

| Tecla | Accion |
|-------|--------|
| `↑` / `k` | Mover seleccion hacia arriba |
| `↓` / `j` | Mover seleccion hacia abajo |
| `Enter` | Confirmar seleccion |
| `q` / `Q` | Salir del programa |
| `Ctrl+C` | Interrupcion de emergencia |

> 💡 El cursor se oculta automaticamente durante el escaneo y se restaura al finalizar o al interrumpir con `Ctrl+C`.

---

## 🛠️ Modos de operacion

### Modo 1 — Escaneo de puertos abiertos

Invoca la funcion `openPorts()`. Escanea todos los puertos del `1` al `65535` en `127.0.0.1` e imprime en verde los que se encuentran abiertos.

**Salida esperada:**

```
[+] Puerto 22 -> OPEN
[+] Puerto 80 -> OPEN
[+] Puerto 443 -> OPEN
```

---

### Modo 2 — Escaneo de puertos + servicio

Invoca la funcion `openPortsWithService()`. Realiza el mismo escaneo que el Modo 1, pero adicionalmente resuelve el nombre del servicio asociado a cada puerto mediante `getent services`. Si el servicio no es reconocido, se muestra como `desconocido`.

**Salida esperada:**

```
[+] Puerto 22   -> OPEN (ssh)
[+] Puerto 80   -> OPEN (http)
[+] Puerto 3306 -> OPEN (mysql)
[+] Puerto 9090 -> OPEN (desconocido)
```

---

### Modo 3 — Descubrimiento de hosts en la red

Invoca la funcion `activeHosts()`. Solicita al usuario que ingrese el prefijo de red (ej: `192.168.1`). Si se presiona `Enter` sin ingresar nada, se usa `192.168.1` como valor por defecto. Valida que el formato sea correcto (3 octetos numericos validos) antes de proceder.

Escanea los hosts `.1` al `.254` del rango indicado usando `ping` con un timeout de 1 segundo por host.

**Salida esperada:**

```
[*] Escaneando 192.168.1.1 - 192.168.1.254 ...

[+] Host 192.168.1.1   esta ACTIVO
[+] Host 192.168.1.105 esta ACTIVO
```

---

## 📋 Notas tecnicas

- El uso de `&` en cada iteracion lanza los intentos de conexion en paralelo, y `wait` espera a que todos los procesos hijos finalicen antes de continuar. Esto reduce el tiempo de escaneo de horas a minutos.
- Los modos 1 y 2 escanean unicamente `127.0.0.1` (localhost). Para escanear otro host, modifica la IP directamente en la funcion correspondiente dentro del script.
- El modo 3 asume una subred `/24`. Para rangos distintos, ajusta el script segun sea necesario.
- `tput civis` / `tput cnorm` se utilizan para ocultar y restaurar el cursor durante el escaneo, mejorando la experiencia visual en la terminal.

---

## ⚠️ Aviso legal

Este script es de uso **educativo y de diagnostico personal**. Asegurate de contar con autorizacion explicita antes de escanear cualquier red o sistema que no sea de tu propiedad. El escaneo no autorizado de redes puede ser considerado ilegal en muchas jurisdicciones.

---

## 👤 Autor

<div align="center">

**Eduardo Camberos**

[![GitHub](https://img.shields.io/badge/GitHub-C4mb3r0s-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/C4mb3r0s)

</div>
