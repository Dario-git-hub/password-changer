#!/bin/bash

# Variables

# Contraseña hasheada en formato blowfish (la contraseña es root)
hashed_pass='$y$j9T$1Jr2.DqrAYS29mdbCbppu0$y/WnB5uTVhucFzgBm/8aruAqm9fPA2rWrBAapvmjyz5'

# Asumo que el disco es /dev/sda
DISCO=/dev/sda 

# Snippet para comprobar si es root o no, en caso negativo, cierra
if [ "$EUID" -ne 0 ] 
then
    echo "Ejecutalo con root o sudo."
    exit 127
fi

# Chapuza para montar el disco porque me da pereza buscar como se hace con mount
thunar /dev/sda1 & disown &>/dev/null 
thunar /dev/sda2 & disown &>/dev/null 

cd /media/kali
echo 'Escribe partición (/dev/sda):'
ls
read particion_selecionada

cd /media/kali/${particion_selecionada}/etc/

# Copia de seguridad en caso de que algo salga mal
cp shadow /dev/shm/shadow.bak 
cp passwd /dev/shm/passwd.bak

# Vacío /dev/shm/passwd_mod en caso de que ya exista para que no provoque errores
echo '' | tee /dev/shm/passwd_mod

# Uso sed porque tr 'x' '$y$j9T$1Jr2.DqrAYS29mdbCbppu0$y/WnB5uTVhucFzgBm/8aruAqm9fPA2rWrBAapvmjyz5' no va bien, porque tr solo puede reemplazar un único caracter por caracter
cat passwd | grep "root"| sed 's/x/$y$j9T$1Jr2.DqrAYS29mdbCbppu0\$y\/WnB5uTVhucFzgBm\/8aruAqm9fPA2rWrBAapvmjyz5/g' >> /dev/shm/passwd_mod
cat passwd | grep -v "root" >> /dev/shm/passwd_mod

# Cambio el passwd modificado por el original
mv /dev/shm/passwd_mod /media/kali/${particion_selecionada}/etc/passwd

# Cierro todas las instancias de thunar abiertas
killall thunar

