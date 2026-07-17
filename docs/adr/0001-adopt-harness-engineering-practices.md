# ADR 0001 — Adopt harness engineering practices

**Status:** accepted
**Date:** 2026-07-17

## Context

GAIDE's guardrails were, until now, *instructions*: the constitution asks the agent to behave, and the agent is trusted to comply. Anthropic's published work on harnesses for long-running agents ([Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents), [Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps)) shows that instructions degrade under context pressure, while three things hold up: deterministic enforcement (hooks, permissions), durable state artifacts between sessions, and empirical verification separated from generation.

## Decision

Incorporate harness engineering into GAIDE in phases, tracked in [`docs/harness-roadmap.md`](../harness-roadmap.md):

1. **Deterministic enforcement** — hooks and deny-permissions turn critical constitution principles into mechanisms (starting with a `PreToolUse` secret-blocking hook and expanded deny rules).
2. **State across sessions** — `PROGRESS.md` as a session log; session start/end protocol in `CLAUDE.md`.
3. **Role separation** — reviewer runs with a clean context; done-criteria agreed before implementation.
4. **Empirical verification** — browser/E2E verification of features against spec acceptance criteria.
5. **Harness hygiene** — re-examine guardrails on each new model generation.

Principle 9 (tests and task lists are load-bearing) is added to the constitution as part of phase 1.

## Consequences

- The template gains files that are not documentation (`.claude/hooks/`, `PROGRESS.md`) and adopters must keep them.
- Hooks require `python3` on the host; teams without it must port or drop the hook.
- Guardrails-as-mechanisms can produce false positives (e.g. secret-pattern matches on legitimate content); the escape hatch is editing the hook, which is itself a reviewable change.
