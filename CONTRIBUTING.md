# Guia de Versionamento e Fluxo de Trabalho (Git)

Este documento define o processo padrao de desenvolvimento, revisao, versionamento e deploy do projeto.
O objetivo e manter o sistema estavel, permitir deploy frequente (ate diario) e facilitar entrada de novas pessoas.

---

## 1) Regras principais (resumo)

1. **`main` e a branch integrada e sempre implantavel**
   - Tudo que entra na `main` deve estar estavel e pronto para ser implantado a qualquer momento.
   - Nem tudo que esta na `main` precisa ir para producao no mesmo dia.

2. **Producao sempre aponta para uma tag (Release)**
   - O deploy do dia deve usar uma **tag** no formato `vMAJOR.MINOR.PATCH` (ex.: `v1.4.2`).
   - Isso garante rastreabilidade e rollback facil.

3. **Nunca commitar direto na `main`**
   - Toda mudanca deve entrar por Pull Request (PR) a partir de uma branch curta.

4. **Mudancas pequenas e frequentes**
   - Preferir PRs menores, com escopo bem definido.
   - Se a feature ainda nao esta pronta, nao mergear ou usar feature flag para manter desativada em producao.

5. **Rollback precisa ser possivel**
   - Se algo falhar, voltar para a tag anterior rapidamente.
   - Mudancas de banco exigem cuidado extra (ver secao de migracoes).

---

## 2) Estrutura de branches

### Branch principal
- **`main`**: branch estavel, integrada e implantavel.

### Branches de trabalho (curtas)
Crie uma branch por tarefa, seguindo o padrao:

- `feat/<descricao-curta>`: nova funcionalidade
- `fix/<descricao-curta>`: correcao de bug
- `refactor/<descricao-curta>`: refatoracao sem alterar regra
- `chore/<descricao-curta>`: manutencao (config, deps, scripts)
- `docs/<descricao-curta>`: documentacao

Exemplos:
- `feat/email-por-vsm`
- `fix/op-duplicada`
- `refactor/servico-classificacao-runner-exotico`

---

## 3) Padrao de commits (mensagens)

Usar prefixos simples para facilitar historico e leitura:

- `feat: ...`
- `fix: ...`
- `refactor: ...`
- `chore: ...`
- `docs: ...`

Exemplos:
- `feat: separar emails por VSM no relatorio de supermercados`
- `fix: bloquear envio de email para usuario sem permissao`
- `refactor: mover logica de calculo para service`

Boas praticas:
- Preferir commits menores e com proposito claro.
- Evitar commit grande misturando assuntos diferentes.

---

## 4) Pull Request (PR): como abrir e o que precisa ter

### Regras
- Todo PR deve ter escopo bem definido (uma feature ou bug principal).
- O PR deve descrever o que mudou e qual impacto.
- Nao mergear codigo meio pronto (a menos que esteja protegido por feature flag).

### Formato padrao da descricao da PR
Para manter consistencia entre PRs, use secoes em Markdown com `##` no titulo de cada bloco.

Modelo recomendado:
```md
## Objetivo:
- ...

## Mudancas:
- ...

## Como testar:
- ...

## Impacto:
- ...

## Riscos:
- ...

## Migracao:
- Nao se aplica

## Checklist:
- [x] Testei o fluxo principal afetado
- [x] Validei cenarios de borda relevantes
- [x] Atualizei docs quando necessario
- [x] Migracao testada (se aplicavel)
```

Observacao:
- Mantenha os nomes das secoes e o uso de `##` para facilitar revisao e comparacao entre PRs.

### Checklist minimo para aprovar e fazer merge
Antes de fazer merge na `main`, confirme:

- [ ] Rodei o sistema localmente e validei o fluxo principal afetado.
- [ ] Se houve alteracao de banco (migracao), apliquei e validei em dev.
- [ ] O PR esta pequeno o suficiente para revisar com seguranca.
- [ ] Atualizei documentacao quando necessario (README/CHANGELOG).

