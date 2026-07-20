# Versionamento do workflow

## Objetivo

Este repositório versiona a lógica e a documentação do workflow n8n de controle de abastecimentos. Ele não é um backup completo da instância n8n.

O Git registra a versão sanitizada do workflow, o schema do banco e a documentação necessária para manutenção. A instância real, credenciais, banco SQLite, execuções, volumes e backups privados ficam fora do repositório.

## Arquivos versionados

- JSON sanitizado do workflow em `workflow/abastecimentos.sanitized.json`.
- Schema SQL em `database/schema.sql`.
- Documentação do projeto.
- Imagens futuras sem dados pessoais.
- Exemplos fictícios futuros.

## Arquivos não versionados

- Export original do n8n.
- Banco SQLite real.
- Credenciais.
- Tokens.
- Dados pessoais.
- Execuções do n8n.
- Volumes Docker.
- Backups.
- Logs.
- Arquivos `.env`.

## Processo de atualização

1. Alterar o workflow no n8n.
2. Testar o comportamento no n8n.
3. Exportar o JSON original.
4. Guardar o original fora do Git.
5. Gerar novamente a versão sanitizada.
6. Validar o JSON sanitizado.
7. Comparar as diferenças.
8. Atualizar documentação, se necessário.
9. Fazer commit.
10. Criar tag quando houver uma versão estável.

## Padrão de commits

Use Conventional Commits de forma simples:

```text
feat: adiciona nova funcionalidade
fix: corrige comportamento do workflow
refactor: reorganiza lógica sem mudar funcionalidade
docs: atualiza documentação
chore: atualiza export sanitizado
```

Exemplos relacionados ao projeto:

```text
feat: adiciona consultas de consumo em km/l
fix: impede confirmação sem pendência válida
refactor: separa classificação e extração de dados
docs: documenta persistência de conversas pendentes
chore: atualiza workflow sanitizado
```

## Versionamento de releases

Use versionamento semântico apenas para versões estáveis:

```text
MAJOR.MINOR.PATCH
```

Regras:

- `PATCH`: correção sem nova funcionalidade.
- `MINOR`: nova funcionalidade compatível.
- `MAJOR`: mudança estrutural que exige nova configuração ou altera significativamente o funcionamento.

Exemplos:

```text
v1.0.0 - primeira versão funcional publicada
v1.1.0 - novas consultas em linguagem natural
v1.1.1 - correção na classificação de mensagens
v2.0.0 - mudança incompatível no modelo de dados
```

Tags não devem ser criadas automaticamente durante a edição diária. Crie uma tag somente quando a versão estiver estável e documentada.

## Checklist antes de cada commit

- [ ] Workflow testado no n8n.
- [ ] Export original fora do repositório.
- [ ] Sanitização executada.
- [ ] Credenciais removidas.
- [ ] Webhook IDs removidos.
- [ ] `instanceId` removido.
- [ ] Banco real ausente.
- [ ] Dados pessoais ausentes.
- [ ] JSON válido.
- [ ] Conexões válidas.
- [ ] Diff revisado.
- [ ] README atualizado quando necessário.

## Recuperação e rollback

Uma versão anterior pode ser obtida pelo histórico Git. O JSON sanitizado anterior pode ser importado manualmente no n8n.

Após a importação, as credenciais precisam ser configuradas novamente. O Git não restaura banco SQLite real, credenciais, execuções do n8n, volumes Docker ou backups.

A recuperação completa da instância depende de backup privado separado.

## Limitações

- O JSON sanitizado precisa ser testado por importação manual no n8n.
- Credenciais não são transferidas pelo arquivo público.
- O community node SQLite `n8n-nodes-sqlite3` precisa estar instalado.
- As tabelas precisam existir antes do uso.
- O caminho do banco deve ser configurado na credencial SQLite.
- O bot do Telegram e a Groq precisam ser configurados pelo usuário.
