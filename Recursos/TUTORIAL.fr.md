# iPhone bloqué après « erreur inconnue (100) 06A6.0064 » — comment je l’ai récupéré sans rien perdre

> Cas réel : iPhone 17 Pro Max de 256 Go, avec environ 3 Go de libres et **sans
> sauvegarde**. En mettant à jour vers iOS 27.2.1 depuis le Mac (Finder), l’opération a échoué trois fois avec
> *« L’iPhone n’a pas pu être mis à jour. Une erreur inconnue s’est produite (100).
> 06A6.0064 »* et il est resté sur la pomme. Le Finder ne proposait que **Restaurer** (tout effacer).
> Avec cette méthode, il a démarré **avec toutes ses données**, du premier coup.
>
> La réparation est de **Senne** (https://github.com/3SENN/iphone-stuck-in-recovery-full-storage).
> Ce tutoriel l’explique en français et ajoute un outil qui fait les étapes tout seul.

---

## 0. Avant tout : ce qu’il ne faut PAS faire

- ❌ **N’appuie pas sur « Restaurer »** dans le Finder ni dans iTunes. C’est la seule chose qui efface tes données.
- ❌ Ne laisse pas la boutique « le restaurer » sans te demander ton avis.
- ✅ « Mettre à jour » et le redémarrage forcé avec les boutons **n’effacent rien** : tu peux les refaire.

## 1. Est-ce ton cas ?

Il te faut un Mac. Ouvre **Terminal** et colle :

```bash
grep -l 'Failed preallocation due to space' ~/Library/Logs/iPhone\ Updater\ Logs/*.log
```

- **Si un fichier apparaît** → c’est exactement ce problème. Continue.
- **Si rien n’apparaît** → ton erreur est une autre. Cette méthode ne te convient pas.

## 2. Ce qui s’est passé (sans jargon)

L’iPhone est une maison à deux étages. **En haut, le système (iOS)** et **en bas, tes affaires**.

1. Avant de mettre à jour, un « gardien » vérifie si le nouveau système rentre. Comme vous étiez
   très justes, il dit « ça rentre ».
2. L’iPhone **retire l’ancien système**.
3. Au moment de réserver la place pour le nouveau, le stockage applique une règle que le
   gardien ne connaît pas : **on ne peut pas réserver d’un coup plus de ~84 % de l’espace libre**.
   Ça ne rentre pas.
4. Le haut reste vide, et c’est pour ça que l’iPhone reste sur la pomme. **En bas, rien n’a été touché.**

Réessayer avec le Finder échoue toujours de la même façon. La réparation **dit au gardien que le
système est un peu plus gros qu’en réalité**. Alors le gardien dit « ça ne rentre pas »
et l’iPhone fait son **nettoyage automatique des fichiers temporaires** (caches, journaux…).
Avec cet espace libéré, le vrai système rentre.

**Risque :** le nettoyage peut supprimer des caches et des choses qui se retéléchargent.
Dans mon cas, il n’a rien manqué. Si ça échoue, l’iPhone reste tel qu’il était
(en mode de récupération, avec les données) et on peut réessayer.

## 3. Ce dont tu as besoin

- Un Mac avec **Homebrew** (https://brew.sh) et les outils Xcode
  (`xcode-select --install`).
- Environ **20 Go libres sur le Mac**. Rien que l’iOS occupe 11 à 14 Go. Si le Mac est
  en train de se mettre à jour en même temps, **annule cette mise à jour** : elle n’est pas nécessaire et elle mange l’espace.
- Un bon câble, **branché directement** au Mac, sans hub.

## 4. Avec l’outil (recommandé)

Enregistre `rescatar_iphone.sh` dans un dossier (par exemple `~/RescateiPhone`) et dans Terminal :

```bash
cd ~/RescateiPhone
./rescatar_iphone.sh diagnostico
```

S’il confirme que c’est ton cas, mets l’iPhone en **mode de récupération** :

> Branché au Mac : appuie et relâche **Volume +** → appuie et relâche **Volume −**
> → **maintiens le bouton latéral** (même quand la pomme apparaît) jusqu’à voir **le câble et l’ordinateur**.
> Si le Finder affiche « Mettre à jour/Restaurer », appuie sur **Annuler**.

```bash
./rescatar_iphone.sh preparar
```

Cela installe et monte le programme, et télécharge chez Apple le bon iOS pour ton
modèle. Il vérifie que le fichier n’est pas endommagé et qu’il propose l’option
« mettre à jour sans effacer ».

```bash
./rescatar_iphone.sh rescatar
```

Il calcule le nombre de la réparation avec les données de ton iPhone, te demande d’écrire
**OUI** et lance la mise à jour. Pendant ce temps, il te dit à quelle étape il en est.
**Si le programme annonçait qu’il va effacer, il s’arrête tout seul.**

Si à la fin il indique qu’il manque encore de la place, il te donne la commande pour réessayer
avec un nombre plus grand de 200.

## 5. Ce que tu verras sur l’iPhone (et il ne faut pas s’inquiéter)

1. **Première barre** (pomme + barre) pendant que le Mac envoie le système. C’est ici
   que le Finder échouait. Quand l’outil dit « Moment clé passé », c’est bon.
2. Le Mac affiche **« Status: Restore Finished »**.
3. L’iPhone redémarre tout seul et une **deuxième barre**, lente, apparaît : il prépare
   tes données pour le nouvel iOS. Avec un iPhone très plein, ça peut prendre **10 à 30 minutes**.
   **Ne touche à rien.**
4. Il demande ton code → tes affaires sont là. 🎉

## 6. Ensuite

1. **Libère 10 à 15 Go** dans Réglages → Général → Stockage de l’iPhone.
2. **Fais une sauvegarde** (sur le Mac, sur un disque externe ou dans iCloud).
3. Raconte ton résultat à Senne pour aider les autres :
   https://github.com/3SENN/iphone-stuck-in-recovery-full-storage/issues/new?template=result.yml

---

## Annexe technique (les commandes à la main)

```bash
brew install autoconf automake libtool pkgconf libimobiledevice libirecovery libtatsu libzip
git clone https://github.com/3SENN/iphone-stuck-in-recovery-full-storage.git
git clone https://github.com/libimobiledevice/idevicerestore.git
git clone https://github.com/libimobiledevice/libtatsu.git

# libtatsu récente (obligatoire sur iPhone 14 et suivants)
cd libtatsu && ./autogen.sh --prefix="$PWD/install" --enable-static --disable-shared && make -j8 && make install && cd ..

# idevicerestore avec la réparation
cd idevicerestore && git checkout 60192e9
git apply ../iphone-stuck-in-recovery-full-storage/patches/0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch
export PKG_CONFIG_PATH="$PWD/../libtatsu/install/lib/pkgconfig:$(brew --prefix)/lib/pkgconfig"
./autogen.sh --prefix="$PWD/install" && make -j8 && make install

# iPhone en mode de récupération : modèle et ECID
irecovery -q | grep -E 'MODE|PRODUCT|ECID'

# IPSW signé (la MÊME version que celle qui a échoué, ou une plus récente) depuis https://ipsw.me
# Nombre de la réparation à partir du journal du Finder :
python3 ../iphone-stuck-in-recovery-full-storage/tools/suggest_cryptex_size.py <ipsw> \
  --log ~/Library/Logs/iPhone\ Updater\ Logs/<celui qui contient l’erreur>.log

# Lancer (NE JAMAIS ajouter -e)
IDEVICERESTORE_CRYPTEX_SIZE_MIB=<nombre> caffeinate -is ./install/bin/idevicerestore \
  -y -P -i <ECID> --variant 'Customer Upgrade Install (IPSW)' <ipsw>
```

Mon cas : `iPhone18,2`, `iPhone18,2_27.2.1_24B156_Restore.ipsw`. Le système mesurait 6030 Mio ;
il fallait 5649 Mo et il y avait 5676 Mo de libres. Ça a marché avec le nombre **6207** du premier coup.
