# Workflow Versioning

## Goal

This repository versions the logic and documentation of the n8n fuel tracking workflow. It is not a full backup of the n8n instance.

Git is used to track the sanitized workflow export, the SQLite schema, release documentation, and maintenance notes. Runtime data, credentials, execution history, Docker volumes, and private backups stay outside the repository.

## Versioned Files

- Sanitized workflow JSON at `workflow/abastecimentos.sanitized.json`.
- SQLite schema at `database/schema.sql`.
- Project documentation.
- Future images without personal data.
- Future fictional examples.

## Files That Must Stay Private

- Original n8n exports.
- Real SQLite databases.
- Credentials.
- Tokens.
- Personal data.
- n8n execution history.
- Docker volumes.
- Backups.
- Logs.
- `.env` files.
- Internal contribution or assistant instruction files.

## Update Process

1. Change the workflow in n8n.
2. Test the behavior in n8n.
3. Export the original JSON.
4. Keep the original export outside Git.
5. Regenerate the sanitized workflow JSON.
6. Validate the sanitized JSON.
7. Review the diff.
8. Update documentation when needed.
9. Commit the change.
10. Create a tag when the version is stable.

## Commit Pattern

Use simple Conventional Commits:

```text
feat: add new capability
fix: correct workflow behavior
refactor: reorganize logic without changing behavior
docs: update documentation
chore: update sanitized workflow export
```

Project-specific examples:

```text
feat: add km per liter consumption queries
fix: prevent confirmation without valid pending entry
refactor: split classification and data extraction prompts
docs: document pending conversation persistence
chore: update sanitized workflow export
```

## Release Versioning

Use SemVer only for stable releases:

```text
MAJOR.MINOR.PATCH
```

Rules:

- `PATCH`: fix or documentation update without new workflow capability.
- `MINOR`: compatible workflow capability.
- `MAJOR`: structural change that requires new configuration or significantly changes behavior.

Examples:

```text
v1.0.0 - first published functional version
v1.1.0 - new natural-language query capabilities
v1.1.1 - message classification fix
v2.0.0 - incompatible data model change
```

## Pre-Commit Checklist

- [ ] Workflow tested in n8n.
- [ ] Original export kept outside the repository.
- [ ] Sanitization executed.
- [ ] Credentials removed.
- [ ] Webhook IDs removed.
- [ ] `instanceId` removed.
- [ ] Real database absent.
- [ ] Personal data absent.
- [ ] JSON is valid.
- [ ] Connections are valid.
- [ ] Diff reviewed.
- [ ] README updated when needed.

## Recovery And Rollback

A previous workflow version can be recovered from Git history. The matching sanitized JSON can be manually imported into n8n.

Credentials must be configured again after import. Git does not restore the real SQLite database, n8n credentials, execution history, Docker volumes, or private backups.

Full instance recovery depends on a separate private backup.

## Limitations

- The sanitized JSON still needs a manual n8n import test.
- Credentials are not transferred.
- The SQLite community node must be installed.
- Required tables must exist before runtime use.
- The SQLite database path must be configured in the SQLite credential.
- Telegram and Groq credentials must be configured by the user.
