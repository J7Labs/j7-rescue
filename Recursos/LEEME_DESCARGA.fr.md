# J7 Rescue

**Récupère ton iPhone sans rien effacer** quand, en le mettant à jour depuis le Mac, il affiche
*« Une erreur inconnue s’est produite (100) 06A6.0064 »* et reste sur la pomme
(presque toujours parce que son stockage était très plein).

Gratuit. Sans Terminal, sans rien installer de plus. Fait par Jesús avec Claude · J7 Labs.

---

## Est-ce pour moi ?

Oui, si :

- En mettant à jour l’iPhone avec le **Finder** (Mac), l’erreur **(100) 06A6.0064** est apparue et il ne te propose plus que « Restaurer » (qui efface tout).
- **N’appuie pas sur « Restaurer ».** C’est la seule chose qui efface tes données.

L’app le vérifie pour toi en lisant les journaux du Finder. Si ton erreur est une autre, elle te le dira et n’ira pas plus loin.

## Ce dont tu as besoin

- Un Mac avec **puce Apple (M1 ou plus récent)** et **macOS 26 (Tahoe)** ou plus récent.
- Environ **20 Go libres** sur le Mac (iOS occupe environ 13 Go).
- Un bon câble, **branché directement** au Mac (sans hub).

## Téléchargement

👉 **[J7-Rescue.dmg](https://github.com/J7Labs/j7-rescue/releases/latest/download/J7-Rescue.dmg)** (environ 6 Mo)

## Comment l’ouvrir (avertissement du Mac : « Ouvrir quand même »)

Cette app **n’est pas sur l’App Store** et n’a pas de signature payante d’Apple, c’est pourquoi le Mac
affiche un avertissement la première fois. C’est normal. Pour l’ouvrir :

1. Ouvre le `.dmg` et **glisse « J7 Rescue » dans le dossier Applications**.
2. Ouvre-la depuis Applications (double-clic). Un avertissement indiquera qu’elle ne peut pas être vérifiée. Appuie sur **OK** (ou « Terminé »).
3. Ouvre **Réglages Système → Confidentialité et sécurité**.
4. Descends jusqu’à la section **Sécurité**. Tu verras : *« "J7 Rescue" a été bloquée pour protéger ton Mac »*. Appuie sur **Ouvrir quand même**.
5. Saisis le mot de passe de ton Mac (ou utilise Touch ID) et appuie sur **Ouvrir**.

C’est nécessaire seulement la première fois. Ensuite, elle s’ouvre comme n’importe quelle autre app.

> Tu préfères ne pas te fier à un fichier téléchargé sur internet ? Tu as raison de te poser la question.
> Tout le code (de l’app et de ce qu’elle embarque) se trouve dans le dossier `CODIGO_FUENTE`
> du `.dmg`, et la réparation sur laquelle elle repose est publique (lien ci-dessous).

## Comment l’utiliser

1. Ouvre l’app. Elle regarde toute seule si ton cas est bien celui-ci.
2. Mets l’iPhone en **mode de récupération** (l’app te le montre avec un dessin) : Volume + · Volume − · maintiens le bouton latéral jusqu’à voir le câble et l’ordinateur.
3. Appuie sur **Télécharger iOS** (il le télécharge directement chez Apple ; si ça coupe, il reprend là où il s’était arrêté).
4. Appuie sur **Sauver mon iPhone**, écris **OUI** et attends. **Ne touche ni à l’iPhone ni au câble.**
5. Quand le Mac a terminé, l’iPhone démarre tout seul avec une barre lente (10 à 30 min). Quand il demande le code, tes affaires sont là.

L’app te prévient par une notification à la fin du téléchargement, au passage du « moment clé » et à la fin.

## C’est sûr parce que…

- **Elle n’efface jamais** : elle utilise toujours l’option « mettre à jour » et, si le programme annonçait qu’il va effacer, il s’arrête tout seul.
- Elle te demande d’écrire **OUI** avant de commencer.
- iOS est téléchargé **uniquement depuis des serveurs d’Apple** et on vérifie qu’il n’est pas endommagé.
- Si quelque chose échoue, l’iPhone reste comme il était (en mode de récupération, avec tes données) et tu peux réessayer.

> Malgré tout, aucune méthode n’est infaillible à 100 %. Si tu peux, fais une sauvegarde quand tu as fini.
> L’app est proposée **en l’état, sans garantie**.

## Crédits

- **Senne (3SENN)** — créateur de la réparation qui rend tout ça possible : https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — son guide a expliqué le problème et donné le code d’erreur (06A6.0064) qui nous a menés à la réparation de Senne : https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **L’équipe de libimobiledevice** (Nikias Bassen, Martin Szulecki, Joshua Hill et toutes les personnes qui ont contribué) — idevicerestore et les bibliothèques de base : https://libimobiledevice.org
- **Fait par Jesús avec Claude** · J7 Labs

## Licences et code source

Le code original de « J7 Rescue » est sous **licence MIT** (gratuit, on peut le copier et le modifier, sans garantie). Le reste appartient à ses auteurs, avec leurs licences :

J7 Rescue utilise des logiciels libres : idevicerestore (LGPL 2.1 ou ultérieure, avec le correctif de Senne, domaine public CC0),
libirecovery, libimobiledevice, libusbmuxd, libimobiledevice-glue, libplist et libtatsu (LGPL 2.1),
OpenSSL (Apache 2.0), libzip (BSD), xz et zstd (BSD / domaine public).
Les bibliothèques sont fournies comme fichiers séparés dans l’app (`Contents/Frameworks`), on peut donc les remplacer.
Le `.dmg` inclut les dossiers **`Licencias`** (textes complets) et **`CODIGO_FUENTE`** (code exact, correctif et façon de le reconstruire).
Code original : https://github.com/libimobiledevice · https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

« iPhone », « iOS », « Finder » et « Apple » sont des marques d’Apple Inc. Cette app n’est pas d’Apple et n’est pas approuvée par Apple.
