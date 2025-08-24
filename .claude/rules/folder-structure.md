# Folder Structure

## Project Organization

```
src/
├── domain/                        # Core business logic (zero dependencies)
│   ├── entities/                  
│   ├── value-objects/             
│   ├── services/                  
│   ├── ports/                     
│   └── errors/                    
│
├── application/                   # Use cases and orchestration
│   ├── use-cases/                 
│   ├── dtos/                      
│   ├── mappers/                   
│   └── validators/                
│
├── infrastructure/                # External implementations
│   ├── database/                  
│   │   ├── repositories/          
│   │   ├── migrations/            
│   │   └── schemas/               
│   ├── external/                  
│   └── services/                  
│
├── presentation/                  # User interfaces
│   └── api/                       
│       ├── controllers/           
│       ├── middlewares/           
│       └── routes/                
│
├── config/                        # Configuration
└── main.ts                        # Application entry

tests/                             # Only shared test resources
├── setup/                         
├── mocks/                         
├── helpers/                       
├── integration/                   
└── e2e/                          
```

## Key Principles

- **Colocate unit tests** in `__tests__` folders next to code
- **No shared/utils folders** - Colocate by domain context
- **Dependencies flow inward** - Infrastructure → Application → Domain

## File Naming

See `naming-conventions.md` for all file and directory naming rules.

For detailed examples and patterns, consult @agent-software-architect