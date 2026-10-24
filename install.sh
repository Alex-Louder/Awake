#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR/build.sh"

echo "==> Instalando en /Applications..."
killall ClamAwake 2>/dev/null || true
killall Awake 2>/dev/null || true

rm -rf "/Applications/ClamAwake.app"
rm -rf "/Applications/Awake!.app"
cp -R "$DIR/Awake!.app" "/Applications/Awake!.app"

echo "==> Abriendo Awake!..."
open "/Applications/Awake!.app"

echo "==> ¡Instalación completa! Awake! está activa en tu barra de menú."
