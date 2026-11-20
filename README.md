# J7 Rescue

App de Mac (SwiftUI, macOS 26) que recupera un iPhone atascado tras el
«error desconocido (100) 06A6.0064» al actualizar con Finder con el almacenamiento casi lleno,
**sin borrar sus datos**. Gratis, licencia MIT. Hecha por Jesús con Claude · J7 Labs.

Descarga: pestaña **Releases** → `J7-Rescue.dmg`. Instrucciones para abrirla: `LEEME_DESCARGA.md`.

## Gracias a
- **Senne (3SENN)** — creador del arreglo: https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — su guía explicó el problema y dio el código de error que nos llevó al arreglo: https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **libimobiledevice** (Nikias Bassen, Martin Szulecki, Joshua Hill y colaboradores): https://libimobiledevice.org

## Reconstruirla
Necesitas Xcode y Homebrew (con libimobiledevice, libirecovery, libzip) y haber montado idevicerestore parcheado
(ver `CODIGO_FUENTE/reproducir_binarios.sh` en el .dmg). Luego: `./construir.sh`.

Licencia de este código: MIT (`LICENSE`). Las piezas de terceros conservan las suyas: `Recursos/AVISOS_LICENCIAS.md`.
