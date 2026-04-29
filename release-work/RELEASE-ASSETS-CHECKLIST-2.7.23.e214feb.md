# GitHub Release Assets Checklist `2.7.23.e214feb`

Use this checklist when publishing the GitHub release for this fork.

Используй этот список при публикации GitHub Release для этого форка.

## Heltec V3

Source folder:

- [release-work/firmware/heltec-v3](</Users/chemobookche/Мой диск/github/meshtastic-pager-mode/release-work/firmware/heltec-v3>)

Attach these files:

- `firmware-heltec-v3-2.7.23.e214feb.factory.bin`
- `firmware-heltec-v3-2.7.23.e214feb.bin`
- `firmware-heltec-v3-2.7.23.e214feb.mt.json`
- `littlefs-heltec-v3-2.7.23.e214feb.bin`
- `bootloader.bin`
- `partitions.bin`
- `mt-esp32s3-ota.bin`

Recommended note:

- `factory.bin` for first full install
- regular `.bin` for update flow

## Heltec V4

Source folder:

- [release-work/firmware/heltec-v4](</Users/chemobookche/Мой диск/github/meshtastic-pager-mode/release-work/firmware/heltec-v4>)

Attach these files:

- `firmware-heltec-v4-2.7.23.e214feb.factory.bin`
- `firmware-heltec-v4-2.7.23.e214feb.bin`
- `firmware-heltec-v4-2.7.23.e214feb.mt.json`
- `littlefs-heltec-v4-2.7.23.e214feb.bin`
- `bootloader.bin`
- `partitions.bin`
- `mt-esp32s3-ota.bin`

Recommended note:

- `factory.bin` for first full install
- regular `.bin` for update flow

## Minimal Release Option

If you want the release page to stay cleaner, the minimum practical set per board is:

- `firmware-<env>-2.7.23.e214feb.factory.bin`
- `firmware-<env>-2.7.23.e214feb.bin`
- `firmware-<env>-2.7.23.e214feb.mt.json`
- `littlefs-<env>-2.7.23.e214feb.bin`
- `mt-esp32s3-ota.bin`

## Safer Full Release Option

If you want fewer support questions later, publish the full per-board set:

- `factory.bin`
- normal `bin`
- `.mt.json`
- `littlefs`
- `bootloader.bin`
- `partitions.bin`
- `mt-esp32s3-ota.bin`

## Suggested Asset Grouping On GitHub

Recommended upload order:

1. `Heltec V3`
2. `Heltec V4`
3. optional docs or notes

Recommended naming style in the release text:

- `Heltec V3 package`
- `Heltec V4 package`

## Companion files

Use together with:

- [RELEASE-NOTES-2.7.23.e214feb.md](</Users/chemobookche/Мой диск/github/meshtastic-pager-mode/release-work/RELEASE-NOTES-2.7.23.e214feb.md>)
- [RELEASE-FORM-COMPACT-2.7.23.e214feb.md](</Users/chemobookche/Мой диск/github/meshtastic-pager-mode/release-work/RELEASE-FORM-COMPACT-2.7.23.e214feb.md>)
