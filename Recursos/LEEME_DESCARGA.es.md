# J7 Rescue

**Recupera tu iPhone sin borrar nada** cuando, al actualizarlo desde el Mac, sale
*«Se ha producido un error desconocido (100) 06A6.0064»* y se queda en la manzana
(casi siempre porque tenía el almacenamiento muy lleno).

Gratis. Sin Terminal, sin instalar nada más. Hecha por Jesús con Claude · J7 Labs.

---

## ¿Es para mí?

Sí, si:

- Al actualizar el iPhone con **Finder** (Mac) salió el error **(100) 06A6.0064** y ahora solo te ofrece «Restaurar» (que borra todo).
- **No pulses «Restaurar».** Eso es lo único que borra tus datos.

La app lo comprueba por ti leyendo los registros de Finder. Si tu error es otro, te lo dirá y no seguirá.

## Qué necesitas

- Un Mac con **chip Apple (M1 o posterior)** y **macOS 26 (Tahoe)** o más nuevo.
- Unos **20 GB libres** en el Mac (el iOS ocupa unos 13 GB).
- Un buen cable, **enchufado directo** al Mac (sin hub).

## Descarga

👉 **[J7-Rescue.dmg](https://github.com/J7Labs/j7-rescue/releases/latest/download/J7-Rescue.dmg)** (unos 6 MB)

## Cómo abrirla (aviso del Mac: «Abrir igualmente»)

Esta app **no está en la App Store** y no lleva firma de pago de Apple, por eso el Mac
avisa la primera vez. Es normal. Para abrirla:

1. Abre el `.dmg` y **arrastra «J7 Rescue» a la carpeta Aplicaciones**.
2. Ábrela desde Aplicaciones (doble clic). Saldrá un aviso de que no se puede verificar. Pulsa **Aceptar** (o «Hecho»).
3. Abre **Ajustes del Sistema → Privacidad y seguridad**.
4. Baja hasta el apartado **Seguridad**. Verás: *«"J7 Rescue" se ha bloqueado para proteger tu Mac»*. Pulsa **Abrir igualmente**.
5. Escribe tu contraseña del Mac (o usa Touch ID) y pulsa **Abrir**.

Solo hace falta la primera vez. Después se abre como cualquier otra app.

> ¿Prefieres no fiarte de un archivo que bajas de internet? Haces bien en preguntarte.
> Todo el código (de la app y de lo que lleva dentro) está en la carpeta `CODIGO_FUENTE`
> del `.dmg`, y el arreglo en el que se basa es público (enlace abajo).

## Cómo se usa

1. Abre la app. Mira sola si tu caso es este.
2. Pon el iPhone en **modo recuperación** (la app te lo enseña con un dibujo): subir volumen · bajar volumen · mantener el botón lateral hasta ver el cable y el ordenador.
3. Pulsa **Descargar el iOS** (lo baja directo de Apple; si se corta, sigue donde se quedó).
4. Pulsa **Rescatar mi iPhone**, escribe **SI** y espera. **No toques el iPhone ni el cable.**
5. Cuando el Mac termine, el iPhone arranca solo con una barra lenta (10–30 min). Cuando pida el código, tus cosas están ahí.

La app te avisa con una notificación al acabar la descarga, al pasar el «momento clave» y al terminar.

## Es seguro porque…

- **Nunca borra**: usa siempre la opción «actualizar» y, si el programa anunciara que va a borrar, se corta solo.
- Pide que escribas **SI** antes de empezar.
- El iOS se baja **solo de servidores de Apple** y se comprueba que no está dañado.
- Si algo falla, el iPhone se queda como estaba (en recuperación, con tus datos) y se puede reintentar.

> Aun así, ningún método es 100 % infalible. Si puedes, haz copia de seguridad cuando acabes.
> La app se ofrece **tal cual, sin garantía**.

## Créditos

- **Senne (3SENN)** — creador del arreglo que hace todo esto posible: https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — su guía explicó el problema y dio el código de error (06A6.0064) que nos llevó hasta el arreglo de Senne: https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **El equipo de libimobiledevice** (Nikias Bassen, Martin Szulecki, Joshua Hill y todas las personas que han contribuido) — idevicerestore y las librerías base: https://libimobiledevice.org
- **Hecho por Jesús con Claude** · J7 Labs

## Licencias y código fuente

El código original de «J7 Rescue» tiene **licencia MIT** (gratis, se puede copiar y cambiar, sin garantía). El resto es de sus autores, con sus licencias:

J7 Rescue usa software libre: idevicerestore (LGPL 2.1 o posterior, con el parche de Senne, dominio público CC0),
libirecovery, libimobiledevice, libusbmuxd, libimobiledevice-glue, libplist y libtatsu (LGPL 2.1),
OpenSSL (Apache 2.0), libzip (BSD), xz y zstd (BSD / dominio público).
Las librerías van como archivos aparte dentro de la app (`Contents/Frameworks`), así que se pueden sustituir.
El `.dmg` incluye las carpetas **`Licencias`** (textos completos) y **`CODIGO_FUENTE`** (código exacto, parche y cómo reconstruirlo).
Código original: https://github.com/libimobiledevice · https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

«iPhone», «iOS», «Finder» y «Apple» son marcas de Apple Inc. Esta app no es de Apple ni está avalada por Apple.
