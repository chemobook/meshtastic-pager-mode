# Changelog

## 2.7.23-pager.1

Initial public pager-mode fork based on Meshtastic `2.7.23`.

### Added

- Pager mode entry from message actions on the classic small-screen UI
- Pager mode entry for supported `InkHUD` applets

### Changed

- Pager rendering now prioritizes message body readability over sender metadata
- Long messages in classic pager view use vertical scrolling
- Pager mode header is left blank to keep battery/time indicators clear on small displays
- Pager mode text autoscroll is faster
- Unread message icon was removed from the classic small-screen header
- Pager mode no longer survives reboot; devices now come back to the normal start screen
- Long press in pager mode now opens the message action menu instead of forcing an immediate exit
- Short press in pager mode no longer kicks the user out of the focused thread view
- Matching pager-mode messages no longer wake the screen and reset the timeout if the display is already off
- Russian text rendering is enabled for the small-screen fork build flavor
- `InkHUD` font selection now respects local language encoding macros

### Scope

- Targeted at OLED and e-ink small-screen devices
- Large TFT-oriented UI flows intentionally left close to upstream behavior

### Notes

- This is a fork-specific release line, not an upstream Meshtastic release
