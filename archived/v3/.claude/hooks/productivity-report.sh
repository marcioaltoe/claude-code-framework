#!/bin/bash

# Claude Code Productivity Report
# Generates detailed reports from ccnotify.db

DB_PATH="$HOME/.claude/hooks/ccnotify.db"

# Colors for output
GREEN='\033[38;5;114m'
BLUE='\033[38;5;75m'
YELLOW='\033[38;5;186m'
CORAL='\033[38;5;210m'
RESET='\033[0m'

# Function to show today's summary
show_today() {
    echo -e "${BLUE}═══ Claude Code - Relatório de Hoje $(date '+%Y-%m-%d') ═══${RESET}"
    echo
    
    sqlite3 -header -column "$DB_PATH" <<EOF
SELECT 
    substr(cwd, instr(cwd, '/') + 1) as 'Projeto',
    COUNT(*) as 'Tasks',
    CASE 
        WHEN SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)) >= 60
        THEN printf('%dh %dm', 
                    SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 AS INTEGER)),
                    SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)) % 60)
        ELSE printf('%d min', SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)))
    END as 'Tempo Total'
FROM prompt 
WHERE date(created_at) = date('now', 'localtime')
  AND stoped_at IS NOT NULL
GROUP BY cwd
ORDER BY SUM(julianday(stoped_at) - julianday(created_at)) DESC;
EOF
    
    echo
    echo -e "${GREEN}Total de tarefas em andamento:${RESET}"
    sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM prompt WHERE stoped_at IS NULL;"
}

# Function to show weekly summary
show_week() {
    echo -e "${BLUE}═══ Claude Code - Relatório Semanal ═══${RESET}"
    echo
    
    sqlite3 -header -column "$DB_PATH" <<EOF
SELECT 
    date(created_at) as 'Data',
    COUNT(DISTINCT cwd) as 'Projetos',
    COUNT(*) as 'Tasks',
    CASE 
        WHEN SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)) >= 60
        THEN printf('%dh %dm', 
                    SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 AS INTEGER)),
                    SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)) % 60)
        ELSE printf('%d min', SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER)))
    END as 'Tempo Total'
FROM prompt 
WHERE date(created_at) >= date('now', '-7 days')
  AND stoped_at IS NOT NULL
GROUP BY date(created_at)
ORDER BY date(created_at) DESC;
EOF
}

# Function to show project details
show_project() {
    local project="$1"
    
    echo -e "${BLUE}═══ Detalhes do Projeto: $project ═══${RESET}"
    echo
    
    sqlite3 -header -column "$DB_PATH" <<EOF
SELECT 
    datetime(created_at, 'localtime') as 'Início',
    datetime(stoped_at, 'localtime') as 'Fim',
    CASE 
        WHEN CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER) >= 60
        THEN printf('%dh %dm', 
                    CAST((julianday(stoped_at) - julianday(created_at)) * 24 AS INTEGER),
                    CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER) % 60)
        ELSE printf('%d min', CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS INTEGER))
    END as 'Duração',
    substr(prompt, 1, 50) || '...' as 'Prompt'
FROM prompt 
WHERE cwd LIKE '%$project%'
  AND stoped_at IS NOT NULL
ORDER BY created_at DESC
LIMIT 20;
EOF
}

# Function to show current/active tasks
show_active() {
    echo -e "${YELLOW}═══ Tarefas em Andamento ═══${RESET}"
    echo
    
    sqlite3 -header -column "$DB_PATH" <<EOF
SELECT 
    substr(cwd, instr(cwd, '/') + 1) as 'Projeto',
    datetime(created_at, 'localtime') as 'Iniciado',
    CAST((julianday('now') - julianday(created_at)) * 24 * 60 AS INTEGER) as 'Min. Decorridos',
    substr(prompt, 1, 60) || '...' as 'Prompt'
FROM prompt 
WHERE stoped_at IS NULL
ORDER BY created_at DESC;
EOF
}

# Function to show stats
show_stats() {
    echo -e "${BLUE}═══ Estatísticas Gerais ═══${RESET}"
    echo
    
    echo -e "${GREEN}Projetos mais ativos (últimos 30 dias):${RESET}"
    sqlite3 -header -column "$DB_PATH" <<EOF
SELECT 
    substr(cwd, instr(cwd, '/') + 1) as 'Projeto',
    COUNT(*) as 'Tasks',
    printf('%.1f hrs', SUM(CAST((julianday(stoped_at) - julianday(created_at)) * 24 AS REAL))) as 'Horas Total'
FROM prompt 
WHERE date(created_at) >= date('now', '-30 days')
  AND stoped_at IS NOT NULL
GROUP BY cwd
ORDER BY SUM(julianday(stoped_at) - julianday(created_at)) DESC
LIMIT 10;
EOF
    
    echo
    echo -e "${GREEN}Média de duração por tarefa:${RESET}"
    sqlite3 "$DB_PATH" <<EOF
SELECT printf('%.1f minutos', 
       AVG(CAST((julianday(stoped_at) - julianday(created_at)) * 24 * 60 AS REAL)))
FROM prompt 
WHERE stoped_at IS NOT NULL;
EOF
}

# Main menu
case "${1:-today}" in
    today)
        show_today
        ;;
    week)
        show_week
        ;;
    active)
        show_active
        ;;
    stats)
        show_stats
        ;;
    project)
        if [ -z "$2" ]; then
            echo "Usage: $0 project <project-name>"
            exit 1
        fi
        show_project "$2"
        ;;
    *)
        echo "Claude Code Productivity Report"
        echo "Usage: $0 [today|week|active|stats|project <name>]"
        echo
        echo "  today   - Relatório de hoje (padrão)"
        echo "  week    - Resumo semanal"
        echo "  active  - Tarefas em andamento"
        echo "  stats   - Estatísticas gerais"
        echo "  project - Detalhes de um projeto específico"
        ;;
esac