Observacao:
- Mesmo que apenas uma pessoa esteja desenvolvendo, o PR serve como etapa de revisao e controle.

---

## 5) Versionamento (SemVer) e tags

### Formato
Usar SemVer: `vMAJOR.MINOR.PATCH` (ex.: `v1.2.3`)

- PATCH (`v1.2.4`): correcao de bug, ajuste pequeno, sem quebrar compatibilidade.
- MINOR (`v1.3.0`): nova funcionalidade, sem quebrar compatibilidade.
- MAJOR (`v2.0.0`): mudanca que quebra compatibilidade ou exige ajustes relevantes.

### Regra de ouro
- **Todo deploy em producao = criar uma tag a partir da `main`.**
- Producao deve registrar qual tag esta rodando.

---

## 6) Processo padrao (fluxo do dia a dia)

### 6.1 Atualizar e criar branch
```bash
git checkout main
git pull
git checkout -b feat/minha-tarefa
```

### 6.2 Commits
```bash
git add .
git commit -m "feat: descricao objetiva da mudanca"
```

### 6.3 Push da branch
```bash
git push -u origin feat/minha-tarefa
```

### 6.4 Abrir PR e fazer merge
- Abrir Pull Request para `main`
- Conferir checklist minimo
- Fazer merge (squash and merge se quiser historico mais limpo)

---

## 7) Deploy diario (fechamento do dia)

Objetivo: no fim do dia, fechar uma versao e subir no servidor com rastreabilidade.

### 7.1 Preparar
- Garantir que a `main` esta atualizada localmente
- Confirmar que as migracoes pendentes (se existirem) estao prontas e testadas

```bash
git checkout main
git pull
```

