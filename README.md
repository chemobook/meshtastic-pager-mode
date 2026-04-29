<div align="center">

<img src=".github/meshtastic_logo.png" alt="Meshtastic logo" width="88" />
<h1>Meshtastic Pager Mode Fork</h1>

<p><strong>Community-made fork for small screens, created with care, curiosity, and a lot of AI-assisted work.</strong></p>

<p>
  <a href="#english">English</a>
  ·
  <a href="#русский">Русский</a>
  ·
  <a href="docs/pager-mode/README.md">Detailed EN guide</a>
  ·
  <a href="docs/pager-mode/README.ru.md">Подробный RU гайд</a>
</p>

![GitHub release downloads](https://img.shields.io/github/downloads/meshtastic/firmware/total)
[![CI](https://img.shields.io/github/actions/workflow/status/meshtastic/firmware/main_matrix.yml?branch=master&label=actions&logo=github&color=yellow)](https://github.com/meshtastic/firmware/actions/workflows/ci.yml)
[![CLA assistant](https://cla-assistant.io/readme/badge/meshtastic/firmware)](https://cla-assistant.io/meshtastic/firmware)

</div>

![Pager Mode banner](docs/pager-mode/assets/pager-mode-banner.svg)

## English

This repository is an **unofficial fork** of the Meshtastic firmware focused on a cleaner **Pager Mode** experience for compact devices such as **Heltec V3**, **Heltec V4**, and other small-screen or e-ink targets.

It was made by interested people for other people:

- no venture funding
- no hidden commercial agenda
- no financial motivation
- just a practical community fork shared in case it helps someone

An important note about authorship: a large part of the implementation and documentation in this fork was created with **AI assistance**. That is intentional. The maintainer works in a different professional field, and AI made it possible to turn an idea into a usable firmware fork without pretending to be a full-time embedded firmware engineer.

### What this fork is

- A fork of upstream Meshtastic, not a replacement for it
- A hobby/community branch built in good faith
- A small-screen-first firmware direction
- A place where readability and message focus matter more than feature sprawl

### What this fork changes

- Adds and refines `Pager Mode` for compact displays
- Keeps message reading simple and foregrounded
- Preserves as much upstream Meshtastic behavior as possible
- Enables Russian-friendly small-screen usage in this forked flavor

![Pager Mode overview](docs/pager-mode/assets/pager-mode-overview.svg)

### Ready firmware

Ready firmware packages for this workspace are collected in [release-work/README.md](release-work/README.md) after local builds.

Current prepared targets:

- `heltec-v3`
- `heltec-v4`

### Build it yourself

If you want your own build, the short path is:

```bash
pio run -e heltec-v3
pio run -e heltec-v4
```

If you want packaged release-style artifacts in one place:

```bash
./bin/pager-package.sh heltec-v3 heltec-v4
```

If you want a friendlier flashing helper for this fork:

```bash
./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX
```

### Why the README is so explicit

Because users deserve honesty:

- this is a fork
- this is community work
- this is not an official Meshtastic release
- some parts were heavily AI-assisted
- real-device testing still matters

For full English notes, screenshots, build hints, and release workflow, see [docs/pager-mode/README.md](docs/pager-mode/README.md).

---

## Русский

Этот репозиторий — **неофициальный форк** прошивки Meshtastic, сделанный с упором на более удобный **Pager Mode** для компактных устройств вроде **Heltec V3**, **Heltec V4** и других small-screen / e-ink плат.

Этот проект появился не ради бизнеса, а по-человечески:

- без инвесторов
- без монетизации
- без финансовой выгоды
- просто как полезный community fork для других людей

Важно честно сказать и про разработку: значительная часть кода и документации в этом форке была создана с помощью **искусственного интеллекта**. Это не попытка что-то скрыть, а нормальный рабочий подход. Я сам работаю в другой области, и именно AI помог довести идею до рабочего состояния.

### Что это за проект

- Это форк upstream Meshtastic, а не отдельная замена оригиналу
- Это любительская и общественная работа
- Это ветка с фокусом на маленькие экраны
- Это попытка сделать чтение сообщений удобнее и спокойнее

### Что меняет форк

- Добавляет и дорабатывает `Pager Mode` для компактных экранов
- Делает чтение сообщений более простым и заметным
- Старается сохранить максимум совместимости с upstream
- В этом варианте сборки уделяет внимание русскому small-screen использованию

### Готовые прошивки

Готовые локально собранные артефакты складываются в [release-work/README.md](release-work/README.md).

Подготовленные цели:

- `heltec-v3`
- `heltec-v4`

### Как собрать самому

Быстрый путь:

```bash
pio run -e heltec-v3
pio run -e heltec-v4
```

Если хотите собрать и сразу разложить файлы по удобным папкам:

```bash
./bin/pager-package.sh heltec-v3 heltec-v4
```

Если хотите прошивать через более дружелюбный форковый скрипт:

```bash
./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX
```

### Почему README такой подробный

Потому что пользователю лучше сразу сказать правду:

- это форк
- это некоммерческая работа
- это не официальный релиз Meshtastic
- AI здесь действительно много помогал
- проверка на реальном железе всё равно важна

Подробная русская документация находится в [docs/pager-mode/README.ru.md](docs/pager-mode/README.ru.md).
