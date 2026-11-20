# Licentiemeldingen

**J7 Rescue** is gratis en wordt aangeboden **zonder enige garantie**. Gemaakt door Jesús met Claude (J7 Labs). De oorspronkelijke code heeft een **MIT-licentie** (tekst in `Licencias/J7-Rescue_MIT.txt`): je mag hem gratis gebruiken, kopiëren en aanpassen, als je de vermelding van de maker behoudt.
De app gebruikt vrije software van andere mensen. Hier staat wat het is, van wie en onder welke licentie.
De volledige teksten staan in de map *Licencias* (knop «Licentiemap openen»).

## Dank aan…

- **Senne (3SENN)** — bedenker van de reparatie (de patch die dit allemaal mogelijk maakt). https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — zijn gids legde het probleem uit en gaf de foutcode (06A6.0064) die ons naar de reparatie van Senne bracht. https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **Het libimobiledevice-team** — Nikias Bassen, Martin Szulecki, Joshua Hill en alle mensen die hebben bijgedragen aan idevicerestore, libirecovery, libimobiledevice, libusbmuxd, libplist, libtatsu en libimobiledevice-glue. https://libimobiledevice.org

## Programma's en bibliotheken die erin zitten

- **idevicerestore** (Nikias Bassen, Martin Szulecki, Joshua Hill en medewerkers) — LGPL 2.1 of nieuwer (de repository bevat de tekst van de LGPL 3.0). **Aangepaste versie**: commit `60192e9` met de patch van Senne (`0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch`, publiek domein CC0). https://github.com/libimobiledevice/idevicerestore
- **libtatsu** (libimobiledevice) — LGPL 2.1, commit `b8d518a`, opgenomen in idevicerestore. https://github.com/libimobiledevice/libtatsu
- **irecovery / libirecovery** — LGPL 2.1. https://github.com/libimobiledevice/libirecovery
- **libimobiledevice** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice
- **libusbmuxd** — LGPL 2.1. https://github.com/libimobiledevice/libusbmuxd
- **libimobiledevice-glue** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice-glue
- **libplist** — LGPL 2.1. https://github.com/libimobiledevice/libplist
- **libzip** — BSD-licentie met 3 clausules. https://libzip.org
- **xz / liblzma** — publiek domein / 0BSD. https://tukaani.org/xz/
- **zstd** — BSD-licentie. https://facebook.github.io/zstd/
- **OpenSSL** — Apache 2.0. https://openssl.org
- **De reparatie van Senne (3SENN)** — CC0 (publiek domein): https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

## Jouw rechten bij de LGPL-bibliotheken

De bibliotheken zitten als **losse bestanden** in de app (`J7 Rescue.app/Contents/Frameworks` en `Contents/Helpers`), niet vastgeplakt in het programma van de app, dus je kunt ze vervangen door je eigen versies.
De **broncode** van het aangepaste deel (idevicerestore met de patch, libtatsu) en die van de app zelf, samen met de exacte stappen om alles opnieuw te bouwen, staan in de map `CODIGO_FUENTE` op de `.dmg`. De andere bibliotheken zijn **ongewijzigd** gebruikt, precies zoals Homebrew ze uitbrengt: hun code staat op de links hierboven (de versies staan in `CODIGO_FUENTE/VERSIONES.txt`).

## Merken

«iPhone», «iOS», «Finder» en «Apple» zijn merken van Apple Inc. Deze app is **niet van Apple en wordt niet door Apple goedgekeurd**. Het iOS wordt rechtstreeks van de servers van Apple gedownload.
