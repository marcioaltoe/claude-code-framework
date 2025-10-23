# Stories and Tasks Template

**Template Type:** Stories + Tasks Generation Output  
**Stage:** Epic to Stories+Tasks Decomposition  
**Hierarchy Level:** STORY (HOW - technical approach) + TASK (WHERE+WHEN - atomic implementation)  
**Hierarchy Guide:** `~/.claude/docs/hierarchy-guide.md`

## Instructions

Este template unifica stories e tasks em um único output. Estrutura:

- **STORIES**: Technical approach following Clean Architecture layers (HOW)
- **TASKS**: Atomic implementation within each story (WHERE+WHEN, 1 class + tests)

### Story Guidelines
- Seguir Clean Architecture: Domain → Application → Infrastructure → Presentation
- Definir technical requirements específicos por layer
- Mapear dependencies entre stories

### Task Guidelines  
- **YAGNI ENFORCED**: 1 class + tests por task
- **Atomic scope**: 1-4 horas por task
- **Simple structure**: No over-engineering

## Stories and Tasks Structure

```xml
<story_task_definitions epic_id="[EPIC-ID]">
  <project_context>
    <epic_title>[Título do Epic Original]</epic_title>
    <total_stories>[Número de stories geradas]</total_stories>
    <total_tasks>[Número total de tasks]</total_tasks>
    <implementation_order>[Ordem sugerida baseada em dependências]</implementation_order>
  </project_context>
  
  <story id="STORY-101" layer="Domain">
    <title>[Título da Story - Layer Domain]</title>
    <description>
      [HOW - Descrição técnica da story focada na responsabilidade específica
       desta story dentro da camada de domínio]
    </description>
    <technical_requirements>
      <requirement>[Requisito técnico específico 1]</requirement>
      <requirement>[Requisito técnico específico 2]</requirement>
      <requirement>[Validações ou regras de negócio específicas]</requirement>
    </technical_requirements>
    <files_to_modify>
      <file path="src/domain/entities/[entity].ts" action="create" />
      <file path="src/domain/value-objects/[vo].ts" action="create" />
    </files_to_modify>
    <dependencies />
    
    <!-- EMBEDDED ATOMIC TASKS -->
    <tasks>
      <task id="TASK-STORY-101-001" status="pending">
        <title>[WHERE+WHEN - Simple atomic task description]</title>
        <description>
          [ATOMIC IMPLEMENTATION ONLY - 1 class + tests, completable in 1-4 hours]
          [YAGNI ENFORCED - No abstractions, no future-proofing]
        </description>
        <files>
          <file>src/domain/entities/user.ts</file>
          <file>src/domain/entities/__tests__/user.test.ts</file>
        </files>
        <time_estimate>1-4 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[Simple, testable outcome 1]</criterion>
          <criterion>[Simple, testable outcome 2]</criterion>
        </acceptance_criteria>
      </task>
      
      <task id="TASK-STORY-101-002" status="pending">
        <title>[Another atomic task in same story]</title>
        <description>
          [Another 1 class + tests implementation]
        </description>
        <files>
          <file>src/domain/value-objects/email.ts</file>
          <file>src/domain/value-objects/__tests__/email.test.ts</file>
        </files>
        <time_estimate>2-3 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[Simple validation logic works]</criterion>
          <criterion>[Error handling implemented]</criterion>
        </acceptance_criteria>
      </task>
    </tasks>
  </story>
  
  <story id="STORY-102" layer="Application">
    <title>[Título da Story - Layer Application]</title>
    <description>
      [HOW - Descrição da story focada em casos de uso e serviços de aplicação]
    </description>
    <technical_requirements>
      <requirement>[Interface de repository a ser definida]</requirement>
      <requirement>[Use case específico a implementar]</requirement>
      <requirement>[Validação de dados de entrada]</requirement>
    </technical_requirements>
    <files_to_modify>
      <file path="src/application/interfaces/[interface].ts" action="create" />
      <file path="src/application/use-cases/[use-case].ts" action="create" />
    </files_to_modify>
    <dependencies>
      <dependency story_id="STORY-101" reason="Depende das entidades de domínio" />
    </dependencies>
    
    <tasks>
      <task id="TASK-STORY-102-001" status="pending">
        <title>[Use case interface definition]</title>
        <description>
          [Define port interface for use case - simple interface only]
        </description>
        <files>
          <file>src/application/interfaces/user-repository.interface.ts</file>
          <file>src/application/interfaces/__tests__/user-repository.interface.test.ts</file>
        </files>
        <time_estimate>1-2 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[Interface properly typed]</criterion>
          <criterion>[Methods clearly defined]</criterion>
        </acceptance_criteria>
      </task>
      
      <task id="TASK-STORY-102-002" status="pending">
        <title>[Use case implementation]</title>
        <description>
          [Implement single use case class with dependency injection]
        </description>
        <files>
          <file>src/application/use-cases/create-user.use-case.ts</file>
          <file>src/application/use-cases/__tests__/create-user.use-case.test.ts</file>
        </files>
        <time_estimate>3-4 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[Use case handles happy path]</criterion>
          <criterion>[Error scenarios covered]</criterion>
          <criterion>[Dependencies properly injected]</criterion>
        </acceptance_criteria>
      </task>
    </tasks>
  </story>
  
  <story id="STORY-103" layer="Infrastructure">
    <title>[Título da Story - Layer Infrastructure]</title>
    <description>
      [HOW - Descrição da implementação de infraestrutura - repositórios, APIs externas, etc.]
    </description>
    <technical_requirements>
      <requirement>[Implementação concreta do repository]</requirement>
      <requirement>[Configuração de banco de dados/ORM]</requirement>
      <requirement>[Integração com serviços externos se necessário]</requirement>
    </technical_requirements>
    <files_to_modify>
      <file path="src/infrastructure/repositories/[repo].ts" action="create" />
      <file path="src/infrastructure/database/migrations/[migration].ts" action="create" />
    </files_to_modify>
    <dependencies>
      <dependency story_id="STORY-102" reason="Implementa interfaces definidas na Application" />
    </dependencies>
    
    <tasks>
      <task id="TASK-STORY-103-001" status="pending">
        <title>[Database migration]</title>
        <description>
          [Create database table/schema - single migration file]
        </description>
        <files>
          <file>src/infrastructure/database/migrations/001-create-users-table.ts</file>
        </files>
        <time_estimate>1-2 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[Migration runs successfully]</criterion>
          <criterion>[Schema matches domain requirements]</criterion>
        </acceptance_criteria>
      </task>
      
      <task id="TASK-STORY-103-002" status="pending">
        <title>[Repository implementation]</title>
        <description>
          [Implement concrete repository class with ORM integration]
        </description>
        <files>
          <file>src/infrastructure/repositories/user.repository.ts</file>
          <file>src/infrastructure/repositories/__tests__/user.repository.test.ts</file>
        </files>
        <time_estimate>3-4 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[All interface methods implemented]</criterion>
          <criterion>[Database operations work correctly]</criterion>
          <criterion>[Error handling for DB failures]</criterion>
        </acceptance_criteria>
      </task>
    </tasks>
  </story>
  
  <story id="STORY-104" layer="Presentation">
    <title>[Título da Story - Layer Presentation]</title>
    <description>
      [HOW - Descrição da camada de apresentação - controladores, rotas, componentes UI]
    </description>
    <technical_requirements>
      <requirement>[Endpoints HTTP específicos]</requirement>
      <requirement>[Validação de entrada via Zod]</requirement>
      <requirement>[Serialização de resposta]</requirement>
    </technical_requirements>
    <files_to_modify>
      <file path="src/presentation/controllers/[controller].ts" action="create" />
      <file path="src/presentation/routes/[route].ts" action="create" />
    </files_to_modify>
    <dependencies>
      <dependency story_id="STORY-102" reason="Consome casos de uso da Application" />
    </dependencies>
    
    <tasks>
      <task id="TASK-STORY-104-001" status="pending">
        <title>[HTTP controller]</title>
        <description>
          [Implement single controller class with endpoint handlers]
        </description>
        <files>
          <file>src/presentation/controllers/user.controller.ts</file>
          <file>src/presentation/controllers/__tests__/user.controller.test.ts</file>
        </files>
        <time_estimate>3-4 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[All endpoints respond correctly]</criterion>
          <criterion>[Input validation works]</criterion>
          <criterion>[Error responses properly formatted]</criterion>
        </acceptance_criteria>
      </task>
      
      <task id="TASK-STORY-104-002" status="pending">
        <title>[Route configuration]</title>
        <description>
          [Configure HTTP routes connecting to controller]
        </description>
        <files>
          <file>src/presentation/routes/user.routes.ts</file>
          <file>src/presentation/routes/__tests__/user.routes.test.ts</file>
        </files>
        <time_estimate>1-2 hours</time_estimate>
        <acceptance_criteria>
          <criterion>[Routes properly configured]</criterion>
          <criterion>[Middleware applied correctly]</criterion>
        </acceptance_criteria>
      </task>
    </tasks>
  </story>
  
  <dependency_graph>
    <!-- 
      Ordem de implementação recomendada:
      1. STORY-101 (Domain) - sem dependências
      2. STORY-102 (Application) - depende de 101  
      3. STORY-103 (Infrastructure) - depende de 102
      4. STORY-104 (Presentation) - depende de 102
      
      STORY-103 e STORY-104 podem ser implementadas em paralelo após STORY-102
      
      Tasks dentro de cada story podem ser implementadas sequencialmente
      ou em paralelo dependendo das dependências internas
    -->
  </dependency_graph>
  
  <approval_section>
    <!-- MANUAL REVIEW REQUIRED -->
    <!-- 
      Para aprovar uma story: altere status="pending" para status="approved" em todas as tasks
      Para aprovar uma task individual: altere apenas o status da task específica
      Para modificar: edite diretamente os elementos XML
      
      Após aprovação, use: /implement --plan TASK-STORY-101-001 (para task específica)
      ou /implement --story STORY-101 (para story completa)
    -->
  </approval_section>
</story_task_definitions>
```

## Quality Checklist

### Story Level
- [ ] Cada story foca no HOW (abordagem técnica)
- [ ] Clean Architecture layers respeitadas
- [ ] Dependencies entre stories mapeadas
- [ ] Technical requirements específicos definidos

### Task Level  
- [ ] Cada task é atomic (1 class + tests)
- [ ] Tempo estimado: 1-4 horas
- [ ] YAGNI enforced - sem over-engineering
- [ ] Acceptance criteria simples e testáveis
- [ ] Files paths específicos definidos

## Implementation Workflow

1. **Implementar por Story** (recomendado):
   ```bash
   /implement --story STORY-101  # Implementa todas tasks da story
   ```

2. **Implementar Task Individual**:
   ```bash  
   /implement --plan TASK-STORY-101-001  # Implementa task específica
   ```

3. **Verificação**:
   ```bash
   bun run test && bun type-check && bun lint
   ```