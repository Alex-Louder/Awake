#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR/build.sh"

echo "==> Verificando permisos NOPASSWD para pmset..."
if [ ! -f "/etc/sudoers.d/awake" ]; then
    osascript -e 'do shell script "echo \"playlouder ALL=(ALL) NOPASSWD: /usr/bin/pmset -a disablesleep *\" > /etc/sudoers.d/awake && chmod 0440 /etc/sudoers.d/awake" with administrator privileges'
fi

echo "==> Instalando en /Applications..."
killall Awake 2>/dev/null || true

rm -rf "/Applications/Awake!.app"
cp -R "$DIR/Awake!.app" "/Applications/Awake!.app"

echo "==> Abriendo Awake!..."
open "/Applications/Awake!.app"

echo "==> ¡Instalación completa! Awake! está activa en tu barra de menú sin pedir contraseñas."
