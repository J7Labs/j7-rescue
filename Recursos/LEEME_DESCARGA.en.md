# J7 Rescue

**Recover your iPhone without erasing anything** when, after updating it from the Mac, you get
*“An unknown error occurred (100) 06A6.0064”* and it gets stuck on the apple
(almost always because its storage was very full).

Free. No Terminal, nothing else to install. Made by Jesús with Claude · J7 Labs.

---

## Is it for me?

Yes, if:

- When updating the iPhone with **Finder** (Mac) the error **(100) 06A6.0064** appeared and now it only offers “Restore” (which erases everything).
- **Don't click “Restore”.** It's the only thing that erases your data.

The app checks this for you by reading Finder's logs. If your error is a different one, it will tell you and won't go on.

## What you need

- A Mac with an **Apple chip (M1 or later)** and **macOS 26 (Tahoe)** or newer.
- About **20 GB free** on the Mac (the iOS takes about 13 GB).
- A good cable, **plugged straight into** the Mac (no hub).

## Download

👉 **[J7-Rescue.dmg](https://github.com/J7Labs/j7-rescue/releases/latest/download/J7-Rescue.dmg)** (about 6 MB)

## How to open it (Mac warning: “Open Anyway”)

This app is **not on the App Store** and doesn't carry Apple's paid signature, so the Mac
warns you the first time. That's normal. To open it:

1. Open the `.dmg` and **drag “J7 Rescue” to the Applications folder**.
2. Open it from Applications (double-click). A warning will appear saying it can't be verified. Click **OK** (or “Done”).
3. Open **System Settings → Privacy & Security**.
4. Scroll down to the **Security** section. You'll see: *“"J7 Rescue" was blocked to protect your Mac”*. Click **Open Anyway**.
5. Enter your Mac password (or use Touch ID) and click **Open**.

You only need to do this the first time. After that it opens like any other app.

> Would you rather not trust a file you download from the internet? You're right to ask yourself that.
> All the code (of the app and of what it contains) is in the `CODIGO_FUENTE` folder
> of the `.dmg`, and the fix it's based on is public (link below).

## How to use it

1. Open the app. It checks on its own whether this is your case.
2. Put the iPhone in **recovery mode** (the app shows you with a drawing): volume up · volume down · hold the side button until you see the cable and the computer.
3. Click **Download iOS** (it downloads straight from Apple; if it gets cut off, it picks up where it left off).
4. Click **Rescue my iPhone**, type **YES** and wait. **Don't touch the iPhone or the cable.**
5. When the Mac finishes, the iPhone starts up on its own with a slow bar (10–30 min). When it asks for the passcode, your things are there.

The app alerts you with a notification when the download finishes, when the “key moment” passes and when it's done.

## It's safe because…

- **It never erases**: it always uses the “update” option and, if the program announced that it was going to erase, it stops on its own.
- It asks you to type **YES** before starting.
- The iOS is downloaded **only from Apple servers** and checked to make sure it isn't damaged.
- If anything fails, the iPhone stays as it was (in recovery mode, with your data) and you can try again.

> Even so, no method is 100% foolproof. If you can, make a backup when you're done.
> The app is offered **as is, without warranty**.

## Credits

- **Senne (3SENN)** — creator of the fix that makes all this possible: https://github.com/3SENN/iphone-stuck-in-recovery-full-storage
- **Igor Varyvoda** — their guide explained the problem and gave the error code (06A6.0064) that led us to Senne's fix: https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/
- **The libimobiledevice team** (Nikias Bassen, Martin Szulecki, Joshua Hill and everyone who has contributed) — idevicerestore and the base libraries: https://libimobiledevice.org
- **Made by Jesús with Claude** · J7 Labs

## Licenses and source code

The original code of “J7 Rescue” is under the **MIT license** (free, can be copied and changed, no warranty). The rest belongs to its authors, under their licenses:

J7 Rescue uses free software: idevicerestore (LGPL 2.1 or later, with Senne's patch, public domain CC0),
libirecovery, libimobiledevice, libusbmuxd, libimobiledevice-glue, libplist and libtatsu (LGPL 2.1),
OpenSSL (Apache 2.0), libzip (BSD), xz and zstd (BSD / public domain).
The libraries come as separate files inside the app (`Contents/Frameworks`), so they can be replaced.
The `.dmg` includes the folders **`Licencias`** (full texts) and **`CODIGO_FUENTE`** (exact code, patch and how to rebuild it).
Original code: https://github.com/libimobiledevice · https://github.com/3SENN/iphone-stuck-in-recovery-full-storage

“iPhone”, “iOS”, “Finder” and “Apple” are trademarks of Apple Inc. This app is not made by Apple nor endorsed by Apple.