### 7.2 Criar tag da versao
Exemplo de tag (ajuste o numero conforme SemVer):
```bash
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

### 7.3 Deploy no servidor (sempre pela tag)
- No servidor, fazer checkout da tag ou garantir que o deploy referencia a tag.
- Aplicar migracoes (se existirem).
- Reiniciar servicos.

### 7.4 Smoke test rapido apos deploy
- Login
- Fluxos criticos afetados no dia
- Verificar logs de erro

---

## 8) Rollback (voltar versao)

Se a versao implantada apresentar problema, voltar para a tag anterior.

Principio:
- Se esta em `v1.0.3` e falhou, voltar para `v1.0.2`.

Importante:
- Mudancas de banco podem dificultar rollback. Ver secao de migracoes.

---

## 9) Mudancas de banco e migracoes

Regras:
1. Toda alteracao de schema deve ser versionada (migracao).
2. Migracoes devem ser testadas antes do deploy.
3. Preferir migracoes compativeis (forward e backward se possivel).
4. Mudancas destrutivas (drop ou rename) devem ser planejadas e feitas em fases quando der.

Checklist para migracao em deploy:
- [ ] Aplicar migracao em dev e validar
- [ ] Ter plano de rollback (downgrade ou estrategia alternativa)
- [ ] Se for destrutiva, registrar risco e estrategia (backup, janela, validacao)

---

## 10) Hotfix (correcao urgente em producao)

Quando precisa corrigir algo urgente:

1. Criar branch a partir da `main`:
   - `fix/hotfix-<descricao>`
2. PR rapido + checklist minimo
3. Merge na `main`
4. Criar tag PATCH:
   - Ex.: `v1.0.4`
5. Deploy e smoke test

---

## 11) CHANGELOG (registro de mudancas por versao)

Manter um `CHANGELOG.md` simples, com cada versao listando:

- Adicionado
- Alterado
- Corrigido

Exemplo:
- `v1.3.0`
  - Adicionado: envio de email separado por VSM
  - Corrigido: filtro de destinatarios por flags de recebimento

## 11.1) Dossie de release (obrigatorio)

Toda tag de release deve ter um arquivo detalhado em `docs/releases/` com o nome da versao:

- `docs/releases/vX.Y.Z.md`

Estrutura minima obrigatoria (seguir o padrao das ultimas releases):
- `Data de fechamento`
- `Base de comparacao` (ex.: `v1.4.0..abc1234`)
- `Resumo` (tipo, commits, PRs, arquivos, linhas adicionadas/removidas, janela)
- `Objetivo`
- `Procedimentos de fechamento executados`
- `Principais entregas` (agrupadas por dominio funcional)
- `Mudancas de banco e migracao` (migracoes, impacto, comandos)
- `Pull requests incluidos`
- `Compatibilidade`
- `Procedimento recomendado de deploy`
- `Smoke test pos-deploy`
- `Rollback`
- `Tag de release`

Regras:
- O conteudo da release no GitHub deve refletir o mesmo escopo do arquivo em `docs/releases/`.
- O `CHANGELOG.md` e o dossie de release devem ser atualizados no mesmo fechamento.
- A classificacao SemVer (PATCH/MINOR/MAJOR) deve considerar o periodo completo desde a tag anterior.

---

## 12) Configuracoes recomendadas no GitHub

Recomendado habilitar no repositorio:
- Bloquear push direto na `main` (branch protection)
- Exigir PR para merge
- Exigir status checks (testes/lint) quando existirem

---

## 13) Exemplos rapidos

### Correcao pequena (PATCH)
- Branch: `fix/ajuste-email`
- Merge na `main`
- Tag: `v1.0.1`
- Deploy

### Feature nova (MINOR)
- Branch: `feat/novo-relatorio`
- Merge na `main`
- Tag: `v1.3.0`
- Deploy

### Mudanca grande (MAJOR)
- Branches por etapas
- Planejar migracoes
- Tag final: `v2.0.0`

---

# Padrao Git do projeto para usar com Codex (Branches, Commits, PR, Releases)

Use este documento como fonte unica de verdade para gerar:
- nomes de branch
- summary e description de commits
- titulo e descricao de Pull Request (PR)
- tags de release

Regras gerais
- Tudo deve ser escrito em portugues (incluindo commits e PRs).
- Use PT-BR com acentuacao correta em titulos e descricoes de commit/PR. Restrinja ASCII para nomes tecnicos como branch, arquivos, modulos, rotas e chaves.
- Branch sempre em minusculo.
- Use kebab-case (palavras separadas por hifen).
- Nao misture assuntos diferentes no mesmo commit/PR.
- Mudancas pequenas e testaveis.
- Antes de concluir, valide UTF-8 real dos textos alterados; nao confie na saida do terminal para confirmar acentos.
- Em PRs e textos publicados fora do repositorio, confira o conteudo final na fonte de destino (ex.: API/JSON do GitHub) para evitar mojibake ou `??`.

---

## 1) Nome de branch

Formato:
<tipo>/<descricao-curta-em-kebab-case>

Tipos permitidos:
- feat/      nova funcionalidade
- fix/       correcao de bug
- refactor/  refatoracao sem mudar regra de negocio
- chore/     manutencao (deps, scripts, config, build)
- docs/      documentacao

Exemplos:
- feat/email-por-vsm
- fix/anual-ts-tech-filtrar-mes-do-arquivo
- refactor/mover-calculo-metricas-para-service
- chore/ajustar-logging-upload
- docs/atualizar-readme-setup

---

## 2) Padrao de commit

### 2.1 Summary do commit (titulo)

Formato:
<tipo>: <acao-objetiva>

Regras:
- Tipos: feat, fix, refactor, chore, docs
- Frase curta, direta, sem ponto final
- Preferir verbo no infinitivo (ex.: adicionar, ajustar, mover, bloquear, remover, atualizar)
- Nao incluir detalhes demais (o detalhe vai na description)

Exemplos:
- fix: anual ts tech insere apenas do mes do arquivo em diante
- feat: detectar e processar layout anual por aba simulacao hab
- refactor: extrair calculo de metricas para services/metricas.py

### 2.2 Description do commit (corpo)

A description deve ser uma lista simples do que foi atualizado. Use sempre este formato:

```text
Mudancas:
- <item 1 objetivo e curto>
- <item 2 objetivo e curto>
- <item 3 objetivo e curto>

