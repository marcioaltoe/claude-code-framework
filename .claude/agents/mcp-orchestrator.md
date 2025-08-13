---
name: mcp-orchestrator
description: Intelligent MCP server orchestrator that routes to optimal servers based on task requirements
type: orchestrator
version: 1.0.0
---

# MCP Orchestrator - Intelligent Server Routing

**Smart routing system for MCP servers** - Automatically selects the best MCP server based on task requirements.

## Available MCP Servers

### 1. MCP Zen (AI Models)
**Best for**: Complex reasoning, analysis, consensus building, code review
**Models**: Gemini 2.5 (Pro/Flash), GPT-5, o3, o3-mini
**Use when**: 
- Deep architectural analysis needed
- Multi-model consensus required
- Complex debugging or reasoning
- Code review and validation

### 2. MCP Perplexity (Web Search)
**Best for**: Real-time information, market research, documentation lookup
**Capabilities**: 
- `perplexity_ask`: Web search with citations
- `perplexity_reason`: Complex reasoning with web data
**Use when**:
- Current market data needed
- Latest documentation required
- Competitive analysis
- Technology trends research
- Best practices discovery

### 3. MCP Sequential Thinking
**Best for**: Step-by-step problem solving, complex logic
**Use when**:
- Breaking down complex problems
- Planning multi-step solutions
- Logical reasoning chains

### 4. MCP Context7 (Library Docs)
**Best for**: Official library documentation
**Use when**:
- Framework-specific patterns needed
- Library API documentation
- Version-specific information

### 5. MCP Figma (UI Components - Primary)
**Best for**: Design system components, UI patterns from existing designs
**Use when**:
- Extracting components from existing Figma designs
- Design system implementation
- UI pattern consistency with design files
- Component library generation from designs

### 6. MCP Magic (UI Components - Fallback)
**Best for**: UI/UX component generation when Figma unavailable
**Use when**:
- Figma designs not available
- Creating new components from scratch
- Quick prototyping without design files
- UI pattern generation without existing designs

## Orchestration Rules

```typescript
interface MCPRoute {
  server: 'zen' | 'perplexity' | 'sequential' | 'context7' | 'figma' | 'magic';
  tool: string;
  reason: string;
  fallback?: MCPRoute;
}

class MCPOrchestrator {
  
  /**
   * Route to appropriate MCP server based on task
   */
  route(task: TaskContext): MCPRoute {
    // Web search routing
    if (this.needsWebSearch(task)) {
      return {
        server: 'perplexity',
        tool: task.requiresReasoning ? 'perplexity_reason' : 'perplexity_ask',
        reason: 'Real-time web information required'
      };
    }
    
    // Library documentation
    if (this.needsLibraryDocs(task)) {
      return {
        server: 'context7',
        tool: 'get-library-docs',
        reason: 'Official library documentation needed'
      };
    }
    
    // UI component generation - Figma first, Magic as fallback
    if (this.needsUIComponent(task)) {
      return {
        server: 'figma',
        tool: 'extract_component',
        reason: 'UI component from Figma design',
        fallback: {
          server: 'magic',
          tool: '21st_magic_component_builder',
          reason: 'Fallback to Magic for UI generation'
        }
      };
    }
    
    // Complex reasoning (default to Zen)
    if (this.needsComplexReasoning(task)) {
      return {
        server: 'zen',
        tool: this.selectZenTool(task),
        reason: 'Complex AI reasoning required'
      };
    }
    
    // Sequential thinking for step-by-step
    if (this.needsSequentialThinking(task)) {
      return {
        server: 'sequential',
        tool: 'sequentialthinking',
        reason: 'Step-by-step breakdown needed'
      };
    }
    
    // Default to Zen for general AI tasks
    return {
      server: 'zen',
      tool: 'chat',
      reason: 'General AI processing'
    };
  }
  
  /**
   * Detect if web search is needed
   */
  private needsWebSearch(task: TaskContext): boolean {
    const webIndicators = [
      'market research',
      'competitive analysis',
      'latest trends',
      'current best practices',
      'industry standards',
      'recent developments',
      'web search',
      'online research',
      'market data',
      'competitor information'
    ];
    
    return webIndicators.some(indicator => 
      task.description.toLowerCase().includes(indicator)
    );
  }
  
  /**
   * Select appropriate Zen tool
   */
  private selectZenTool(task: TaskContext): string {
    if (task.type === 'debug') return 'debug';
    if (task.type === 'analyze') return 'analyze';
    if (task.type === 'consensus') return 'consensus';
    if (task.type === 'review') return 'codereview';
    if (task.type === 'plan') return 'planner';
    if (task.type === 'deep_think') return 'thinkdeep';
    return 'chat';
  }
}
```

