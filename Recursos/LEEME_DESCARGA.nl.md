# J7 Rescue

**Haal je iPhone terug zonder iets te wissen** wanneer er bij het updaten vanaf de Mac
*«Er is een onbekende fout opgetreden (100) 06A6.0064»* verschijnt en hij blijft hangen op het appeltje
(bijna altijd omdat de opslag bijna helemaal vol zat).

Gratis. Zonder Terminal, zonder iets extra te installeren. Gemaakt door Jesús met Claude · J7 Labs.

---

## Is dit iets voor mij?

Ja, als:

- Bij het updaten van de iPhone met **Finder** (Mac) de fout **(100) 06A6.0064** verscheen en hij je nu alleen «Herstel» aanbiedt (dat wist alles).
- **Klik niet op «Herstel».** Dat is het enige wat je gegevens wist.

De app checkt dit voor je door de logbestanden van Finder te lezen. Als jouw fout een andere is, zegt hij dat en gaat hij niet verder.

## Wat je nodig hebt

- Een Mac met **Apple-chip (M1 of nieuwer)** en **macOS 26 (Tahoe)** of nieuwer.
- Ongeveer **20 GB vrij** op de Mac (het iOS neemt zo'n 13 GB in).
- Een goede kabel, **direct aangesloten** op de Mac (zonder hub).

## Download

👉 **[J7-Rescue.dmg](https://github.com/J7Labs/j7-rescue/releases/latest/download/J7-Rescue.dmg)** (ongeveer 6 MB)

## Zo open je de app (melding van de Mac: «Toch openen»)

Deze app **staat niet in de App Store** en heeft geen betaalde handtekening van Apple, daarom
waarschuwt de Mac de eerste keer. Dat is normaal. Zo open je hem:

1. Open de `.dmg` en **sleep «J7 Rescue» naar de map Programma's**.
2. Open hem vanuit Programma's (dubbelklik). Er verschijnt een melding dat hij niet geverifieerd kan worden. Klik op **OK** (of «Gereed»).
3. Open **Systeeminstellingen → Privacy en beveiliging**.
4. Scrol omlaag naar het onderdeel **Beveiliging**. Je ziet: *«"J7 Rescue" is geblokkeerd om je Mac te beschermen»*. Klik op **Toch openen**.
5. Typ het wachtwoord van je Mac (of gebruik Touch ID) en klik op **Open**.

Dit hoeft alleen de eerste keer. Daarna opent hij zoals elke andere app.

> Wil je liever geen bestand vertrouwen dat je van internet haalt? Terecht dat je dat afvraagt.
> Alle code (van de app en van wat erin zit) staat in de map `CODIGO_FUENTE`
> op de `.dmg`, en de reparatie waarop de app is gebaseerd is openbaar (link hieronder).

## Zo gebruik je hem

1. Open de app. Hij kijkt zelf of dit jouw situatie is.
2. Zet de iPhone in **herstelmodus** (de app laat het zien met een tekening): volume omhoog · volume omlaag · zijknop ingedrukt houden tot je de kabel en de computer ziet.
3. Klik op **iOS downloaden** (hij haalt het rechtstreeks bij Apple; als de download wegvalt, gaat hij verder waar hij gebleven was).
4. Klik op **Mijn iPhone redden**, typ **JA** en wacht. **Raak de iPhone en de kabel niet aan.**
5. Als de Mac klaar is, start de iPhone zelf op met een trage balk (10–30 min). Als hij om je code vraagt, staan je spullen er nog.

De app laat het je weten met een melding als de download klaar is, als het «belangrijkste moment» voorbij is en als alles klaar is.

## Het is veilig omdat…

- **Hij wist nooit iets**: hij gebruikt altijd de optie «updaten» en als het programma zou melden dat het gaat wissen, stopt het zelf.
- Hij vraagt je **JA** te typen voordat hij begint.
- Het iOS wordt **alleen van servers van Apple** gedownload en gecheckt op beschadiging.
- Als er iets misgaat, blijft de iPhone zoals hij was (in herstelmodus, met je gegevens) en kun je het opnieuw proberen.

> Toch is geen enkele methode 100 % feilloos. Maak als je kunt een reservekopie als je klaar bent.
> De app wordt aangeboden **zoals hij is, zonder garantie**.

## Credits

- **Senne (3SENN)** — bedenker van de reparatie die dit allemaal mogelijk maakt: https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — zijn gids legde het probleem uit en gaf de foutcode (06A6.0064) die ons naar de reparatie van Senne bracht: https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **Het libimobiledevice-team** (Nikias Bassen, Martin Szulecki, Joshua Hill en alle mensen die hebben bijgedragen) — idevicerestore en de basisbibliotheken: https://libimobiledevice.org
- **Gemaakt door Jesús met Claude** · J7 Labs

## Licenties en broncode

De oorspronkelijke code van «J7 Rescue» heeft een **MIT-licentie** (gratis, mag worden gekopieerd en aangepast, zonder garantie). De rest is van de makers ervan, met hun eigen licenties:

J7 Rescue gebruikt vrije software: idevicerestore (LGPL 2.1 of nieuwer, met de patch van Senne, publiek domein CC0),
libirecovery, libimobiledevice, libusbmuxd, libimobiledevice-glue, libplist en libtatsu (LGPL 2.1),
OpenSSL (Apache 2.0), libzip (BSD), xz en zstd (BSD / publiek domein).
De bibliotheken zitten als losse bestanden in de app (`Contents/Frameworks`), dus ze kunnen worden vervangen.
De `.dmg` bevat de mappen **`Licencias`** (volledige teksten) en **`CODIGO_FUENTE`** (exacte code, patch en hoe je alles opnieuw bouwt).
Oorspronkelijke code: https://github.com/libimobiledevice · https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

«iPhone», «iOS», «Finder» en «Apple» zijn merken van Apple Inc. Deze app is niet van Apple en wordt niet door Apple goedgekeurd.
