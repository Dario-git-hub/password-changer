#!/bin/bash

# Instalar tailscale para tener acceso desde fuera de la WLAN
curl -fsSL https://tailscale.com/install.sh | sh
echo 'Realiza el login con tailscale. Cuando esté realizado, pulsa [ENTER] aquí'
read