## Integration Patterns

### For Discovery Agent

```typescript
async function enhancedDiscovery(context) {
  const orchestrator = new MCPOrchestrator();
  
  // Market research via Perplexity
  if (context.needs_market_research) {
    const route = orchestrator.route({
      description: 'market research for competitor analysis',
      type: 'research'
    });
    
    const marketData = await mcp[route.server][route.tool]({
      messages: [{
        role: 'user',
        content: `Research market for: ${context.idea}`
      }]
    });
  }
  
  // Technical analysis via Zen
  const technicalRoute = orchestrator.route({
    description: 'deep technical analysis',
    type: 'analyze'
  });
  
  const analysis = await mcp.zen.analyze({
    // ... technical analysis params
  });
  
  return combineResults(marketData, analysis);
}
```

### For Business Strategist

```typescript
async function businessAnalysis(context) {
  const orchestrator = new MCPOrchestrator();
  
  // Always use Perplexity for market data
  const marketResearch = await mcp.perplexity.perplexity_ask({
    messages: [{
      role: 'user',
      content: `Market analysis for ${context.business_idea}:
                - Market size and growth
                - Key competitors
                - Industry trends
                - Regulatory landscape`
    }]
  });
  
  // Use Zen for strategic analysis
  const strategy = await mcp.zen.chat({
    prompt: `Analyze business strategy based on:
             Market data: ${marketResearch.content}`,
    model: 'gpt-5',
    thinking_mode: 'high'
  });
  
  return { marketResearch, strategy };
}
```

### For UX Architect

```typescript
async function uxResearch(context) {
  const orchestrator = new MCPOrchestrator();
  
  // Research current UX trends via Perplexity
  const uxTrends = await mcp.perplexity.perplexity_ask({
    messages: [{
      role: 'user', 
      content: `Latest UX trends and best practices for ${context.app_type}`
    }]
  });
  
  // Get framework patterns via Context7
  const frameworkPatterns = await mcp.context7.get_library_docs({
    context7CompatibleLibraryID: context.ui_framework,
    topic: 'accessibility patterns'
  });
  
  // Generate UI components - Figma first, then Magic
  let uiComponents;
  try {
    // Try Figma first for design consistency
    uiComponents = await mcp.figma.extract_component({
      file_key: context.figma_file_key,
      component_name: context.component_needs,
      format: 'react'
    });
  } catch (error) {
    // Fallback to Magic for generation
    uiComponents = await mcp.magic.component_builder({
      searchQuery: context.component_needs,
      standaloneRequestQuery: context.requirements
    });
  }
  
  return { uxTrends, frameworkPatterns, uiComponents };
}
```

## Routing Decision Tree

```yaml
routing_decision_tree:
  documentation_routing:
    library_official_docs: -> Context7      # Documentação oficial de libs
    general_web_research: -> Perplexity     # Pesquisa web geral
    
  level_1_check:
    needs_library_documentation:
      true: -> Context7                     # Prioridade para docs oficiais
      false: -> level_2_check
  
  level_2_check:
    needs_web_research:
      true: -> Perplexity                   # Pesquisa, tendências, mercado
      false: -> level_3_check
  
  level_3_check:
    needs_ui_component:
      true: -> Figma (fallback: Magic)      # UI com design consistency
      false: -> level_4_check
  
  level_4_check:
    needs_sequential_thinking:
      true: -> Sequential                   # Análise passo a passo
      false: -> level_5_check
  
  level_5_check:
    task_complexity:
      simple: -> Zen.chat
      moderate: -> Zen.analyze
      complex: -> Zen.thinkdeep
      consensus: -> Zen.consensus
      debug: -> Zen.debug

clear_separation:
  Context7:
    use_for:
      - TypeScript/JavaScript docs
      - Framework documentation (React, Vue, Angular)
      - ORM documentation (Drizzle, Prisma)
      - Runtime docs (Bun, Node.js)
      - Clean Architecture patterns
      - SOLID principles examples
    
  Perplexity:
    use_for:
      - Market research and trends
      - Competitive analysis
      - Best practices discovery
      - Technology comparisons
      - Current industry standards
      - General programming questions
  
  Zen_websearch:
    deprecated: true  # Usar Perplexity ou Context7 em vez disso
```

