# iPhone stuck after “unknown error (100) 06A6.0064” — how I recovered it without losing anything

> Real case: a 256 GB iPhone 17 Pro Max, with about 3 GB free and **no backup**.
> When updating to iOS 27.2.1 from the Mac (Finder) it failed three times with
> *“The iPhone could not be updated. An unknown error occurred (100).
> 06A6.0064”* and got stuck on the apple. Finder only offered **Restore** (erase everything).
> With this method it started up **with all its data**, on the first try.
>
> The fix is by **Senne** (https://github.com/3SENN/iphone-stuck-in-recovery-full-storage).
> This tutorial explains it in plain English and adds a tool that does the steps for you.

---

## 0. First of all: what NOT to do

- ❌ **Don't click “Restore”** in Finder or iTunes. It's the only thing that erases your data.
- ❌ Don't let a shop “restore it” without asking you.
- ✅ “Update” and the forced restart with buttons **don't erase anything**: you can repeat them.

## 1. Is this your case?

You need a Mac. Open **Terminal** and paste:

```bash
grep -l 'Failed preallocation due to space' ~/Library/Logs/iPhone\ Updater\ Logs/*.log
```

- **If a file comes up** → it's exactly this problem. Keep going.
- **If nothing comes up** → your error is a different one. This method won't help you.

## 2. What happened (no jargon)

The iPhone is a two-storey house. **Upstairs is the system (iOS)** and **downstairs is your stuff**.

1. Before updating, a “guard” checks whether the new system fits. Since you were
   really tight on space, it says “it fits”.
2. The iPhone **removes the old system**.
3. When reserving room for the new one, the storage applies a rule the guard
   doesn't know about: **you can't reserve more than ~84% of the free space all at once**.
   It doesn't fit.
4. Upstairs is left empty, and that's why the iPhone stays on the apple. **Downstairs hasn't been touched.**

Retrying with Finder always fails the same way. The fix **tells the guard that the
system is a little bigger than it really is**. Then the guard says “it doesn't fit”
and the iPhone does its **automatic clean-up of temporary files** (caches, logs…).
With that gap, the real system does fit.

**Risk:** the clean-up may delete caches and things that download again.
In my case nothing was missing. If it fails, the iPhone stays just as it was
(in recovery mode, with its data) and you can try again.

## 3. What you need

- A Mac with **Homebrew** (https://brew.sh) and the Xcode tools
  (`xcode-select --install`).
- About **20 GB free on the Mac**. The iOS alone takes 11–14 GB. If the Mac is
  updating at the same time, **cancel that update**: it isn't needed and eats up the space.
- A good cable, **plugged straight into** the Mac, no hub.

## 4. With the tool (recommended)

Save `rescatar_iphone.sh` in a folder (for example `~/RescateiPhone`) and in Terminal:

```bash
cd ~/RescateiPhone
./rescatar_iphone.sh diagnostico
```

If it confirms this is your case, put the iPhone in **recovery mode**:

> Connected to the Mac: press and release **volume up** → press and release **volume down**
> → **hold the side button** (even when the apple appears) until you see **the cable and the computer**.
> If Finder pops up with “Update/Restore”, click **Cancel**.

```bash
./rescatar_iphone.sh preparar
```

This installs and builds the program, and downloads from Apple the right iOS for your
model. It checks that the file isn't damaged and that it has the
“update without erasing” option.

```bash
./rescatar_iphone.sh rescatar
```

It works out the fix number using your iPhone's data, asks you to type
**YES** and starts the update. Meanwhile it tells you which step it's on.
**If the program announced that it was going to erase, it stops on its own.**

If it says at the end that there's still not enough room, it gives you the command to retry
with a number 200 higher.

## 5. What you'll see on the iPhone (don't be alarmed)

1. **First bar** (apple + bar) while the Mac sends the system. This is where
   Finder used to fail. When the tool says “Key moment passed”, it's behind you.
2. The Mac says **“Status: Restore Finished”**.
3. The iPhone restarts on its own and a **second bar** appears, a slow one: it's preparing
   your data for the new iOS. With a very full iPhone it can take **10–30 minutes**.
   **Don't touch anything.**
4. It asks for your passcode → your things are there. 🎉

## 6. Afterwards

1. **Free up 10–15 GB** in Settings → General → iPhone Storage.
2. **Make a backup** (on the Mac, on an external drive or in iCloud).
3. Tell Senne how it went to help others:
   https://github.com/3SENN/iphone-stuck-in-recovery-full-storage/issues/new?template=result.yml

---

## Technical appendix (the commands by hand)

```bash
brew install autoconf automake libtool pkgconf libimobiledevice libirecovery libtatsu libzip
git clone https://github.com/3SENN/iphone-stuck-in-recovery-full-storage.git
git clone https://github.com/libimobiledevice/idevicerestore.git
git clone https://github.com/libimobiledevice/libtatsu.git

# new libtatsu (required on iPhone 14 and later)
cd libtatsu && ./autogen.sh --prefix="$PWD/install" --enable-static --disable-shared && make -j8 && make install && cd ..

# idevicerestore with the fix
cd idevicerestore && git checkout 60192e9
git apply ../iphone-stuck-in-recovery-full-storage/patches/0001-restore-Allow-overriding-the-declared-Cryptex1-SystemOSSize.patch
export PKG_CONFIG_PATH="$PWD/../libtatsu/install/lib/pkgconfig:$(brew --prefix)/lib/pkgconfig"
./autogen.sh --prefix="$PWD/install" && make -j8 && make install

# iPhone in recovery mode: model and ECID
irecovery -q | grep -E 'MODE|PRODUCT|ECID'

# Signed IPSW (the SAME version that failed or a newer one) from https://ipsw.me
# Fix number using the Finder log:
python3 ../iphone-stuck-in-recovery-full-storage/tools/suggest_cryptex_size.py <ipsw> \
  --log ~/Library/Logs/iPhone\ Updater\ Logs/<el que tenga el error>.log

# Launch (NEVER add -e)
IDEVICERESTORE_CRYPTEX_SIZE_MIB=<número> caffeinate -is ./install/bin/idevicerestore \
  -y -P -i <ECID> --variant 'Customer Upgrade Install (IPSW)' <ipsw>
```

My case: `iPhone18,2`, `iPhone18,2_27.2.1_24B156_Restore.ipsw`. The system measured 6030 MiB;
5649 MB were needed and there were 5676 MB free. It worked with the number **6207** on the first try.
