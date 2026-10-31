#!/usr/bin/env bash
# Ajoute les permissions nécessaires à la prise de photo dans le manifeste Android.
# Sûr à relancer : il n'ajoute rien si la permission est déjà là.
set -euo pipefail

MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ ! -f "$MANIFEST" ]; then
  echo "Manifeste introuvable : lance d'abord 'npx cap add android'." >&2
  exit 1
fi

if ! grep -q 'android.permission.CAMERA' "$MANIFEST"; then
  sed -i 's#<uses-permission android:name="android.permission.INTERNET" />#<uses-permission android:name="android.permission.INTERNET" />\n    <uses-permission android:name="android.permission.CAMERA" />#' "$MANIFEST"
  echo "Permission CAMERA ajoutée."
else
  echo "Permission CAMERA déjà présente."
fi
