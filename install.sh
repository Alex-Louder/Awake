#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR/build.sh"

echo "==> Instalando en /Applications..."
# Terminar proceso si está corriendo
killall ClamAwake 2>/dev/null || true

rm -rf "/Applications/ClamAwake.app"
cp -R "$DIR/ClamAwake.app" "/Applications/ClamAwake.app"

echo "==> Abriendo ClamAwake..."
open "/Applications/ClamAwake.app"

echo "==> ¡Instalación completa! ClamAwake está activa en tu barra de menú."
