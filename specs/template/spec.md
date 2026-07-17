# Spec: <Feature name>

> **Status:** draft | review | approved | implemented
> **Author:** <name>
> **Date:** YYYY-MM-DD

## Context

Why this feature exists. What problem it solves. For whom.

## Expected behavior

What the application should do. Does **not** include how to implement it.

### Use cases

1. **Main case**
   - Given: <precondition>
   - When: <action>
   - Then: <expected result>

2. **Alternative case**
   - Given: ...
   - When: ...
   - Then: ...

3. **Error case**
   - Given: ...
   - When: ...
   - Then: ...

## Acceptance criteria

Verifiable list. Each item must be testable:

- [ ] Criterion 1 — <objectively verifiable>
- [ ] Criterion 2 — ...
- [ ] Criterion 3 — ...

## Out of scope

Explicitly list what this feature does **not** do:

- ...

## Security considerations

Answer explicitly — "none" is an acceptable answer, silence is not:

- **Data sensitivity:** what data does this feature touch? (PII, credentials, financial, none)
- **Authentication / authorization:** who may invoke this behavior? What must be denied, and to whom?
- **Abuse cases:** how would a hostile user misuse this feature? Each abuse case becomes a **negative acceptance criterion** above (something that must observably NOT happen) — scanners catch code-level flaws; only the spec catches logic-level ones (IDOR, authorization bypass, data leakage between tenants).

## Dependencies

- Other specs: <links>
- External systems: <which; via MCP / via lib / via API>
- Libraries: <new ones, if any — justify>

## Constitution adherence

Mark how each relevant principle is honored:

- **Principle 1 (Spec before code):** this spec was written before implementation ✓
- **Principle 2 (Tests track behavior):** acceptance criteria will be mapped to tests via the `test-generator` skill.
- **Principle 3 (Human approval):** implementation will wait for approval after the spec.
- **Other relevant principles:** ...

## Identified risks

- Risk: <description> | Mitigation: <how>
