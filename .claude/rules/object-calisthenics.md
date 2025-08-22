# Object Calisthenics

## 9 Rules for Better Object-Oriented Code

### 1. Only One Level of Indentation per Method
Use early returns and extract methods to avoid deep nesting.

### 2. Don't Use the ELSE Keyword
Use early returns, polymorphism, or strategy pattern instead.

### 3. Wrap All Primitives and Strings
Create value objects for business concepts (Email, Money, etc.)

### 4. First Class Collections
Any class with a collection should contain no other member variables.

### 5. One Dot per Line
Follow the Law of Demeter - don't chain method calls.

### 6. Don't Abbreviate
Use full, meaningful names (not `usr` but `user`).

### 7. Keep All Entities Small
- Classes: < 50 lines
- Methods: < 5 lines
- Packages: < 10 classes

### 8. No Classes with More Than Two Instance Variables
Forces high cohesion and better encapsulation.

### 9. No Getters/Setters/Properties
Tell, don't ask. Objects should expose behavior, not data.

## Pragmatic Application

**Not all rules apply everywhere.** Use judgment:

- Rules 1, 2, 6: Always apply
- Rules 3, 5: Apply in domain layer
- Rules 4, 7, 8, 9: Consider based on context

## Benefits

- Higher cohesion
- Better encapsulation
- Easier testing
- More maintainable code
- Clearer intent