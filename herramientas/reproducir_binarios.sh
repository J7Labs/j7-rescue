#!/bin/bash
# Reconstruye idevicerestore (con el parche de Senne) y libtatsu desde el código fuente de esta carpeta.
# Necesita Xcode (herramientas de línea de comandos) y Homebrew con: autoconf automake libtool pkgconf libimobiledevice libirecovery libzip
set -e
AQUI="$(cd "$(dirname "$0")" && pwd)"; cd "$AQUI"
mkdir -p build && cd build
tar xzf ../libtatsu-*.tar.gz && tar xzf ../idevicerestore-*.tar.gz
( cd libtatsu && ./autogen.sh --prefix="$PWD/install" --enable-static --disable-shared && make -j8 && make install )
( cd idevicerestore && export PKG_CONFIG_PATH="$PWD/../libtatsu/install/lib/pkgconfig:$(brew --prefix)/lib/pkgconfig" \
  && ./autogen.sh --prefix="$PWD/install" && make -j8 && make install )
echo "Listo: build/idevicerestore/install/bin/idevicerestore"
