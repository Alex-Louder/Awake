#!/bin/bash
set -e

TARGET="${1:-v1.0.0}"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

echo "==> Cambiando a la versión $TARGET..."
killall ClamAwake 2>/dev/null || true
git checkout "$TARGET"
./install.sh
echo "==> ¡Listo! ClamAwake $TARGET está instalada y activa en la barra de menú."
