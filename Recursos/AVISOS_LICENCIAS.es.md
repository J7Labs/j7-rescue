# Avisos de licencias

**J7 Rescue** es gratuita y se ofrece **sin ninguna garantía**. Hecha por Jesús con Claude (J7 Labs). Su código original tiene **licencia MIT** (texto en `Licencias/J7-Rescue_MIT.txt`): puedes usarlo, copiarlo y cambiarlo gratis, manteniendo el aviso de autoría.
Usa software libre de otras personas. Aquí está qué es, de quién y con qué licencia.
Los textos completos están en la carpeta *Licencias* (botón «Abrir carpeta de licencias»).

## Gracias a…

- **Senne (3SENN)** — creador del arreglo (el parche que hace posible todo esto). https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — su guía explicó el problema y dio el código de error (06A6.0064) que nos llevó hasta el arreglo de Senne. https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **El equipo de libimobiledevice** — Nikias Bassen, Martin Szulecki, Joshua Hill y todas las personas que han contribuido a idevicerestore, libirecovery, libimobiledevice, libusbmuxd, libplist, libtatsu y libimobiledevice-glue. https://libimobiledevice.org

## Programas y librerías que lleva dentro

- **idevicerestore** (Nikias Bassen, Martin Szulecki, Joshua Hill y colaboradores) — LGPL 2.1 o posterior (el repositorio incluye el texto de la LGPL 3.0). **Versión modificada**: commit `60192e9` con el parche de Senne (`0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch`, dominio público CC0). https://github.com/libimobiledevice/idevicerestore
- **libtatsu** (libimobiledevice) — LGPL 2.1, commit `b8d518a`, incluida dentro de idevicerestore. https://github.com/libimobiledevice/libtatsu
- **irecovery / libirecovery** — LGPL 2.1. https://github.com/libimobiledevice/libirecovery
- **libimobiledevice** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice
- **libusbmuxd** — LGPL 2.1. https://github.com/libimobiledevice/libusbmuxd
- **libimobiledevice-glue** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice-glue
- **libplist** — LGPL 2.1. https://github.com/libimobiledevice/libplist
- **libzip** — licencia BSD de 3 cláusulas. https://libzip.org
- **xz / liblzma** — dominio público / 0BSD. https://tukaani.org/xz/
- **zstd** — licencia BSD. https://facebook.github.io/zstd/
- **OpenSSL** — Apache 2.0. https://openssl.org
- **El arreglo de Senne (3SENN)** — CC0 (dominio público): https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

## Tus derechos con las librerías LGPL

Las librerías van **como archivos aparte** dentro de la app (`J7 Rescue.app/Contents/Frameworks` y `Contents/Helpers`), no pegadas dentro del programa de la app, por lo que puedes sustituirlas por versiones tuyas.
El **código fuente** de lo modificado (idevicerestore con el parche, libtatsu) y el de la propia app, junto con los pasos exactos para reconstruirlo, van en la carpeta `CODIGO_FUENTE` del `.dmg`. Las demás librerías se han usado **sin modificar**, tal cual las publica Homebrew: su código está en los enlaces de arriba (versiones indicadas en `CODIGO_FUENTE/VERSIONES.txt`).

## Marcas

«iPhone», «iOS», «Finder» y «Apple» son marcas de Apple Inc. Esta app **no es de Apple ni está avalada por Apple**. El iOS se descarga directamente de los servidores de Apple.
