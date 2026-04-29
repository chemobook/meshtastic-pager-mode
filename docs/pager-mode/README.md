# Meshtastic Pager Mode Fork

![Pager Mode banner](assets/pager-mode-banner.svg)

> Unofficial Meshtastic fork for people who want a more focused pager-style reading experience on small displays.

## Project note

This is a **fork** of Meshtastic firmware, not an official upstream release.

It was created by interested people without financial motivation and shared simply because it might help someone else:

- no company pitch
- no monetization plan
- no funding story
- just a practical hobby/community fork

A large part of the work here was produced with **AI assistance**. That is deliberate and openly acknowledged. The maintainer works in a different field, and AI made it possible to bridge the gap between an idea and a usable firmware branch.

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

## Why it exists

The whole point is simple:

- make message reading easier
- keep the branch practical to maintain
- avoid breaking more upstream behavior than necessary
- share the result openly with other users

## Recommended build targets

Examples:

```bash
pio run -e heltec-v3
pio run -e heltec-v4
pio run -e heltec-wireless-paper-inkhud
pio run -e t-echo-inkhud
```

Use the target that matches your actual hardware.

## Ready firmware in this workspace

The local build/export area for this fork is:

- [../../release-work/README.md](../../release-work/README.md)

To package current builds into that folder:

```bash
./bin/pager-package.sh heltec-v3 heltec-v4
```

That script copies the latest matching artifacts from `.pio/build/<env>/` into release-style folders and also fetches the ESP32-S3 OTA helper image when needed.

## Build your own firmware

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

## Typical user path

For most users, the best experience is:

1. Download a ready build from releases or from a prepared local package folder.
2. Pick the correct file set for the exact board.
3. Flash it with the normal Meshtastic method or the helper script from this fork.
4. Test pager mode on real hardware.

## Typical maintainer path

1. Build the targets you care about.
2. Flash and test at least one real device.
3. Package the artifacts.
4. Publish only the boards you actually verified.

## Known limitations

- This remains a community fork, so edge cases still need real-device testing.
- Large TFT targets were not the main focus.
- Russian defaults in this fork are practical, but more opinionated than upstream.
- The goal here is usefulness, not perfect coverage of every board.
