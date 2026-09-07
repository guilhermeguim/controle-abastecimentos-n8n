# Changelog

All notable changes to this project are documented in this file.

The format follows a simple Keep a Changelog style, and stable releases use SemVer.

## [v1.1.0] - 2026-09-07

MINOR release. This update adds access controls and input validation while preserving the main fuel-log flow and database schema. The authorized sender must be configured after import. Local checks passed; n8n import and end-to-end execution were not performed during release preparation.

### Added
- Telegram sender authorization before normalization, SQLite access, and AI calls.
- Non-empty text routing and a text-only notice for unsupported messages from the authorized sender.
- Release notes with upgrade instructions and runtime checks in `docs/releases/v1.1.0.md`.

### Changed
- Updated the public workflow from 24 to 27 nodes and preserved the new canvas layout.
- Restricted the extraction schema with date format/pattern, fuel enumeration, positive liters and amounts, non-negative integer odometer, and text length limits.
- Expanded extraction guidance for relative dates, existing pending values, numeric formatting, and fuel normalization.
- Added deterministic normalization of `Etanol`, `álcool`, and `alcool` to `etanol` before required-field checks.
- Shortened the unrecognized-message response to `Não entendi a solicitação.`.

### Security
- Unmatched Telegram senders stop at the authorization node without a workflow response.
- Replaced the private authorized sender ID with `REPLACE_WITH_TELEGRAM_USER_ID`; importers must configure it before use.
- Cleared pinned Telegram execution data and exported the public workflow with `active: false`.
- Removed credential references, webhook IDs, and workflow/instance metadata from the refreshed export.

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
