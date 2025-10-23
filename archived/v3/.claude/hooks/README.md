# Claude Code Hooks Configuration

## Configuração Atual

### 🎯 Hooks Ativos

1. **SessionStart** - Registra início de sessão
   - Log simples em `~/.claude/hooks/logs/session.log`

2. **UserPromptSubmit** - Rastreia prompts e tempo de trabalho
   - Script: `ccnotify.py UserPromptSubmit`
   - Armazena em: `ccnotify.db`
   - Registra: session_id, prompt, cwd, timestamp

3. **PostToolUse** - Verifica TypeScript após edições
   - Script: `typescript-check.sh`
   - Matcher: `Write|Edit|MultiEdit`
   - Executa: tsc --noEmit e bun lint
   - Bloqueia operação se houver erros

4. **Notification** - Detecta "waiting for input"
   - Script: `ccnotify.py Notification`
   - Envia notificação quando Claude está esperando

5. **Stop** - Registra fim de tarefa
   - Script: `ccnotify.py Stop`
   - Calcula duração e envia notificação
   - Atualiza `stoped_at` no banco

6. **SubagentStop** - Registra fim de subagente
   - Log simples em `~/.claude/hooks/logs/session.log`

## 📊 Banco de Dados (ccnotify.db)

### Estrutura da tabela `prompt`:
```sql
CREATE TABLE prompt (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    prompt TEXT,
    cwd TEXT,
    seq INTEGER,  -- Auto-incrementado por trigger
    stoped_at DATETIME,
    lastWaitUserAt DATETIME
);
```

### Consultas Úteis:

```bash
# Ver últimos 10 prompts
sqlite3 ~/.claude/hooks/ccnotify.db "SELECT datetime(created_at, 'localtime'), substr(prompt, 1, 50), cwd FROM prompt ORDER BY created_at DESC LIMIT 10;"

# Tempo total por projeto hoje
sqlite3 ~/.claude/hooks/ccnotify.db "
SELECT cwd, 
       COUNT(*) as tasks,
       SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)) as total_minutes
FROM prompt 
WHERE date(created_at) = date('now')
  AND stoped_at IS NOT NULL
GROUP BY cwd;"

# Tarefas em andamento
sqlite3 ~/.claude/hooks/ccnotify.db "SELECT session_id, cwd, datetime(created_at, 'localtime') FROM prompt WHERE stoped_at IS NULL ORDER BY created_at DESC;"
```

## 🔔 Troubleshooting Notificações

### Se as notificações não aparecem:

1. **Verificar permissões do macOS:**
   ```bash
   # Abrir preferências de notificações
   open "x-apple.systempreferences:com.apple.preference.notifications"
   ```
   - Procure por "Terminal" ou "terminal-notifier"
   - Habilite notificações

2. **Testar terminal-notifier:**
   ```bash
   terminal-notifier -title "Teste" -message "Funcionando!" -sound default
   ```

3. **Verificar logs:**
   ```bash
   tail -f ~/.claude/hooks/logs/ccnotify.log
   ```

4. **Modo Não Perturbe:**
   - Verifique se o macOS não está em "Não Perturbe"
   - Ícone de lua no canto superior direito

5. **Reinstalar terminal-notifier:**
   ```bash
   brew reinstall terminal-notifier
   ```

## 🚨 TypeScript Check

O hook `typescript-check.sh` é executado automaticamente quando você edita arquivos `.ts` ou `.tsx`.

### Funcionamento:
1. Detecta alterações em arquivos TypeScript
2. Executa `tsc --noEmit` para verificar tipos
3. Executa `bun lint` se disponível
4. **BLOQUEIA** a operação se houver erros
5. Mostra os erros no chat

### Logs:
```bash
tail -f ~/.claude/hooks/typescript-check.log
```

### Desativar temporariamente:
Comente a entrada PostToolUse em `~/.claude/settings.json`

## 📈 Relatórios de Produtividade

### Script para relatório diário:
```bash
#!/bin/bash
# save as: ~/.claude/hooks/daily-report.sh

echo "=== Relatório Claude Code - $(date '+%Y-%m-%d') ==="
echo

sqlite3 ~/.claude/hooks/ccnotify.db <<EOF
.headers on
.mode column
SELECT 
    cwd as 'Projeto',
    COUNT(*) as 'Tarefas',
    printf('%.1f', SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS REAL))) as 'Minutos',
    printf('%.1f', SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 AS REAL))) as 'Horas'
FROM prompt 
WHERE date(created_at) = date('now')
  AND stoped_at IS NOT NULL
GROUP BY cwd
ORDER BY SUM(julianday(stoped_at) - julianday(created_at)) DESC;
EOF
```

## 🔧 Configuração Alternativa

Se preferir separar as responsabilidades em múltiplos scripts Python (como o exemplo que você viu), você pode:

1. Manter `ccnotify.py` apenas para o banco de dados
2. Criar scripts separados para notificações
3. Adicionar mais hooks como PreCompact, SessionStart detalhado, etc.

A configuração atual é mais simples e atende suas necessidades principais:
- ✅ Rastreamento de tempo por projeto
- ✅ Verificação TypeScript automática
- ✅ Notificações de status
- ✅ Banco de dados persistente