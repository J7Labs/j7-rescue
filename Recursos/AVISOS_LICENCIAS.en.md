# License notices

**J7 Rescue** is free and is offered **without any warranty**. Made by Jesús with Claude (J7 Labs). Its original code is under the **MIT license** (text in `Licencias/J7-Rescue_MIT.txt`): you can use it, copy it and change it for free, keeping the authorship notice.
It uses free software by other people. Here is what it is, whose it is and under what license.
The full texts are in the *Licencias* folder (“Open licenses folder” button).

## Thanks to…

- **Senne (3SENN)** — creator of the fix (the patch that makes all this possible). https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — their guide explained the problem and gave the error code (06A6.0064) that led us to Senne's fix. https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **The libimobiledevice team** — Nikias Bassen, Martin Szulecki, Joshua Hill and everyone who has contributed to idevicerestore, libirecovery, libimobiledevice, libusbmuxd, libplist, libtatsu and libimobiledevice-glue. https://libimobiledevice.org

## Programs and libraries it contains

- **idevicerestore** (Nikias Bassen, Martin Szulecki, Joshua Hill and contributors) — LGPL 2.1 or later (the repository includes the text of the LGPL 3.0). **Modified version**: commit `60192e9` with Senne's patch (`0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch`, public domain CC0). https://github.com/libimobiledevice/idevicerestore
- **libtatsu** (libimobiledevice) — LGPL 2.1, commit `b8d518a`, included inside idevicerestore. https://github.com/libimobiledevice/libtatsu
- **irecovery / libirecovery** — LGPL 2.1. https://github.com/libimobiledevice/libirecovery
- **libimobiledevice** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice
- **libusbmuxd** — LGPL 2.1. https://github.com/libimobiledevice/libusbmuxd
- **libimobiledevice-glue** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice-glue
- **libplist** — LGPL 2.1. https://github.com/libimobiledevice/libplist
- **libzip** — 3-clause BSD license. https://libzip.org
- **xz / liblzma** — public domain / 0BSD. https://tukaani.org/xz/
- **zstd** — BSD license. https://facebook.github.io/zstd/
- **OpenSSL** — Apache 2.0. https://openssl.org
- **Senne's (3SENN) fix** — CC0 (public domain): https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

## Your rights with the LGPL libraries

The libraries come **as separate files** inside the app (`J7 Rescue.app/Contents/Frameworks` and `Contents/Helpers`), not glued into the app's own program, so you can replace them with versions of your own.
The **source code** of what was modified (idevicerestore with the patch, libtatsu) and that of the app itself, together with the exact steps to rebuild it, are in the `CODIGO_FUENTE` folder of the `.dmg`. The other libraries have been used **unmodified**, exactly as Homebrew publishes them: their code is at the links above (versions listed in `CODIGO_FUENTE/VERSIONES.txt`).

## Trademarks

“iPhone”, “iOS”, “Finder” and “Apple” are trademarks of Apple Inc. This app is **not made by Apple nor endorsed by Apple**. The iOS is downloaded directly from Apple's servers.
