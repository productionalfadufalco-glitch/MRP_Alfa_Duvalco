#!/usr/bin/env bash
# ALFA VALVES MRP System - launcher (Linux / macOS)
set -e
cd "$(dirname "$0")"

echo "=============================================="
echo "  PT. ALFA VALVES INDONESIA - MRP System"
echo "=============================================="
echo

if ! command -v node >/dev/null 2>&1; then
  echo "[ERROR] Node.js belum terpasang."
  echo "        Install dari https://nodejs.org (versi LTS)"
  exit 1
fi

if [ ! -d node_modules ]; then
  echo "[SETUP] Memasang dependensi untuk pertama kali (1-3 menit)..."
  npm install
  echo "[OK] Dependensi terpasang."
  echo
fi

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP" ] && IP=$(ipconfig getifaddr en0 2>/dev/null || echo "IP-KOMPUTER")

echo "[INFO] Menjalankan server..."
echo
echo "  Komputer ini : http://localhost:3000"
echo "  HP / PC lain : http://$IP:3000"
echo
echo "  Tekan Ctrl+C untuk menghentikan server."
echo "=============================================="
echo

exec node server/index.js
