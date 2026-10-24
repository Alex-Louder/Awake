#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

echo "==> Revertiendo a v1.0.0..."
killall ClamAwake 2>/dev/null || true
git checkout v1.0.0
./install.sh
echo "==> ¡Listo! ClamAwake v1.0.0 está instalada y activa."
