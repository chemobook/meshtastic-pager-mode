# Ready Firmware / Готовые прошивки

This folder is the local export area for release-style artifacts built from this fork.

Эта папка используется как локальная зона выгрузки готовых артефактов, собранных из этого форка.

## Release text / Текст релиза

Ready-to-paste GitHub release notes for the current packaged build:

- [RELEASE-NOTES-2.7.23.e214feb.md](RELEASE-NOTES-2.7.23.e214feb.md)
- [RELEASE-FORM-COMPACT-2.7.23.e214feb.md](RELEASE-FORM-COMPACT-2.7.23.e214feb.md)
- [RELEASE-ASSETS-CHECKLIST-2.7.23.e214feb.md](RELEASE-ASSETS-CHECKLIST-2.7.23.e214feb.md)

## Web flasher / Веб-прошивальщик

Browser install page:

- [Pager Mode Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/)

Supported boards on the web flasher:

- `heltec-v3`
- `heltec-v4`

## Expected targets / Ожидаемые цели

- `heltec-v3`
- `heltec-v4`

## How the files appear here / Как файлы попадают сюда

Run:

```bash
./bin/pager-package.sh heltec-v3 heltec-v4
```

That script copies the newest build outputs from `.pio/build/<env>/` into:

- `release-work/firmware/heltec-v3/`
- `release-work/firmware/heltec-v4/`

It also downloads `mt-esp32s3-ota.bin` when the packaged folder needs it for factory flashing with `device-install.sh` or `pager-flash.sh`.

## Typical contents / Что здесь обычно лежит

- `firmware-<env>-<version>.bin`
- `firmware-<env>-<version>.factory.bin`
- `firmware-<env>-<version>.mt.json`
- `littlefs-<env>-<version>.bin`
- `bootloader.bin`
- `partitions.bin`
- `mt-esp32s3-ota.bin`

## Flash helper / Помощник для прошивки

Examples:

```bash
./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX
```
