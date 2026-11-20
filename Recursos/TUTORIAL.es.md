# iPhone atascado tras «error desconocido (100) 06A6.0064» — cómo lo recuperé sin perder nada

> Caso real: iPhone 17 Pro Max de 256 GB, con unos 3 GB libres y **sin copia de
> seguridad**. Al actualizar a iOS 27.2.1 desde el Mac (Finder) falló tres veces con
> *«El iPhone no ha podido actualizarse. Se ha producido un error desconocido (100).
> 06A6.0064»* y se quedó en la manzana. Finder solo ofrecía **Restaurar** (borrarlo todo).
> Con este método arrancó **con todos los datos**, a la primera.
>
> El arreglo es de **Senne** (https://github.com/3SENN/iphone-stuck-in-recovery-full-storage).
> Este tutorial lo explica en español y añade una herramienta que hace los pasos sola.

---

## 0. Antes de nada: lo que NO hay que hacer

- ❌ **No pulses «Restaurar»** en Finder ni en iTunes. Es lo único que borra tus datos.
- ❌ No dejes que en la tienda «lo restauren» sin preguntarte.
- ✅ «Actualizar» y el reinicio forzado con botones **no borran nada**: puedes repetirlos.

## 1. ¿Es tu caso?

Necesitas un Mac. Abre **Terminal** y pega:

```bash
grep -l 'Failed preallocation due to space' ~/Library/Logs/iPhone\ Updater\ Logs/*.log
```

- **Si sale algún archivo** → es exactamente este problema. Sigue.
- **Si no sale nada** → tu error es otro. Este método no te sirve.

## 2. Qué ha pasado (sin tecnicismos)

El iPhone es una casa de dos plantas. **Arriba está el sistema (iOS)** y **abajo tus cosas**.

1. Antes de actualizar, un «guardia» comprueba si cabe el sistema nuevo. Como iban
   muy justos, dice «cabe».
2. El iPhone **quita el sistema viejo**.
3. Al reservar el sitio para el nuevo, el almacenamiento aplica una norma que el
   guardia no conoce: **no se puede reservar de golpe más del ~84 % del espacio libre**.
   No entra.
4. Arriba queda vacío, y por eso el iPhone se queda en la manzana. **Abajo no se ha tocado.**

Reintentar con Finder falla siempre igual. El arreglo **le dice al guardia que el
sistema es un poco más grande de lo real**. Entonces el guardia dice «no cabe»
y el iPhone hace su **limpieza automática de temporales** (cachés, registros…).
Con ese hueco, el sistema de verdad sí entra.

**Riesgo:** la limpieza puede borrar cachés y cosas que se vuelven a descargar.
En mi caso no faltó nada. Si falla, el iPhone se queda igual que estaba
(en recuperación, con los datos) y se puede reintentar.

## 3. Lo que necesitas

- Un Mac con **Homebrew** (https://brew.sh) y las herramientas de Xcode
  (`xcode-select --install`).
- Unos **20 GB libres en el Mac**. Solo el iOS ocupa 11–14 GB. Si el Mac está
  actualizándose a la vez, **cancela esa actualización**: no hace falta y se come el espacio.
- Un buen cable, **enchufado directo** al Mac, sin hub.

## 4. Con la herramienta (recomendado)

Guarda `rescatar_iphone.sh` en una carpeta (por ejemplo `~/RescateiPhone`) y en Terminal:

```bash
cd ~/RescateiPhone
./rescatar_iphone.sh diagnostico
```

Si confirma que es tu caso, pon el iPhone en **modo recuperación**:

> Conectado al Mac: pulsa y suelta **subir volumen** → pulsa y suelta **bajar volumen**
> → **mantén el botón lateral** (aunque salga la manzana) hasta ver **el cable y el ordenador**.
> Si Finder salta con «Actualizar/Restaurar», pulsa **Cancelar**.

```bash
./rescatar_iphone.sh preparar
```

Esto instala y monta el programa, y descarga de Apple el iOS correcto para tu
modelo. Comprueba que el archivo no está dañado y que trae la opción
«actualizar sin borrar».

```bash
./rescatar_iphone.sh rescatar
```

Calcula el número del arreglo con los datos de tu iPhone, te pide que escribas
**SI** y lanza la actualización. Mientras tanto te va diciendo en qué paso está.
**Si el programa anunciara que va a borrar, se corta solo.**

Si al final dice que sigue faltando sitio, te indica el comando para reintentar
con un número 200 más alto.

## 5. Qué verás en el iPhone (y no hay que asustarse)

1. **Primera barra** (manzana + barra) mientras el Mac envía el sistema. Aquí es
   donde fallaba Finder. Cuando la herramienta dice «Momento clave superado», ya pasó.
2. El Mac dice **«Status: Restore Finished»**.
3. El iPhone se reinicia solo y sale **una segunda barra**, lenta: está preparando
   tus datos para el iOS nuevo. Con el iPhone muy lleno puede tardar **10–30 minutos**.
   **No toques nada.**
4. Pide tu código → tus cosas están ahí. 🎉

## 6. Después

1. **Libera 10–15 GB** en Ajustes → General → Almacenamiento del iPhone.
2. **Haz una copia de seguridad** (en el Mac, en un disco externo o en iCloud).
3. Cuenta tu resultado a Senne para ayudar a otros:
   https://github.com/3SENN/iphone-stuck-in-recovery-full-storage/issues/new?template=result.yml

---

## Anexo técnico (los comandos a mano)

```bash
brew install autoconf automake libtool pkgconf libimobiledevice libirecovery libtatsu libzip
git clone https://github.com/3SENN/iphone-stuck-in-recovery-full-storage.git
git clone https://github.com/libimobiledevice/idevicerestore.git
git clone https://github.com/libimobiledevice/libtatsu.git

# libtatsu nueva (obligatoria en iPhone 14 y posteriores)
cd libtatsu && ./autogen.sh --prefix="$PWD/install" --enable-static --disable-shared && make -j8 && make install && cd ..

# idevicerestore con el arreglo
cd idevicerestore && git checkout 60192e9
git apply ../iphone-stuck-in-recovery-full-storage/patches/0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch
export PKG_CONFIG_PATH="$PWD/../libtatsu/install/lib/pkgconfig:$(brew --prefix)/lib/pkgconfig"
./autogen.sh --prefix="$PWD/install" && make -j8 && make install

# iPhone en recuperación: modelo y ECID
irecovery -q | grep -E 'MODE|PRODUCT|ECID'

# IPSW firmado (la MISMA versión que falló o una más nueva) desde https://ipsw.me
# Número del arreglo usando el registro de Finder:
python3 ../iphone-stuck-in-recovery-full-storage/tools/suggest_cryptex_size.py <ipsw> \
  --log ~/Library/Logs/iPhone\ Updater\ Logs/<el que tenga el error>.log

# Lanzar (NUNCA añadir -e)
IDEVICERESTORE_CRYPTEX_SIZE_MIB=<número> caffeinate -is ./install/bin/idevicerestore \
  -y -P -i <ECID> --variant 'Customer Upgrade Install (IPSW)' <ipsw>
```

Mi caso: `iPhone18,2`, `iPhone18,2_27.2.1_24B156_Restore.ipsw`. El sistema medía 6030 MiB;
hacían falta 5649 MB y había 5676 MB libres. Funcionó con el número **6207** a la primera.
