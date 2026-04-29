# Meshtastic Pager Mode Fork

> Unofficial small-screen Meshtastic fork for people who prefer a simple pager-style message view.

This fork adds a small-screen-first `Pager Mode` to Meshtastic firmware with intentionally small and localized changes, so the branch can be rebased onto newer upstream firmware versions more easily.

## Project Note

This project was created by an interested user with AI-assisted development.

- It is not an official Meshtastic release.
- It does not claim ownership over upstream Meshtastic work.
- It was built mainly for personal use and then shared in case it helps someone else.
- Feel free to use it, modify it, or build on it.
- If something does not work on your hardware, please treat it as a community fork and investigate accordingly.

## Language

- English: this file
- Russian: [README.ru.md](README.ru.md)

## What This Fork Changes

- Adds `Pager Mode` to message actions for the classic small-screen UI.
- Adds the same pager toggle flow to `InkHUD` on supported e-ink devices.
- Locks the device onto the currently selected DM or channel thread while pager mode is active.
- Exits pager mode with a long button press instead of normal short navigation.
- Persists pager mode across reboot.
- Simplifies pager rendering so the active screen focuses on message body text instead of sender metadata.
- Improves large-message readability in pager view with bigger fallback text and vertical scrolling.
- Enables Russian small-screen text rendering in this fork build flavor.

## Intended Devices

This fork is meant for small displays only:

- OLED-based Meshtastic devices using the classic screen UI
- E-ink devices using `InkHUD`

Large TFT-centric layouts were intentionally not the target of this fork.

## Pager Mode Behavior

### Classic Small-Screen UI

1. Open a DM or channel message thread.
2. Open `Message Action`.
3. Select `Enable Pager Mode`.
4. The device stays on the selected thread and stops reacting to normal short button navigation.
5. Long-press the main button to exit pager mode.

### InkHUD

1. Open the relevant DM or channel applet.
2. Open the menu and enable pager mode.
3. The active thread remains foreground and autoshow from other threads is suppressed.
4. Long-press exits pager mode.

## Russian Text Support

This fork enables Russian support by default for the small-screen build flavor:

- Classic OLED UI uses `OLED_RU`.
- `InkHUD` variants use local font selection macros that switch to `Win1251` when Russian is enabled.

If you want to maintain multiple language-specific releases, the cleanest follow-up is to move the Russian default from the global fork config into separate build flavors or dedicated release branches.

## Current Implementation Notes

- The classic pager renderer favors larger text and uses vertical scrolling when the active message is long.
- `InkHUD` pager mode currently keeps changes intentionally small and close to existing applet behavior.
- DM pager mode in `InkHUD` is bound to the currently selected sender rather than introducing a new full DM-thread subsystem.

## Why It Exists

The goal of this fork is modest:

- keep small-screen messaging readable
- avoid broad UI rewrites
- preserve as much upstream behavior as possible
- make future updates from upstream less painful

## Recommended Build Targets

Examples:

```bash
pio run -e heltec-v3
pio run -e heltec-wireless-paper-inkhud
pio run -e t-echo-inkhud
```

Use the target that matches the actual hardware variant you plan to flash.

## How Users Should Get Firmware

For most users, the best path is **prebuilt releases**, not local compilation.

### Recommended End-User Flow

1. Open the repository `Releases` page on GitHub.
2. Find the release note that mentions your board.
3. Download the correct firmware file for your exact target.
4. Flash it the same way you would flash normal Meshtastic firmware for that board.

### Typical Release Artifacts

Depending on the target, attach files like:

- `firmware-<env>-<version>.bin`
- `firmware-<env>-<version>.factory.bin` for ESP32 first installs
- any target-specific files needed by the board family

### When Users Need To Build From Source

Building from source is only needed when:

- there is no published binary for the target board
- the user wants to modify the fork
- the user is testing a development branch instead of a tagged release

### Maintainer Recommendation

If you want this fork to be easy for other people to use, publish GitHub Releases with ready-made binaries for the boards you personally tested.

That way, most users can simply:

- download
- flash
- test

without installing Visual Studio Code, PlatformIO, or the full toolchain.

## Repository Layout For Publishing

Recommended GitHub presentation:

- Keep the upstream Meshtastic tree intact.
- Document fork-specific behavior in `docs/pager-mode/`.
- Use a branch name such as `pager-mode-small-screens`.
- Keep pager changes and locale changes in separate commits if you later rebuild history from a clean upstream clone.

## Recommended GitHub Workflow

1. Create a GitHub fork or a new repo for this custom firmware branch.
2. Push this work on a branch such as `pager-mode-small-screens`.
3. In the repository description, clearly state that this is a Meshtastic fork for small-screen pager workflows.
4. In releases, mention:
   - supported boards
   - pager mode behavior
   - Russian text support
   - known limitations
5. When upstream Meshtastic updates, rebase or re-apply only the pager-specific patches instead of diverging broadly.

## Suggested Release Notes Template

```text
Meshtastic Pager Mode fork

- Adds pager mode for small-screen devices
- Supports OLED and InkHUD e-ink targets
- Persists pager mode across reboot
- Long press exits pager mode
- Russian text rendering enabled for this build flavor
```

## Known Limitations

- Large TFT targets are not specially adapted in this fork.
- The Russian locale is enabled as a fork default, which is practical for this build but may be too opinionated for upstream.
- `InkHUD` pager rendering was kept deliberately close to the original structure to reduce merge pain later.
- This remains a hobby/community fork, so some edge cases may still need manual testing on real devices.
