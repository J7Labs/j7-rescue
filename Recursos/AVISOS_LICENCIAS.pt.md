# Avisos de licenças

O **J7 Rescue** é gratuito e é oferecido **sem nenhuma garantia**. Feito por Jesús com Claude (J7 Labs). O seu código original tem **licença MIT** (texto em `Licencias/J7-Rescue_MIT.txt`): você pode usá-lo, copiá-lo e modificá-lo de graça, mantendo o aviso de autoria.
Ele usa software livre de outras pessoas. Aqui está o que é, de quem e com qual licença.
Os textos completos estão na pasta *Licencias* (botão «Abrir pasta de licenças»).

## Agradecimentos a…

- **Senne (3SENN)** — criador do conserto (o patch que torna tudo isso possível). https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — o guia dele explicou o problema e deu o código de erro (06A6.0064) que nos levou ao conserto do Senne. https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **A equipe do libimobiledevice** — Nikias Bassen, Martin Szulecki, Joshua Hill e todas as pessoas que contribuíram para idevicerestore, libirecovery, libimobiledevice, libusbmuxd, libplist, libtatsu e libimobiledevice-glue. https://libimobiledevice.org

## Programas e bibliotecas que ele leva dentro

- **idevicerestore** (Nikias Bassen, Martin Szulecki, Joshua Hill e colaboradores) — LGPL 2.1 ou posterior (o repositório inclui o texto da LGPL 3.0). **Versão modificada**: commit `60192e9` com o patch do Senne (`0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch`, domínio público CC0). https://github.com/libimobiledevice/idevicerestore
- **libtatsu** (libimobiledevice) — LGPL 2.1, commit `b8d518a`, incluída dentro do idevicerestore. https://github.com/libimobiledevice/libtatsu
- **irecovery / libirecovery** — LGPL 2.1. https://github.com/libimobiledevice/libirecovery
- **libimobiledevice** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice
- **libusbmuxd** — LGPL 2.1. https://github.com/libimobiledevice/libusbmuxd
- **libimobiledevice-glue** — LGPL 2.1. https://github.com/libimobiledevice/libimobiledevice-glue
- **libplist** — LGPL 2.1. https://github.com/libimobiledevice/libplist
- **libzip** — licença BSD de 3 cláusulas. https://libzip.org
- **xz / liblzma** — domínio público / 0BSD. https://tukaani.org/xz/
- **zstd** — licença BSD. https://facebook.github.io/zstd/
- **OpenSSL** — Apache 2.0. https://openssl.org
- **O conserto do Senne (3SENN)** — CC0 (domínio público): https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

## Seus direitos com as bibliotecas LGPL

As bibliotecas vão **como arquivos separados** dentro do app (`J7 Rescue.app/Contents/Frameworks` e `Contents/Helpers`), não coladas dentro do programa do app, então você pode substituí-las por versões suas.
O **código-fonte** do que foi modificado (idevicerestore com o patch, libtatsu) e o do próprio app, junto com os passos exatos para reconstruí-lo, vão na pasta `CODIGO_FUENTE` do `.dmg`. As demais bibliotecas foram usadas **sem modificação**, exatamente como o Homebrew as publica: o código delas está nos links acima (versões indicadas em `CODIGO_FUENTE/VERSIONES.txt`).

## Marcas

«iPhone», «iOS», «Finder» e «Apple» são marcas da Apple Inc. Este app **não é da Apple nem é endossado pela Apple**. O iOS é baixado diretamente dos servidores da Apple.
