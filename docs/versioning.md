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
4. Keep the original export outside Git (`Abastecimentos.json` is ignored locally).
5. Regenerate the sanitized workflow JSON.
6. Validate the sanitized JSON.
7. Review the diff.
8. Update documentation when needed.
9. Commit the change.
10. Create a tag when the version is stable.

## Sanitization Requirements

Regenerate `workflow/abastecimentos.sanitized.json` from the private export, preserving node logic, node IDs, positions, and connections except for the explicit privacy substitutions below:

- Remove every `credentials`, `webhookId`, and `instanceId` field, including nested occurrences.
- Remove root `id`, `versionId`, `meta`, and `staticData`, if present.
- Replace `pinData` with `{}`; pinned Telegram events can include user IDs, chat IDs, names, and message content.
- In `Usuário autorizado?`, replace the condition's private `rightValue` with the string `REPLACE_WITH_TELEGRAM_USER_ID`. Retain the comparison against `message.from.id` and its equality operator.
- Set root `active` to `false` so the public artifact is prepared for configuration and testing after import.
- Review any tags, node groups, notes, literal chat IDs, paths, URLs, headers, code, and prompt examples for personal or environment-specific data. Do not publish non-empty metadata without reviewing it.
- Scan the public files for token/key patterns and values taken from the private credential blocks, metadata, and Telegram sample. Report locations or counts, never private values.

Removing n8n credential references alone is insufficient: literal IDs and pinned execution data can remain elsewhere in the export. Preserve dynamic expressions such as `message.chat.id` and `message.from.id`; these are runtime references, not private literal values.

For a local syntax check, run `python -m json.tool workflow/abastecimentos.sanitized.json` (Python 3). Also verify unique node names/IDs, valid connection endpoints, unchanged connections relative to the private export, the authorization/text branches, and the absence of forbidden fields. Check `git check-ignore Abastecimentos.json` and inspect `git status --short` before staging public files.

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

## Branches And Merging

Use `<type>/<short-description>` with lowercase words separated by hyphens. Match the prefix to the work: `feat/`, `fix/`, `refactor/`, `docs/`, or `chore/`. Examples include `feat/proteger-entrada-telegram` and `docs/melhorar-apresentacao-publica`.

Use the repository convention instead of a tool-specific branch prefix. Merge pull requests into `main` with a merge commit, preserving their commits; do not squash. Create release tags on the resulting `main` commit.

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

The `v1.1.0` update is MINOR: it adds sender authorization, text routing, and extraction validation while preserving the main fuel-log flow and SQLite schema. Configuring the allowed sender is a setup step for the new protection, not a structural migration. Document this setup requirement and the narrower accepted inputs in the upgrade notes; an additional configuration field alone does not require a MAJOR release.

While preparing an update, keep its changelog entry under `Unreleased`. To finalize publication, assign the version and release date, document the checks actually performed and any remaining runtime checks, commit the reviewed public files, merge into `main`, create the version tag, and publish matching release notes. Local JSON and graph checks do not establish n8n runtime compatibility; never mark runtime checks complete unless they were performed.

## Pre-Commit Checklist

- [ ] Workflow tested in n8n.
- [ ] Original export ignored and absent from Git's tracked files.
- [ ] Sanitization executed.
- [ ] Credentials removed.
- [ ] Webhook IDs removed.
- [ ] `instanceId` removed.
- [ ] Root workflow metadata and static runtime data removed.
- [ ] `pinData` is empty.
- [ ] Private authorized sender ID replaced with the documented placeholder.
- [ ] Public export has `active: false`.
- [ ] Real database absent.
- [ ] Personal data absent.
- [ ] JSON is valid.
- [ ] Connections are valid.
- [ ] Authorization and text-only routing checked, including rejected inputs.
- [ ] Diff reviewed.
- [ ] README updated when needed.

## Recovery And Rollback

A previous workflow version can be recovered from Git history. The matching sanitized JSON can be manually imported into n8n.

Credentials must be configured again after import. Git does not restore the real SQLite database, n8n credentials, execution history, Docker volumes, or private backups.

Returning from `v1.1.0` to `v1.0.1` also removes the sender authorization and text gate. Review that access change before activating an older workflow; no schema rollback is required for this update.

Full instance recovery depends on a separate private backup.

## Limitations

- The sanitized JSON still needs a manual n8n import test.
- Credentials are not transferred.
- The SQLite community node must be installed.
- Required tables must exist before runtime use.
- The SQLite database path must be configured in the SQLite credential.
- Telegram and Groq credentials must be configured by the user.
- The authorized Telegram sender ID must be configured after import of the v1.1.0 workflow.
- Sender authorization does not restrict chat type or isolate the shared history by user.
