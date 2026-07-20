# Changelog

All notable changes to this project are documented in this file.

The format follows a simple Keep a Changelog style, and stable releases use SemVer.

## [v1.0.1] - 2026-07-20

### Changed
- Rewrote the public README in English with a clearer product description.
- Added styled stack badges and a technology table.
- Documented that the workflow tracks car fuel fill-ups, with `HB20` as the default vehicle rule.
- Expanded the workflow logic, conversation state, AI usage, and hosting model sections.
- Renamed the versioning documentation to `docs/versioning.md`.

### Removed
- Removed internal contribution and assistant instruction files from the public repository.

## [v1.0.0] - 2026-07-20

### Added
- Sanitized n8n workflow for personal fuel tracking through Telegram.
- Minimal SQLite schema with `abastecimentos` and `abastecimentos_pendentes`.
- Initial documentation for usage, safety, versioning, and rollback.
- Initial release dossier in `docs/releases/v1.0.0.md`.

### Security
- Kept the original n8n export outside version control.
- Removed credentials, webhook IDs, and instance metadata from the public JSON.
- Added `.gitignore` rules to avoid publishing real databases, original exports, backups, logs, `.env`, credentials, and secrets.
