# Meshtastic Pager OS

![Pager OS concept art](assets/pager-mode-banner.svg)

`Meshtastic Pager OS` is a standalone pager-style firmware direction built on top of the Meshtastic codebase. The goal is not to preserve the old device UI. The goal is to turn a Heltec V4 into a small, reliable message receiver that behaves like a pager.

## Project status

- Base platform: Meshtastic firmware fork
- Main target: `heltec-v4`
- Configuration path: official mobile app over BLE
- Device-side UI scope: reduced to pager behavior

This project is maintained as community work without commercial backing. A substantial part of the implementation and documentation was done with AI assistance because the maintainer works outside embedded development.

## Why this exists

Some users do not need a pocket radio with many local screens. They need a clipped-on device that:

- waits quietly
- wakes on incoming text
- shows the message clearly
- goes back to low-power behavior

Typical use cases:

- field technicians
- climbers and riggers
- airsoft and training events
- hiking and outdoor groups
- rough work conditions where a simple pager is better than a busy handheld UI

The general idea is simple: do not complicate what already works.

## Display layout

The OLED is divided into three fixed zones:

1. Header
Battery status and current time.

2. Center
Large horizontally scrolling message text.

3. Lower zone
Used only for pager-specific surfaces when needed by the message flow.

The center area is the priority. It should be readable quickly, even when the device is clipped to clothing or gear.

![Pager OS layout](assets/pager-mode-overview.svg)

## Message handling

Current pager behavior is based on a strict queue model:

- Incoming message wakes the screen
- Message text scrolls in the center area
- If another message arrives while the screen is already active, the new message is shown next and the active timer is refreshed
- Unread messages stay in the local pager queue until the user confirms them with the button
- Local message history is intentionally temporary and can be cleared completely

The device is not meant to be an archive. If users want long-term history, they can keep it in the mobile app.

## Button behavior

- Short press on a sleeping screen wakes the screen and opens unread message review
- Additional short presses confirm the current message and move backward through unread history
- Long press clears all locally stored pager messages

The button is used as a quick acknowledgement tool, not as a menu navigation system.

## LED behavior

- White LED blinks while unread messages exist
- Blinking is faster during the initial alert window
- Blinking slows down later to save power

The LED is a quiet reminder that something still needs to be checked.

## What remains compatible

- BLE pairing and configuration through the standard Meshtastic app
- Channel traffic
- Direct messages
- Existing provisioning and flashing workflow

## What is intentionally removed from the UX

- standard OLED screen carousel
- rich device-side navigation
- on-device settings as a primary workflow

This fork is intentionally narrow. It is not trying to improve every upstream scenario.

## Flashing from the browser

Preferred user workflow:

1. Open the [Pager OS Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/)
2. Use desktop Chrome or Edge
3. Choose `Heltec V4`
4. Flash directly from the browser
5. Wait for reboot

If the board is not detected:

- replace the USB cable first
- close any serial monitor or terminal tool
- try another USB port

## Build locally

```bash
pio run -e heltec-v4
```

Package the build into the release-style folder:

```bash
./bin/pager-package.sh heltec-v4
```

The packaged files are placed in:

- [../../release-work/firmware/heltec-v4](../../release-work/firmware/heltec-v4)

## Practical notes

- This is not an official Meshtastic release
- Real device testing still matters more than simulator assumptions
- The active product direction is `Pager OS`, even if some old paths in the repository still mention `pager-mode`
