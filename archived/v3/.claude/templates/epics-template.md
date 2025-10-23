# Epic Definitions Template

**Template Type:** Epic Generation Output  
**Stage:** PRD to Epics Definition  
**Hierarchy Level:** EPIC (WHAT+WHY only - business value, no technical details)  
**Hierarchy Guide:** `~/.claude/docs/hierarchy-guide.md`

## Instructions

Este template define a estrutura para geração de epics a partir de PRDs. Cada epic deve:

- **Focar APENAS em WHAT e WHY** (valor de negócio)
- **PROIBIR detalhes técnicos** (HOW será definido nas stories)
- **Manter escopo de 1-2 release cycles**
- **Incluir critérios de aceitação testáveis**

## Epic Definitions Structure

```xml
<epic_definitions>
  <project_context>
    <project_name>[Nome do Projeto]</project_name>
    <total_epics>[Número de epics gerados]</total_epics>
    <estimated_effort>[Estimativa total em semanas]</estimated_effort>
  </project_context>
  
  <epic id="EPIC-001" status="pending">
    <title>[Nome do Epic]</title>
    <description>
      [BUSINESS VALUE ONLY - Descreva WHAT e WHY, nunca HOW]
      [Foque no valor para o usuário e funcionalidade de alto nível]
      [PROIBIDO: detalhes técnicos, especificações de implementação, tecnologias específicas]
    </description>
    <acceptance_criteria>
      <criterion>[Critério de aceitação 1 - deve ser testável]</criterion>
      <criterion>[Critério de aceitação 2 - deve ser verificável]</criterion>
      <criterion>[Critério de aceitação 3 - deve agregar valor]</criterion>
    </acceptance_criteria>
    <technical_scope>
      <layers_affected>
        <layer>Domain</layer>
        <layer>Application</layer>
        <layer>Infrastructure</layer>
        <layer>Presentation</layer>
      </layers_affected>
      <estimated_stories>3-5</estimated_stories>
    </technical_scope>
    <dependencies />
    <notes>[APENAS alto nível - principais riscos de negócio, dependências críticas, sem detalhes técnicos]</notes>
  </epic>
  
  <epic id="EPIC-002" status="pending">
    <title>[Nome do Epic 2]</title>
    <description>
      [Descrição do segundo epic seguindo mesmo padrão]
    </description>
    <acceptance_criteria>
      <criterion>[Critério específico para este epic]</criterion>
      <criterion>[Outro critério importante]</criterion>
    </acceptance_criteria>
    <technical_scope>
      <layers_affected>
        <layer>Application</layer>
        <layer>Infrastructure</layer>
      </layers_affected>
      <estimated_stories>2-4</estimated_stories>
    </technical_scope>
    <dependencies>
      <dependency epic_id="EPIC-001" reason="Requires authentication foundation" />
    </dependencies>
    <notes>[Notas específicas deste epic]</notes>
  </epic>
  
  <approval_section>
    <!-- MANUAL REVIEW REQUIRED -->
    <!-- 
      Para aprovar um epic: altere status="pending" para status="approved"
      Para rejeitar um epic: altere status="pending" para status="rejected"  
      Para modificar um epic: edite diretamente title, description ou acceptance_criteria
      
      Após aprovação manual, use: /task:stories-tasks --epic-id EPIC-001
    -->
  </approval_section>
</epic_definitions>
```

## Quality Checklist

- [ ] Cada epic foca em WHAT+WHY (valor de negócio)
- [ ] ZERO detalhes técnicos ou implementação
- [ ] Critérios de aceitação são testáveis
- [ ] Escopo estimado em 3-7 stories por epic
- [ ] Dependencies claramente definidas
- [ ] Status inicialmente "pending" para aprovação manual

## Next Steps

Após aprovação manual dos epics, usar:
```bash
/task:stories-tasks --epic-id EPIC-001
```