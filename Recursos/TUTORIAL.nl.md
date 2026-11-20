# iPhone vast na «onbekende fout (100) 06A6.0064» — zo heb ik hem hersteld zonder iets kwijt te raken

> Echt geval: iPhone 17 Pro Max van 256 GB, met ongeveer 3 GB vrij en **zonder
> reservekopie**. Bij het updaten naar iOS 27.2.1 vanaf de Mac (Finder) mislukte het drie keer met
> *«De iPhone kan niet worden geüpdatet. Er is een onbekende fout opgetreden (100).
> 06A6.0064»* en bleef hij hangen op het appeltje. Finder bood alleen **Herstel** aan (alles wissen).
> Met deze methode startte hij op **met al zijn gegevens**, meteen de eerste keer.
>
> De reparatie komt van **Senne** (https://github.com/3SENN/iphone-stuck-in-recovery-full-storage).
> Deze tutorial legt het uit in het Nederlands en voegt een tool toe die de stappen zelf uitvoert.

---

## 0. Eerst dit: wat je NIET moet doen

- ❌ **Klik niet op «Herstel»** in Finder of iTunes. Dat is het enige wat je gegevens wist.
- ❌ Laat ze in de winkel de iPhone niet «herstellen» zonder het eerst aan jou te vragen.
- ✅ «Update» en de geforceerde herstart met de knoppen **wissen niets**: je kunt ze herhalen.

## 1. Is dit jouw situatie?

Je hebt een Mac nodig. Open **Terminal** en plak dit:

```bash
grep -l 'Failed preallocation due to space' ~/Library/Logs/iPhone\ Updater\ Logs/*.log
```

- **Als er een bestand verschijnt** → het is precies dit probleem. Ga verder.
- **Als er niets verschijnt** → jouw fout is een andere. Deze methode helpt je niet.

## 2. Wat is er gebeurd (zonder vakjargon)

De iPhone is een huis met twee verdiepingen. **Boven staat het systeem (iOS)** en **beneden jouw spullen**.

1. Voordat hij update, checkt een «bewaker» of het nieuwe systeem past. Omdat je
   heel krap zat, zegt hij «past».
2. De iPhone **haalt het oude systeem weg**.
3. Bij het reserveren van ruimte voor het nieuwe systeem past de opslag een regel toe die de
   bewaker niet kent: **je mag niet in één keer meer dan ~84 % van de vrije ruimte reserveren**.
   Het past dus niet.
4. Boven blijft het leeg, en daarom blijft de iPhone hangen op het appeltje. **Beneden is niets aangeraakt.**

Opnieuw proberen met Finder mislukt altijd op dezelfde manier. De reparatie **vertelt de bewaker dat het
systeem iets groter is dan in werkelijkheid**. Dan zegt de bewaker «past niet»
en voert de iPhone zijn **automatische opruiming van tijdelijke bestanden** uit (caches, logbestanden…).
Met die extra ruimte past het echte systeem er wel in.

**Risico:** bij het opruimen kunnen caches en dingen die je opnieuw kunt downloaden verdwijnen.
In mijn geval ontbrak er niets. Als het misgaat, blijft de iPhone zoals hij was
(in herstelmodus, met je gegevens) en kun je het opnieuw proberen.

## 3. Wat je nodig hebt

- Een Mac met **Homebrew** (https://brew.sh) en de tools van Xcode
  (`xcode-select --install`).
- Ongeveer **20 GB vrij op de Mac**. Alleen het iOS neemt al 11–14 GB in. Als de Mac tegelijk
  aan het updaten is, **annuleer die update**: die is niet nodig en vreet ruimte op.
- Een goede kabel, **direct aangesloten** op de Mac, zonder hub.

## 4. Met de tool (aanbevolen)

Bewaar `rescatar_iphone.sh` in een map (bijvoorbeeld `~/RescateiPhone`) en voer in Terminal uit:

```bash
cd ~/RescateiPhone
./rescatar_iphone.sh diagnostico
```

Als het bevestigt dat dit jouw situatie is, zet je de iPhone in **herstelmodus**:

> Aangesloten op de Mac: druk op **volume omhoog** en laat los → druk op **volume omlaag** en laat los
> → **houd de zijknop ingedrukt** (ook als het appeltje verschijnt) tot je **de kabel en de computer** ziet.
> Als Finder met «Update/Herstel» opduikt, klik dan op **Annuleer**.

```bash
./rescatar_iphone.sh preparar
```

Dit installeert en bouwt het programma, en downloadt bij Apple het juiste iOS voor jouw
model. Het controleert of het bestand niet beschadigd is en of het de optie
«updaten zonder te wissen» heeft.

```bash
./rescatar_iphone.sh rescatar
```

Het berekent het getal voor de reparatie met de gegevens van jouw iPhone, vraagt je om
**JA** te typen en start de update. Onderweg vertelt het je in welke stap het zit.
**Als het programma zou melden dat het gaat wissen, stopt het zelf.**

Als het aan het eind zegt dat er nog steeds te weinig ruimte is, geeft het je de opdracht om het opnieuw te proberen
met een getal dat 200 hoger is.

## 5. Wat je op de iPhone ziet (en waar je niet van hoeft te schrikken)

1. **Eerste balk** (appeltje + balk) terwijl de Mac het systeem verstuurt. Hier
   ging het bij Finder mis. Als de tool «Belangrijkste moment gehaald» zegt, is het voorbij.
2. De Mac meldt **«Status: Restore Finished»**.
3. De iPhone start zelf opnieuw op en er verschijnt **een tweede balk**, een trage: hij maakt
   je gegevens klaar voor het nieuwe iOS. Bij een heel volle iPhone kan dat **10–30 minuten** duren.
   **Raak niets aan.**
4. Hij vraagt om je code → je spullen staan er nog. 🎉

## 6. Daarna

1. **Maak 10–15 GB vrij** via Instellingen → Algemeen → iPhone-opslag.
2. **Maak een reservekopie** (op de Mac, op een externe schijf of in iCloud).
3. Vertel Senne je resultaat om anderen te helpen:
   https://github.com/3SENN/iphone-stuck-in-recovery-full-storage/issues/new?template=result.yml

---

## Technische bijlage (de commando's met de hand)

```bash
brew install autoconf automake libtool pkgconf libimobiledevice libirecovery libtatsu libzip
git clone https://github.com/3SENN/iphone-stuck-in-recovery-full-storage.git
git clone https://github.com/libimobiledevice/idevicerestore.git
git clone https://github.com/libimobiledevice/libtatsu.git

# nieuwe libtatsu (verplicht bij iPhone 14 en nieuwer)
cd libtatsu && ./autogen.sh --prefix="$PWD/install" --enable-static --disable-shared && make -j8 && make install && cd ..

# idevicerestore met de reparatie
cd idevicerestore && git checkout 60192e9
git apply ../iphone-stuck-in-recovery-full-storage/patches/0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch
export PKG_CONFIG_PATH="$PWD/../libtatsu/install/lib/pkgconfig:$(brew --prefix)/lib/pkgconfig"
./autogen.sh --prefix="$PWD/install" && make -j8 && make install

# iPhone in herstelmodus: model en ECID
irecovery -q | grep -E 'MODE|PRODUCT|ECID'

# Ondertekend IPSW (DEZELFDE versie die mislukte of een nieuwere) van https://ipsw.me
# Getal voor de reparatie met het logbestand van Finder:
python3 ../iphone-stuck-in-recovery-full-storage/tools/suggest_cryptex_size.py <ipsw> \
  --log ~/Library/Logs/iPhone\ Updater\ Logs/<het bestand met de fout>.log

# Starten (NOOIT -e toevoegen)
IDEVICERESTORE_CRYPTEX_SIZE_MIB=<getal> caffeinate -is ./install/bin/idevicerestore \
  -y -P -i <ECID> --variant 'Customer Upgrade Install (IPSW)' <ipsw>
```

Mijn geval: `iPhone18,2`, `iPhone18,2_27.2.1_24B156_Restore.ipsw`. Het systeem was 6030 MiB;
er was 5649 MB nodig en er was 5676 MB vrij. Het werkte meteen de eerste keer met het getal **6207**.
