<div align="center">

# 🔍 portScan

<img src="https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white"/>
<img src="https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black"/>

**Script interactivo en Bash para el escaneo de puertos y descubrimiento de hosts en una red local. Menú navegable desde la terminal, salida con colores y tres modos de operación — sin dependencias externas.**

</div>

---

### 📸 Preview

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

---

## ✨ Características

- 🎛️ Menú interactivo navegable con flechas `↑↓` o teclas `j/k`
- ⚡ Escaneo en paralelo mediante hilos (`&` + `wait`) para máxima velocidad
- 🎨 Salida con colores para identificar resultados de forma rápida
- 🔎 Tres modos: puertos abiertos, puertos con servicio y hosts activos en la red
- ✅ Validación de entrada para el rango de red
- 🚫 Sin dependencias externas — solo Bash nativo
- 🖥️ Compatible con sistemas Linux

---

## ⚙️ Requisitos

| Herramienta | Descripción |
|-------------|-------------|
| `bash` 4+ | Intérprete de shell |
| `ping` | Descubrimiento de hosts (modo 3) |
| `getent` | Resolución de nombres de servicios (modo 2) |

> El script no requiere ningún paquete externo.

---

## 🚀 Uso

```bash
git clone https://github.com/C4mb3r0s/portScan.git
cd portScan
chmod +x portScan.sh
./portScan.sh
```

### Controles del menú

| Tecla | Acción |
|-------|--------|
| `↑` / `k` | Mover selección hacia arriba |
| `↓` / `j` | Mover selección hacia abajo |
| `Enter` | Confirmar selección |
| `q` / `Q` | Salir del programa |
| `Ctrl+C` | Interrupción de emergencia |

> 💡 El cursor se oculta automáticamente durante el escaneo y se restaura al finalizar o al interrumpir con `Ctrl+C`.

---

## 🛠️ Modos de operación

### Modo 1 — Escaneo de puertos abiertos

Escanea todos los puertos del `1` al `65535` en `127.0.0.1` e imprime en verde los que se encuentran abiertos.

**Salida esperada:**

```
[+] Puerto 22  -> OPEN
[+] Puerto 80  -> OPEN
[+] Puerto 443 -> OPEN
```

---

### Modo 2 — Escaneo de puertos + servicio

Realiza el mismo escaneo que el Modo 1, pero además resuelve el nombre del servicio asociado a cada puerto mediante `getent services`. Si el servicio no es reconocido, se muestra como `desconocido`.

**Salida esperada:**

```
[+] Puerto 22   -> OPEN (ssh)
[+] Puerto 80   -> OPEN (http)
[+] Puerto 3306 -> OPEN (mysql)
[+] Puerto 9090 -> OPEN (desconocido)
```

---

### Modo 3 — Descubrimiento de hosts en la red

Solicita el prefijo de red (ej: `192.168.1`). Si se presiona `Enter` sin ingresar nada, usa `192.168.1` como valor por defecto. Valida el formato antes de proceder y escanea los hosts `.1` al `.254` con `ping` y un timeout de 1 segundo.

**Salida esperada:**

```
[*] Escaneando 192.168.1.1 - 192.168.1.254 ...

[+] Host 192.168.1.1   esta ACTIVO
[+] Host 192.168.1.105 esta ACTIVO
```

---

## 📋 Notas técnicas

- El uso de `&` en cada iteración lanza los intentos de conexión en paralelo, y `wait` espera a que todos los procesos hijos finalicen. Esto reduce el tiempo de escaneo de horas a minutos.
- Los modos 1 y 2 escanean únicamente `127.0.0.1` (localhost). Para escanear otro host, modifica la IP directamente en la función correspondiente dentro del script.
- El modo 3 asume una subred `/24`. Para rangos distintos, ajusta el script según sea necesario.
- `tput civis` / `tput cnorm` se utilizan para ocultar y restaurar el cursor durante el escaneo, mejorando la experiencia visual.

---

## 📁 Estructura

```
portScan/
└── portScan.sh   # Script principal
```

---

## ⚠️ Aviso legal

Este script es de uso **educativo y de diagnóstico personal**. Asegúrate de contar con autorización explícita antes de escanear cualquier red o sistema que no sea de tu propiedad. El escaneo no autorizado de redes puede ser considerado ilegal en muchas jurisdicciones.

---

## 👤 Autor

<div align="center">

**Eduardo Camberos**

[![GitHub](https://img.shields.io/badge/GitHub-C4mb3r0s-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/C4mb3r0s)

</div>
