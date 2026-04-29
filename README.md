<div align="center" markdown="1">

<img src=".github/meshtastic_logo.png" alt="Meshtastic Logo" width="80"/>
<h1>Meshtastic Firmware</h1>

![GitHub release downloads](https://img.shields.io/github/downloads/meshtastic/firmware/total)
[![CI](https://img.shields.io/github/actions/workflow/status/meshtastic/firmware/main_matrix.yml?branch=master&label=actions&logo=github&color=yellow)](https://github.com/meshtastic/firmware/actions/workflows/ci.yml)
[![CLA assistant](https://cla-assistant.io/readme/badge/meshtastic/firmware)](https://cla-assistant.io/meshtastic/firmware)
[![Fiscal Contributors](https://opencollective.com/meshtastic/tiers/badge.svg?label=Fiscal%20Contributors&color=deeppink)](https://opencollective.com/meshtastic/)
[![Vercel](https://img.shields.io/static/v1?label=Powered%20by&message=Vercel&style=flat&logo=vercel&color=000000)](https://vercel.com?utm_source=meshtastic&utm_campaign=oss)

<a href="https://trendshift.io/repositories/5524" target="_blank"><img src="https://trendshift.io/api/badge/repositories/5524" alt="meshtastic%2Ffirmware | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>

</div>

</div>

<div align="center">
	<a href="https://meshtastic.org">Website</a>
	-
	<a href="https://meshtastic.org/docs/">Documentation</a>
</div>

## Fork Notice

This tree currently contains a custom Meshtastic firmware fork focused on a small-screen `Pager Mode` workflow for OLED and e-ink devices.

- This is an unofficial community fork created by an interested hobbyist with AI-assisted development.
- It is shared in good faith, primarily for personal use and experimentation, with no claim over upstream Meshtastic itself.
- Use it freely, adapt it if it helps, and treat it as an `as-is` project that may still require device-specific testing and debugging.
- Upstream Meshtastic documentation and build instructions still apply.
- Fork-specific behavior, supported targets, Russian text support, and publishing notes are documented in [docs/pager-mode/README.md](docs/pager-mode/README.md).
- Russian documentation for this fork is available in [docs/pager-mode/README.ru.md](docs/pager-mode/README.ru.md).
- Large TFT-focused UI targets were intentionally left mostly untouched.

## For Users

Most people should **not** need to install Visual Studio Code or build this fork from source.

The recommended workflow for end users is:

1. Open the repository `Releases` page.
2. Find the release that matches your hardware family.
3. Download the prebuilt firmware binary for your exact board.
4. Flash it using the normal Meshtastic firmware flashing workflow for that device family.

If no ready-made binary exists for your board yet, then source builds are the fallback path.

- English fork notes: [docs/pager-mode/README.md](docs/pager-mode/README.md)
- Russian fork notes: [docs/pager-mode/README.ru.md](docs/pager-mode/README.ru.md)

## Overview

This repository contains the official device firmware for Meshtastic, an open-source LoRa mesh networking project designed for long-range, low-power communication without relying on internet or cellular infrastructure. The firmware supports various hardware platforms, including ESP32, nRF52, RP2040/RP2350, and Linux-based devices.

Meshtastic enables text messaging, location sharing, and telemetry over a decentralized mesh network, making it ideal for outdoor adventures, emergency preparedness, and remote operations.

### Get Started

- 🔧 **[Building Instructions](https://meshtastic.org/docs/development/firmware/build)** – Learn how to compile the firmware from source.
- ⚡ **[Flashing Instructions](https://meshtastic.org/docs/getting-started/flashing-firmware/)** – Install or update the firmware on your device.

Join our community and help improve Meshtastic! 🚀

## Stats

![Alt](https://repobeats.axiom.co/api/embed/8025e56c482ec63541593cc5bd322c19d5c0bdcf.svg "Repobeats analytics image")
