# Fuel Log n8n

[![n8n](https://img.shields.io/badge/n8n-Community_Edition-FF6D5A.svg?style=flat-square&logo=n8n)](https://n8n.io/)
[![Telegram](https://img.shields.io/badge/Telegram-Bot_API-26A5E4.svg?style=flat-square&logo=telegram)](https://core.telegram.org/bots/api)
[![Groq](https://img.shields.io/badge/Groq-openai%2Fgpt--oss--120b-F55036.svg?style=flat-square)](https://groq.com/)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57.svg?style=flat-square&logo=sqlite)](https://www.sqlite.org/)
[![Docker](https://img.shields.io/badge/Docker-runtime-2496ED.svg?style=flat-square&logo=docker)](https://www.docker.com/)
[![GCP](https://img.shields.io/badge/GCP-VM-4285F4.svg?style=flat-square&logo=googlecloud)](https://cloud.google.com/)
[![Caddy](https://img.shields.io/badge/Caddy-reverse_proxy-1F88C0.svg?style=flat-square)](https://caddyserver.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

A personal n8n workflow for tracking car fuel fill-ups through Telegram messages.

The workflow is built for a personal vehicle log. The default vehicle in the prompt rules is `HB20`, but the workflow also accepts an explicitly informed vehicle name when the user sends one.

## Documentation Index

- **[Versioning and update process](docs/versioning.md):** How to export, sanitize, validate, commit, tag, and release workflow updates.
- **[Database schema](database/schema.sql):** Minimal SQLite schema required by the workflow.
- **[Sanitized workflow](workflow/abastecimentos.sanitized.json):** Public n8n export with instance metadata and credentials removed.
- **[Changelog](CHANGELOG.md):** Published changes by release.
- **[Release notes](docs/releases/v1.0.1.md):** Current release dossier.

## Project Purpose

Keeping a fuel log is useful for cost tracking, consumption estimates, and quick history lookups, but manual spreadsheets are easy to forget and slow to update from a phone.

This workflow turns Telegram into the input interface. The user can send natural messages such as a full fill-up entry, a partial entry, a correction, a cancellation, or a question about previous records. n8n coordinates the conversation, stores confirmed records in SQLite, and uses AI only where language interpretation is useful.

## What It Tracks

The workflow tracks car fuel fill-ups with these fields:

- date;
- vehicle identifier;
- fuel type;
- liters;
- total amount paid;
- price per liter;
- odometer;
- optional notes.

The confirmed records are stored in the `abastecimentos` table. Temporary conversation state is stored in `abastecimentos_pendentes`.

## How The Workflow Works

```text
Telegram message
  -> n8n Telegram Trigger
  -> input normalization
  -> pending conversation lookup in SQLite
  -> message classification
  -> data extraction or deterministic confirmation flow
  -> pending state update or final fuel record insert
  -> Telegram response
```

The workflow supports these main paths:

- new fuel fill-up registration;
- continuation of incomplete entries;
- correction of pending data;
- confirmation before saving;
- final insert into SQLite;
- cancellation of pending entries;
- natural-language queries about the fuel history.

## Conversation Logic

The workflow keeps one pending state per Telegram `chat_id`.

When a message does not include all required fuel fields, the workflow stores the partial data in `abastecimentos_pendentes`, identifies the next missing field, and asks the user for that information. Short follow-up messages are interpreted in the context of the pending field.

When all required fields are available, the workflow asks for confirmation before saving. A confirmed entry is inserted into `abastecimentos`, and the pending state is removed. A cancellation removes only the pending state.

## AI Usage

AI is used for language tasks:

- classifying the user message;
- extracting structured fill-up data from natural language;
- answering natural-language questions about the stored history.

Deterministic workflow logic remains outside the model:

- required-field checks;
- pending-state persistence;
- confirmation and cancellation;
- final database writes;
- price-per-liter calculation;
- SQLite read/write routing.

The query agent is limited to a single SQLite read-only tool that returns recent fuel records. It is instructed not to invent dates, values, odometer readings, liters, or prices.

## Hosting Model

The operating model for this project is intentionally simple:

- n8n Community Edition runs in Docker.
- The container is hosted on a GCP VM.
- Caddy acts as the public reverse proxy and TLS entrypoint.
- Telegram sends updates to the n8n webhook.
- SQLite stores the private fuel data in the runtime environment.
- Groq provides the `openai/gpt-oss-120b` model used by the workflow.

This repository does not include VM automation, Docker Compose, deployment scripts, n8n API import scripts, production backups, or environment files.

## Stack

| Layer | Technology | Purpose |
|---|---|---|
| Automation | n8n Community Edition | Workflow orchestration |
| Chat interface | Telegram Bot API | User input and responses |
| Language model | Groq `openai/gpt-oss-120b` | Classification, extraction, and query responses |
| Database | SQLite | Personal fuel log and pending conversation state |
| n8n extension | `n8n-nodes-sqlite3` | SQLite nodes and query tool |
| Runtime | Docker | n8n container execution |
| Hosting | GCP VM | Private server environment |
| Edge proxy | Caddy | HTTPS and reverse proxy |

## Public Export Safety

The public workflow file is `workflow/abastecimentos.sanitized.json`.

The sanitized export removes:

- all `credentials` blocks;
- all `webhookId` fields;
- root workflow `id`;
- root `versionId`;
- root `meta`;
- `instanceId`;
- apparent secrets found by local scanning.

The original n8n export, real SQLite database, credentials, tokens, logs, backups, Docker volumes, and `.env` files are not versioned.

The sanitized workflow still needs a manual import test in n8n before use.

## Requirements

- n8n Community Edition.
- Telegram bot and n8n Telegram credential.
- Groq account and n8n Groq credential.
- SQLite database available to the n8n runtime.
- Community node `n8n-nodes-sqlite3` installed.
- Tables created from `database/schema.sql`.

## Importing Into n8n

1. Install `n8n-nodes-sqlite3` in the n8n instance.
2. Create a private SQLite database in the runtime environment.
3. Apply `database/schema.sql`.
4. Import `workflow/abastecimentos.sanitized.json`.
5. Reconfigure Telegram, Groq, and SQLite credentials.
6. Review environment-dependent parameters.
7. Manually test the workflow before activating it.

Credentials are not included in this repository.
