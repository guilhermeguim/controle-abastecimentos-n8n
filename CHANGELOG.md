# Changelog

Todas as mudanças relevantes deste projeto são registradas neste arquivo.

O formato segue uma adaptação simples de Keep a Changelog e o versionamento usa SemVer para releases estáveis.

## [v1.0.0] - 2026-07-20

### Adicionado
- Workflow n8n sanitizado para controle pessoal de abastecimentos via Telegram.
- Schema SQLite mínimo com as tabelas `abastecimentos` e `abastecimentos_pendentes`.
- Documentação inicial de uso, segurança, versionamento e rollback.
- Dossiê da release inicial em `docs/releases/v1.0.0.md`.

### Segurança
- Export original do n8n mantido fora do versionamento.
- Credenciais, IDs de webhook e metadados da instância removidos do JSON público.
- Regras de `.gitignore` para evitar publicação de banco real, exports originais, backups, logs, `.env`, credenciais e segredos.
