# Changelog - EchoPulse

## [02/04/2026] v2.3.1

- Bugfix: Corregido un fallo donde los mensajes destinados a la Hermandad ("g") fallaban silenciosamente debido a una validación estricta de variables `nil` en la API moderna de chat (C_ChatInfo/SendChatMessage).

## [09/03/2026] v2.3.0

- Added Smart Spamming features: Auto-pause in combat, in instances, and while AFK.
- Added intelligent zone restriction: Option to only send messages while in Capital Cities (Sanctuary/Inn).
- Added Anti-Spam (Humanization) feature: Random time variance to message delays to mimic human behavior.

## [24/02/2026] v2.2.0

- Integrated internal message queuing logic.
- Removed dependency on `MessageQueue` addon.
- The addon is now fully independent.

## [24/02/2026] v2.1.1

- Complete rebranding: Addon renamed from AutoFlood to EchoPulse.
- Chat commands changed from `/flood` to `/pulse`.
- Internal code and files renamed to reflect the new identity.

## v2.0.0

- Major redesign: Multi-message support with independent timers.
- New graphical user interface (GUI) in the Interface Options menu.
- Added Full Spanish localization.
- Automatic data migration from previous versions.
- `/pulseconfig` command to open the new settings panel.

## v1.7.0

- Multi-channel support: you can now send messages to multiple channels at once.
- `/floodchan <channel>` now toggles the channel (adds it to the list or removes it).
- `/floodinfo` now displays all active channels.

## v1.6.1

- TOC bump for WoW Midnight 12.0.1 prepatch.

## v1.6.0

- TOC bump for WoW Midnight 12.0.0 prepatch.
- Added TBC classic support.

## v1.5.2

- Updated for WoW retail patch 11.2.

## v1.5.1

- Added add-on category.
- TOC bump for WoW Retail 11.1.0, WoW Classic 4.4.2 and WoW Classic Era 1.15.6.

## v1.5.0

- Updated for WoW Retail patch 10.2.7.
- Updated for WoW Cataclysm Classic patch 4.4.0.
- Updated for WoW Classic patch 1.15.2.

## v1.4.6

- Updated for WoW patch 10.1.7 and WoW Classic patch 1.14.4.

## v1.4.5

- Updated for WoW patch 10.1.

## v1.4.4

- TOC bump for WoW patch 10.0.7.

## v1.4.3

- TOC bump for WoW patch 10.0.5.
- TOC bump for WoW Classic patch 3.4.1.

## v1.4.2

- TOC bump for WoW patch 10.0.2.

## v1.4.1

- TOC bump for WoW patch 10.0.0.

## v1.4.0

- Configuration is now saved character-wide instead of account-wide. #3
- Wait for the current message to be actually sent before sending the next one. #4
- Added support for instance chat (/i).
- Improved channel setting.

## v1.3.3

- Added support for Wrath of the Lich King Classic.
- Updated for WoW Retail patch 9.2.7.

## v1.3.2

- TOC bump for WoW 9.2, WoW BC Classic 2.5.3 and WoW Classic 1.14.2.

## v1.3.1

- TOC bump for WoW 9.1.5.

## v1.3.0

- Created TOCs for WoW Retail, Classic and Burning Crusade Classic.

## v1.2.4

- Updated TOC for WoW patch 9.0.5

## v1.2.3

- Updated TOC for WoW patch 9.0.2

## v1.2.2

- Updated for WoW Shadowlands 9.0.1 prepatch

## v1.2.1

- Rewritten to use MessageQueue

## v1.2.0

- Fixed initialization issue (at last!)

## v1.1

- Fixed minor onEvent function bug

## v1.0

- Initial release
