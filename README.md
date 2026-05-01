<div align="center">

<img src=".github/meshtastic_logo.png" alt="Meshtastic logo" width="84" />
<h1>Meshtastic Pager OS</h1>

<p><strong>Standalone pager-style firmware fork for Heltec V4, built on top of the Meshtastic radio stack.</strong></p>

<p>
  <a href="https://chemobook.github.io/meshtastic-pager-mode/">Web Flasher</a>
  ·
  <a href="release-work/README.md">Firmware files</a>
</p>

</div>

![Pager OS field illustration](docs/pager-mode/assets/pager-mode-banner.svg)

## English

`Meshtastic Pager OS` is an unofficial Meshtastic fork focused on one job: receive text over LoRa and show it on a small OLED like a simple work pager.

This project keeps the Meshtastic radio stack and BLE configuration through the official mobile app, but removes the usual device-side carousel and menu-heavy workflow. The device is treated as a pager: wake on message, show text clearly, confirm with a button, return to low power.

Core behavior:

- target board: `Heltec V4`
- incoming text wakes the screen
- unread messages stay local until confirmed by button
- short press wakes or confirms
- long press clears local pager history
- white LED reminds about unread messages

[Open Pager OS Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/)

This is not an official Meshtastic release. Real-device testing still matters.

---

## Русский

`Meshtastic Pager OS` — это неофициальный форк Meshtastic, который сфокусирован на одной задаче: принимать текст по LoRa и показывать его на маленьком OLED как простой рабочий пейджер.

Прошивка сохраняет радиостек Meshtastic и BLE-настройку через официальное мобильное приложение, но убирает обычную карусель экранов и сценарий постоянной навигации по устройству. Устройство работает как пейджер: просыпается на сообщение, понятно показывает текст, подтверждается кнопкой и возвращается в экономичный режим.

Основная логика:

- основная целевая плата: `Heltec V4`
- входящее сообщение будит экран
- непрочитанные сообщения остаются локально до подтверждения кнопкой
- короткое нажатие будит экран или подтверждает сообщение
- долгое удержание очищает локальную историю пейджера
- белый LED напоминает о непрочитанных сообщениях

[Открыть Pager OS Web Flasher](https://chemobook.github.io/meshtastic-pager-mode/)

Это не официальный релиз Meshtastic. Проверка на реальном устройстве всё ещё обязательна.
