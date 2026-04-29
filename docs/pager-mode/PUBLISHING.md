# Publishing Checklist

## Before First Push

1. Make sure the target firmware variants you care about build successfully.
2. Flash and test at least one OLED device and one e-ink device if both are part of the release.
3. Confirm:
   - pager mode can be enabled
   - pager mode survives reboot
   - long press exits pager mode
   - long messages remain readable
   - Russian text renders correctly on the intended target

## GitHub Setup

1. Create a repository or fork on GitHub.
2. Add a short description mentioning `Meshtastic pager mode fork for small screens`.
3. Upload a logo, screenshots, or short demo clip if available.
4. Enable GitHub Pages from `/docs` if you want the browser flasher page to be available over HTTPS.

## First Commit Structure

Suggested split:

1. `pager mode for small-screen ui`
2. `russian small-screen font and encoding support`
3. `docs for pager mode fork`

## Release Artifacts

Typical files to attach from `.pio/build/<env>/`:

- `firmware-<env>-<version>.bin`
- `firmware-<env>-<version>.factory.bin` for ESP32 targets
- `littlefs-<env>-<version>.bin` if you distribute filesystem images

If you use the packaged `release-work/firmware/<env>/` folders, also keep:

- `web-installer.json`
- `latest.mt.json`
- `mt-esp32s3-ota.bin`

## Good README Expectations

A useful GitHub landing page should answer:

- What is this fork?
- Which devices is it for?
- What is pager mode?
- How do I build it?
- What are the known limitations?
- Is it upstream Meshtastic or a custom branch?

## Good Release Notes Expectations

Each release should include:

- firmware base version
- affected boards
- user-visible changes
- flashing notes
- known issues
- web flasher link if a browser install page is available