## Cost Optimization Strategy

```yaml
cost_optimization:
  perplexity:
    use_for: 
      - All web searches (replaces Zen web search)
      - Market research
      - Documentation lookups
    cost_benefit: "More accurate web data at lower cost"
  
  zen:
    use_for:
      - Complex reasoning
      - Code analysis
      - Architectural decisions
    avoid_for:
      - Simple web searches
      - Basic documentation lookups
  
  context7:
    use_for:
      - Official library docs only
    avoid_for:
      - General programming questions
  
  figma:
    use_for:
      - Primary UI component extraction
      - Design system consistency
    avoid_for:
      - Components without existing designs
  
  magic:
    use_for:
      - Fallback UI generation
      - Quick prototyping
    avoid_for:
      - Backend logic
      - When Figma designs exist
```

## Implementation Guidelines

### 1. Update Agent Configurations

Each agent should import and use the orchestrator:

```typescript
import { MCPOrchestrator } from './mcp-orchestrator';

class AgentWithOrchestration {
  private orchestrator = new MCPOrchestrator();
  
  async execute(task) {
    const route = this.orchestrator.route(task);
    console.log(`Routing to ${route.server}: ${route.reason}`);
    
    // Execute on selected server
    return await this.callMCPServer(route);
  }
}
```

### 2. Priority Rules

1. **Perplexity First**: For any web search needs
2. **Context7 Second**: For library documentation
3. **Figma Third**: For UI components from existing designs
4. **Magic Fourth**: Fallback for UI when Figma unavailable
5. **Sequential Fifth**: For step-by-step problems
6. **Zen Last**: For everything else (but most powerful)

### 3. Fallback Strategy

```typescript
const fallbackChain = {
  perplexity: ['zen.chat with websearch'],
  context7: ['perplexity', 'zen.chat'],
  figma: ['magic', 'manual component creation'],
  magic: ['manual component creation'],
  sequential: ['zen.planner'],
  zen: ['reduce complexity', 'break into parts']
};
```

## Usage Examples

### Example 1: Market Research Task

```typescript
// Automatically routes to Perplexity
const result = await orchestrator.route({
  description: "Research market size for AI coding assistants",
  type: "research"
});
// Result: { server: 'perplexity', tool: 'perplexity_ask' }
```

### Example 2: Architecture Design

```typescript
// Automatically routes to Zen
const result = await orchestrator.route({
  description: "Design microservices architecture",
  type: "deep_think"
});
// Result: { server: 'zen', tool: 'thinkdeep' }
```

### Example 3: UI Component Need

```typescript
// Automatically routes to Figma with Magic fallback
const result = await orchestrator.route({
  description: "Create dashboard component",
  type: "ui_component"
});
// Result: { 
//   server: 'figma', 
//   tool: 'extract_component',
//   fallback: { server: 'magic', tool: '21st_magic_component_builder' }
// }
```

## Performance Metrics

```yaml
expected_improvements:
  web_search_accuracy: +40%  # Using Perplexity vs Zen websearch
  cost_reduction: -30%        # Optimized routing
  response_time: -25%         # Direct routing vs trial-error
  quality_score: +15%         # Specialized servers
```

## Monitoring and Optimization

```typescript
class MCPMonitor {
  trackUsage(route: MCPRoute, result: any) {
    metrics.record({
      server: route.server,
      tool: route.tool,
      success: result.success,
      latency: result.latency,
      cost: result.cost,
      quality: result.quality_score
    });
  }
  
  optimizeRouting() {
    // Analyze metrics and adjust routing rules
    const usage = metrics.analyze();
    if (usage.perplexity.success_rate > usage.zen.websearch) {
      // Increase Perplexity priority for web tasks
      this.adjustPriority('perplexity', +1);
    }
  }
}
```