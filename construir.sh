#!/bin/bash
# Construye «J7 Rescue.app» (+ .dmg) en app/dist/. Solo para quien quiera reconstruirla.
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"; cd "$AQUI"
RAIZ="$(cd .. && pwd)"
IDR="$RAIZ/idevicerestore/install/bin/idevicerestore"
IREC="/opt/homebrew/bin/irecovery"
APP="$AQUI/dist/J7 Rescue.app"
C="$APP/Contents"

echo "→ Compilando la app…"
( cd Fuente && swift build -c release 2>&1 | tail -3 )

echo "→ Montando la carpeta de la app…"
rm -rf "$APP"; mkdir -p "$C/MacOS" "$C/Resources" "$C/Helpers" "$C/Frameworks"
cp Fuente/.build/release/J7Rescue "$C/MacOS/J7Rescue"
cp Recursos/Info.plist "$C/Info.plist"
cp Recursos/TUTORIAL.*.md Recursos/AVISOS_LICENCIAS.*.md Recursos/j7labs.png Recursos/simulador_idevicerestore.sh "$C/Resources/"
for d in Recursos/Idiomas/*.lproj; do cp -R "$d" "$C/Resources/"; done
cp -R Recursos/Licencias "$C/Resources/Licencias"

# Icono
ICS="$(mktemp -d)/AppIcon.iconset"; mkdir -p "$ICS"
for t in 16 32 128 256 512; do
  sips -z $t $t Recursos/icono_1024.png --out "$ICS/icon_${t}x${t}.png" >/dev/null
  sips -z $((t*2)) $((t*2)) Recursos/icono_1024.png --out "$ICS/icon_${t}x${t}@2x.png" >/dev/null
done
iconutil -c icns "$ICS" -o "$C/Resources/AppIcon.icns"

echo "→ Metiendo idevicerestore, irecovery y sus librerías…"
cp "$IDR" "$C/Helpers/idevicerestore"; cp "$IREC" "$C/Helpers/irecovery"
chmod u+w "$C/Helpers/"*
recoger() {  # copia las librerías de Homebrew que necesita $1 (y las de ellas), recursivamente
  otool -L "$1" | tail -n +2 | awk '{print $1}' | { grep -E "^/opt/homebrew" || true; } | while read -r dep; do
    b="$(basename "$dep")"
    if [ ! -f "$C/Frameworks/$b" ]; then
      cp "$(realpath "$dep")" "$C/Frameworks/$b"; chmod u+w "$C/Frameworks/$b"
      recoger "$C/Frameworks/$b"
    fi
  done
}
for h in "$C/Helpers/"*; do recoger "$h"; done
reescribir() {  # $1 = fichero, $2 = prefijo nuevo
  otool -L "$1" | tail -n +2 | awk '{print $1}' | { grep -E "^/opt/homebrew" || true; } | while read -r dep; do
    install_name_tool -change "$dep" "$2/$(basename "$dep")" "$1"
  done
}
for h in "$C/Helpers/"*; do reescribir "$h" "@executable_path/../Frameworks"; done
for f in "$C/Frameworks/"*.dylib; do
  install_name_tool -id "@loader_path/$(basename "$f")" "$f"; reescribir "$f" "@loader_path"
done
# Comprobación: nada debe apuntar ya a /opt/homebrew
if otool -L "$C/Helpers/"* "$C/Frameworks/"*.dylib | grep -q '/opt/homebrew'; then echo "✘ Quedan rutas de Homebrew"; exit 1; fi

echo "→ Firmando (firma local, sin cuenta de pago)…"
for f in "$C/Frameworks/"*.dylib "$C/Helpers/"*; do codesign --force --sign - "$f" >/dev/null; done
codesign --force --sign - "$APP" >/dev/null
codesign --verify --deep --strict "$APP" && echo "✔ Firma local correcta"

echo "→ Empaquetando el código fuente de la app…"
tar czf CODIGO_FUENTE/J7-Rescue-app-fuente.tar.gz --exclude .build -C "$AQUI" Fuente Recursos herramientas construir.sh LICENSE

echo "→ Creando el .dmg…"
DMG="$AQUI/dist/J7-Rescue.dmg"; ST="$(mktemp -d)/J7 Rescue"; mkdir -p "$ST"
cp -R "$APP" "$ST/"; ln -s /Applications "$ST/Applications"
cp -R CODIGO_FUENTE "$ST/CODIGO_FUENTE"; cp -R Recursos/Licencias "$ST/Licencias"; cp Recursos/LEEME_DESCARGA.*.md "$ST/"; cp LICENSE "$ST/LICENSE.txt"
rm -f "$DMG"; hdiutil create -quiet -volname "J7 Rescue" -srcfolder "$ST" -format UDZO "$DMG"
du -sh "$APP" "$DMG"