Como testar:
- <passo 1>
- <passo 2>
- <validacao esperada>

Impacto:
- <area afetada / comportamento esperado>

Migracao:
- Nao se aplica
ou
- Aplica: <nome da migracao>
- Rollback: <como reverter>
```

Exemplos (description):
```text
Mudancas:
- Filtrar insercao do anual a partir do mes do arquivo
- Descartar datas invalidas no forecast
- Ajustar logs do processor para facilitar debug

Como testar:
- Subir um arquivo anual com meses anteriores ao file_date
- Confirmar que apenas meses do file_date em diante foram inseridos
- Validar export e tela de visualizacao com os novos dados

Impacto:
- Forecast diarizado passa a respeitar o mes do arquivo

Migracao:
- Nao se aplica
```

### 2.3 Tamanho do commit (granularidade)

Recomendacao:
- 1 commit = 1 motivo claro
- Se a mudanca for grande, dividir em 2 a 5 commits, por exemplo:
  1) feat/fix: base e estrutura
  2) feat/fix: regra principal
  3) fix: bordas e validacoes
  4) docs/chore: ajustes finais (se necessario)

---

## 3) Padrao de Pull Request (PR)

### 3.1 Titulo do PR

Formato:
<tipo>: <descricao-curta>

Exemplos:
- fix: anual ts tech filtra dados anteriores ao mes do arquivo
- feat: importar anual ts tech e manter meses futuros

### 3.2 Descricao do PR (template)

```text
## Objetivo:
- <o que resolve e por que>

## Mudancas:
- <mudanca 1>
- <mudanca 2>
- <mudanca 3>

## Como testar:
- <passo 1>
- <passo 2>
- <validacao esperada>

## Impacto:
- <areas afetadas>
- <compatibilidade / comportamento novo>

## Riscos:
- <risco 1> (se houver)
- <mitigacao> (se houver)

## Migracao:
- Nao se aplica
ou
- Aplica: <migracao>
- Rollback: <downgrade/estrategia>

## Checklist:
- [ ] Testei o fluxo principal afetado
- [ ] Validei cenarios de borda relevantes
- [ ] Atualizei docs quando necessario
- [ ] Migracao testada (se aplicavel)
```

---

## 4) Tags de release (SemVer)

Formato:
vMAJOR.MINOR.PATCH

Regras:
- PATCH: correcao/ajuste sem quebrar compatibilidade
- MINOR: feature nova mantendo compatibilidade
- MAJOR: mudanca que quebra compatibilidade

Recomendacao:
- Todo deploy em producao deve apontar para uma tag.

---

## 5) Bloco pronto para pedir ao Codex

Copie e cole este bloco na conversa com o Codex:

```text
Siga o padrao do projeto (tudo em portugues e ASCII apenas):

1) Sugira nome de branch usando: feat/ fix/ refactor/ chore/ docs/ + kebab-case.
2) Para cada commit:
   - Summary: "<tipo>: <acao objetiva>"
   - Description: lista simples, no formato:
     Mudancas:
     - ...
     Como testar:
     - ...
     Impacto:
     - ...
     Migracao:
     - Nao se aplica / Aplica + Rollback
3) Para o PR:
   - Titulo: mesmo padrao do commit
   - Descricao: use o template do PR (Objetivo / Mudancas / Como testar / Impacto / Riscos / Migracao / Checklist).
4) Nao misture assuntos diferentes no mesmo commit/PR.
5) Proponha um plano com 2 a 5 commits quando fizer sentido.
```

---

## 6) Checklist do fluxo (GitHub Desktop)

- Fetch origin
- Pull main
- Create branch (padrao acima)
- Commits pequenos (summary + description no formato do item 2)
- Push branch
- Abrir PR (titulo + descricao no template do item 3)
- Merge na main (nunca commitar direto na main)
- Pull da main local
- Criar tag vX.Y.Z para deploy em producao (quando aplicavel)


