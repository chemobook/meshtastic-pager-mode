# Meshtastic Pager Mode Fork

![Pager Mode banner](assets/pager-mode-banner.svg)

> Unofficial Meshtastic fork with pager-mode changes for small displays and e-ink targets.

## Project note

This is a **fork** of Meshtastic firmware, not an official upstream release.

It is maintained as community work without commercial backing or financial motivation.

A large part of the work here was produced with **AI assistance**. That is deliberate and openly acknowledged. The maintainer works in a different field, so AI was used as a practical tool to get from idea to working firmware changes and documentation.

## Language

- English: this file
- Russian: [README.ru.md](README.ru.md)

## What this fork changes

- Adds `Pager Mode` to the classic small-screen UI
- Carries the same idea into `InkHUD` on supported e-ink targets
- Keeps the device focused on the selected DM or channel while pager mode is active
- Uses long press to exit pager mode
- Persists pager mode across reboot
- Improves readability of long messages
- Keeps the changes intentionally smaller than a full UI redesign

## Intended devices

This fork is aimed at small displays:

- OLED-based Meshtastic devices
- e-ink devices using `InkHUD`

Large TFT-first layouts were intentionally not the main goal.

## Scope

- Keep the UI focused on message reading
- Limit the change set to something maintainable
- Preserve as much upstream behavior as possible
- Make local build, packaging, and flashing easier for the boards used in this fork

## Recommended targets

Examples:

```bash
pio run -e heltec-v3
pio run -e heltec-v4
pio run -e heltec-wireless-paper-inkhud
pio run -e t-echo-inkhud
```

Use the target that matches your actual hardware.

## Build, package, flash

The local build/export area for this fork is:

- [../../release-work/README.md](../../release-work/README.md)

## Preferred user path

For most users, the easiest path is now the browser flasher:

1. Open [Pager Mode Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/).
2. Use desktop Chrome or Edge.
3. Select `Heltec V3` or `Heltec V4`.
4. Flash from the browser and wait for the reboot.

Only these two boards are currently exposed on the web flasher.

To package current builds into that folder:

```bash
./bin/pager-package.sh heltec-v3 heltec-v4
```

That script copies the latest matching artifacts from `.pio/build/<env>/` into release-style folders and also fetches the ESP32-S3 OTA helper image when needed.

### Fast path

```bash
pio run -e heltec-v3
pio run -e heltec-v4
```

### Pack the results

```bash
./bin/pager-package.sh heltec-v3 heltec-v4
```

### Flash with the fork helper

```bash
./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX
```

This wrapper sits on top of the existing `bin/device-install.sh` flow and makes it easier to pick the right packaged image for `Heltec V3/V4`.

## Usage notes

- Use the exact board target that matches the hardware.
- Prefer the web flasher for normal user installs on `heltec-v3` and `heltec-v4`.
- Prefer testing pager-mode behavior on a real device before sharing a build.
- Treat this branch as a fork with focused changes, not as a full replacement for upstream Meshtastic.

## Known limitations

- This remains a community fork, so edge cases still need real-device testing.
- Large TFT targets were not the main focus.
- Russian defaults in this fork are practical, but more opinionated than upstream.
- The goal here is usefulness, not perfect coverage of every board.
