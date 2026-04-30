# Meshtastic Pager Mode Fork `2.7.23.e214feb`

## English

Community release for the **Meshtastic Pager Mode Fork**.

This is an **unofficial fork** of Meshtastic, created by interested people without financial motivation and shared simply because it may be useful to others.

A large part of this fork was built with **AI assistance**. That is intentional and openly stated: the maintainer works in a different field, and AI helped turn the idea into a usable firmware branch.

### Included targets

- `heltec-v3`
- `heltec-v4`

### Web flasher

- Browser install page: [Pager Mode Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/)
- Currently exposed boards: `heltec-v3`, `heltec-v4`
- Release packages:
  [Heltec V3](https://github.com/chemobook/meshtastic-pager-mode/tree/main/release-work/firmware/heltec-v3)
  and
  [Heltec V4](https://github.com/chemobook/meshtastic-pager-mode/tree/main/release-work/firmware/heltec-v4)

### Main fork features

- Pager-style message reading for compact screens
- Small-screen-first focus
- Better long-message readability
- Reduced unnecessary battery drain while pager mode is active on busy networks
- Pager mode header is simplified to leave more room for battery and time on small displays
- Pager mode now restores its focused session after reboot
- Long press now opens message actions instead of forcing an immediate pager-mode exit
- Pager-mode autoscroll now stays below the header without introducing blank gaps between lines
- Russian-friendly small-screen flavor in this fork
- Minimal-fork mindset to keep future upstream rebases more realistic

### Included files

For each board package you will find:

- `firmware-<env>-2.7.23.e214feb.bin`
- `firmware-<env>-2.7.23.e214feb.factory.bin`
- `firmware-<env>-2.7.23.e214feb.mt.json`
- `latest.mt.json`
- `web-installer.json`
- `littlefs-<env>-2.7.23.e214feb.bin`
- `bootloader.bin`
- `partitions.bin`
- `mt-esp32s3-ota.bin`
- `BUILD-INFO.txt`

### Flashing notes

- Use desktop Chrome or Edge for the browser flasher.
- Use the package that matches your exact board.
- `factory.bin` is the safer choice for first full installs.
- `bin` is the normal update image.
- If the board is not detected, first replace the USB cable and close other serial tools.
- If Windows still does not see the board, install the driver from the [official Meshtastic ESP32 serial driver guide](https://meshtastic.org/docs/getting-started/serial-drivers/esp32/).
- This fork also includes a helper script:

```bash
./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX
```

### Important note

This is not an official Meshtastic release. Please treat it as a community fork and test on real hardware before depending on it in important situations.

### Known limitations

- Focus is on small-screen devices, not large TFT-first layouts
- Real-device testing still matters
- Testing is still ongoing, especially around pager-mode power behavior on real devices
- Some upstream warnings remain during build, but both packaged targets build successfully

---

## Русский

Community-релиз для **Meshtastic Pager Mode Fork**.

Это **неофициальный форк** Meshtastic, созданный заинтересованными людьми без какой-либо финансовой выгоды и выложенный просто потому, что он может пригодиться другим.

Значительная часть этого форка была сделана с помощью **искусственного интеллекта**. Это сказано честно и специально: автор проекта работает в другой области, а AI помог превратить идею в рабочую ветку прошивки.

### Какие цели входят в релиз

- `heltec-v3`
- `heltec-v4`

### Веб-прошивальщик

- Страница для прошивки из браузера: [Pager Mode Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/)
- Сейчас на ней доступны только `heltec-v3` и `heltec-v4`
- Пакеты релиза:
  [Heltec V3](https://github.com/chemobook/meshtastic-pager-mode/tree/main/release-work/firmware/heltec-v3)
  и
  [Heltec V4](https://github.com/chemobook/meshtastic-pager-mode/tree/main/release-work/firmware/heltec-v4)

### Что главное в этом форке

- Pager-режим для чтения сообщений на компактных экранах
- Фокус на small-screen устройствах
- Более удобное чтение длинных сообщений
- Уменьшен лишний расход батареи в pager mode на шумных сетях
- Верхняя строка pager mode упрощена, чтобы освободить место под заряд и время
- Pager mode теперь восстанавливает активную pager-сессию после перезагрузки
- Длинное нажатие теперь открывает действия сообщения, а не выключает pager mode сразу
- Автопрокрутка pager mode теперь не залезает в шапку и не создает пустые провалы между строками
- Более дружелюбный вариант для русского small-screen использования
- Минимально-инвазивный подход, чтобы потом было проще подтягивать upstream

### Какие файлы входят

Для каждой платы подготовлены:

- `firmware-<env>-2.7.23.e214feb.bin`
- `firmware-<env>-2.7.23.e214feb.factory.bin`
- `firmware-<env>-2.7.23.e214feb.mt.json`
- `latest.mt.json`
- `web-installer.json`
- `littlefs-<env>-2.7.23.e214feb.bin`
- `bootloader.bin`
- `partitions.bin`
- `mt-esp32s3-ota.bin`
- `BUILD-INFO.txt`

### Замечания по прошивке

- Для веб-прошивки лучше использовать настольный Chrome или Edge.
- Выбирайте пакет строго под свою плату.
- `factory.bin` удобнее использовать для первой полной прошивки.
- Обычный `bin` подходит для update-сценария.
- Если плата не определяется, сначала замените USB-кабель и закройте другие serial-программы.
- Если Windows всё ещё не видит устройство, поставьте драйвер из [официальной инструкции Meshtastic для ESP32](https://meshtastic.org/docs/getting-started/serial-drivers/esp32/).
- В форке есть helper-скрипт:

```bash
./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX
```

### Важная пометка

Это не официальный релиз Meshtastic. Лучше воспринимать его как community fork и обязательно проверять работу на реальном железе, прежде чем полагаться на него в важных сценариях.

### Известные ограничения

- Основной фокус на маленьких экранах, а не на больших TFT-интерфейсах
- Проверка на реальных устройствах всё ещё обязательна
- Тестирование всё ещё продолжается, особенно вокруг энергопотребления pager mode на реальном железе
- Во время сборки остаются некоторые upstream warning’и, но обе подготовленные цели успешно собираются
