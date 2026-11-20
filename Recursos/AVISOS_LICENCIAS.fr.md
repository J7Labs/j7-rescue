# Avis de licences

**J7 Rescue** est gratuite et proposée **sans aucune garantie**. Faite par Jesús avec Claude (J7 Labs). Son code original est sous **licence MIT** (texte dans `Licencias/J7-Rescue_MIT.txt`) : tu peux l’utiliser, le copier et le modifier gratuitement, en conservant la mention d’auteur.
Elle utilise des logiciels libres créés par d’autres personnes. Voici ce que c’est, de qui, et sous quelle licence.
Les textes complets se trouvent dans le dossier *Licencias* (bouton « Ouvrir le dossier des licences »).

## Merci à…

- **Senne (3SENN)** — créateur de la réparation (le correctif qui rend tout ça possible). https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — son guide a expliqué le problème et donné le code d’erreur (06A6.0064) qui nous a menés à la réparation de Senne. https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **L’équipe de libimobiledevice** — Nikias Bassen, Martin Szulecki, Joshua Hill et toutes les personnes qui ont contribué à idevicerestore, libirecovery, libimobiledevice, libusbmuxd, libplist, libtatsu et libimobiledevice-glue. https://libimobiledevice.org

## Programmes et bibliothèques qu’elle embarque

- **idevicerestore** (Nikias Bassen, Martin Szulecki, Joshua Hill et contributeurs) — LGPL 2.1 ou ultérieure (le dépôt inclut le texte de la LGPL 3.0). **Version modifiée** : commit `60192e9` avec le correctif de Senne (`0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch`, domaine public CC0). https://github.com/libimobiledevice/idevicerestore
- **libtatsu** (libimobiledevice) — LGPL 2.1, commit `b8d518a`, incluse dans idevicerestore. https://github.com/libimobiledevice/libtatsu
- **irecovery / libirecovery** — LGPL 2.1. https://github.com/libimobiledevice/libirecovery
- **libimobiledevice** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice
- **libusbmuxd** — LGPL 2.1. https://github.com/libimobiledevice/libusbmuxd
- **libimobiledevice-glue** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice-glue
- **libplist** — LGPL 2.1. https://github.com/libimobiledevice/libplist
- **libzip** — licence BSD à 3 clauses. https://libzip.org
- **xz / liblzma** — domaine public / 0BSD. https://tukaani.org/xz/
- **zstd** — licence BSD. https://facebook.github.io/zstd/
- **OpenSSL** — Apache 2.0. https://openssl.org
- **La réparation de Senne (3SENN)** — CC0 (domaine public) : https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

## Tes droits sur les bibliothèques LGPL

Les bibliothèques sont fournies **comme fichiers séparés** dans l’app (`J7 Rescue.app/Contents/Frameworks` et `Contents/Helpers`), et non collées dans le programme de l’app, ce qui te permet de les remplacer par tes propres versions.
Le **code source** de ce qui a été modifié (idevicerestore avec le correctif, libtatsu) et celui de l’app elle-même, avec les étapes exactes pour le reconstruire, se trouvent dans le dossier `CODIGO_FUENTE` du `.dmg`. Les autres bibliothèques ont été utilisées **sans modification**, telles que Homebrew les publie : leur code est accessible via les liens ci-dessus (versions indiquées dans `CODIGO_FUENTE/VERSIONES.txt`).

## Marques

« iPhone », « iOS », « Finder » et « Apple » sont des marques d’Apple Inc. Cette app **n’est pas d’Apple et n’est pas approuvée par Apple**. iOS est téléchargé directement depuis les serveurs d’Apple.
