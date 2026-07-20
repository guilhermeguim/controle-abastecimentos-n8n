# Controle de Abastecimentos n8n

Workflow n8n para registrar e consultar abastecimentos pessoais por Telegram, usando SQLite como armazenamento e IA para interpretar mensagens em linguagem natural.

## Índice

- [Problema resolvido](#problema-resolvido)
- [Funcionamento](#funcionamento)
- [Arquitetura resumida](#arquitetura-resumida)
- [Tecnologias](#tecnologias)
- [Estado da conversa](#estado-da-conversa)
- [Uso de IA](#uso-de-ia)
- [Segurança da versão pública](#segurança-da-versão-pública)
- [Pré-requisitos](#pré-requisitos)
- [Importação no n8n](#importação-no-n8n)
- [Versionamento](#versionamento)

## Problema resolvido

Registrar abastecimentos manualmente em planilhas ou aplicativos genéricos costuma exigir muitos campos e interromper o uso no dia a dia.

Este workflow permite enviar uma mensagem simples pelo Telegram, completar dados ausentes em conversa, confirmar o registro e consultar o histórico depois em linguagem natural.

## Funcionamento

O workflow recebe mensagens pelo Telegram, normaliza a entrada, consulta pendências no SQLite e classifica a intenção da mensagem.

As principais ações são:

- registrar novo abastecimento;
- continuar um registro incompleto;
- corrigir dados pendentes;
- solicitar confirmação antes de salvar;
- salvar abastecimento confirmado;
- cancelar pendências;
- responder consultas sobre o histórico.

## Arquitetura resumida

```text
Telegram
  -> n8n Telegram Trigger
  -> normalização da entrada
  -> consulta de pendência no SQLite
  -> classificação da mensagem
  -> extração ou preparação determinística
  -> persistência no SQLite
  -> resposta pelo Telegram
```

O workflow usa duas tabelas principais:

- `abastecimentos`: registros confirmados.
- `abastecimentos_pendentes`: estado temporário da conversa por `chat_id`.

## Tecnologias

- n8n Community Edition.
- Telegram Bot.
- Groq API.
- Modelo `openai/gpt-oss-120b`.
- SQLite.
- Community node `n8n-nodes-sqlite3`.
- Docker.
- GCP.
- Caddy.

## Estado da conversa

A tabela `abastecimentos_pendentes` mantém um registro por conversa. Ela armazena o `chat_id`, o `usuario_id`, os dados parciais em JSON, o status atual e o campo pendente.

Esse modelo permite que o usuário envie mensagens curtas, como apenas o combustível ou a quilometragem, sem repetir todo o abastecimento.

## Uso de IA

A IA é usada para:

- classificar a intenção da mensagem;
- extrair dados estruturados de abastecimento;
- responder consultas em linguagem natural com base no histórico.

A lógica determinística continua fora da IA quando envolve validações, cálculo de campos derivados, persistência, atualização de pendências, confirmação e cancelamento.

O agente de consultas é limitado a uma ferramenta SQLite somente leitura para consultar os abastecimentos recentes.

## Segurança da versão pública

O arquivo público é `workflow/abastecimentos.sanitized.json`.

Foram removidos do export público:

- blocos `credentials`;
- campos `webhookId`;
- ID raiz do workflow;
- `versionId`;
- `meta` e `instanceId`;
- segredos aparentes encontrados por varredura local.

O export original do n8n, o banco SQLite real, credenciais, tokens, logs, backups, volumes Docker e arquivos `.env` não devem ser versionados.

A sanitização reduz o risco de exposição, mas o workflow importado ainda precisa ser revisado e testado manualmente no n8n.

## Pré-requisitos

- Instância n8n Community Edition.
- Bot do Telegram criado e credencial configurada no n8n.
- Conta Groq e credencial configurada no n8n.
- Community node `n8n-nodes-sqlite3` instalado.
- Banco SQLite privado criado no ambiente de execução.
- Tabelas criadas com `database/schema.sql`.

## Importação no n8n

1. Crie ou selecione a instância n8n.
2. Instale o community node `n8n-nodes-sqlite3`.
3. Crie o banco SQLite privado.
4. Execute o schema em `database/schema.sql`.
5. Importe `workflow/abastecimentos.sanitized.json`.
6. Configure as credenciais de Telegram, Groq e SQLite.
7. Revise parâmetros dependentes do ambiente.
8. Teste o fluxo manualmente antes de ativar.

As credenciais não estão incluídas no repositório.

## Versionamento

O processo de atualização do workflow está documentado em [docs/versionamento.md](docs/versionamento.md).

As mudanças por versão estão registradas em [CHANGELOG.md](CHANGELOG.md).
