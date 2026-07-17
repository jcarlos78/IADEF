# Project Briefing

> **How to use this file:** the IADE agent reads this automatically on start. Fill in the sections marked with `[ ]`.

---

## Overview

**Project name:** `[PROJECT NAME]`

**One-line description:** `[WHAT THE APPLICATION DOES]`

**Current status:** `[concept | in development | in production | in maintenance]`

## Tech stack

- **Primary language:** `[e.g., Python 3.12 / Node.js 22 / Go 1.23]`
- **Framework:** `[e.g., FastAPI / Next.js / etc.]`
- **Database:** `[e.g., PostgreSQL 16]`
- **Deployment:** `[e.g., GCP Cloud Run / AWS ECS / on-prem k8s]`

## Relevant folder structure

```text
.
├── .claude/                IADE agent configuration (settings, hooks, skills)
├── specs/                  SDD specs — source of truth for behavior
├── docs/adr/               Architecture Decision Records
├── PROGRESS.md             Session log — read at start, update at end
├── src/                    Source code
└── tests/                  Tests
```

## Session protocol

- **At session start:** run `./init.sh` (environment bring-up + health check — a failure means inherited broken state), then read `PROGRESS.md` and the recent `git log` to understand where the last session left off. If the previous session left something broken, fix that before starting new work. `PROGRESS.md` is local and gitignored — if it doesn't exist yet, create it (title + dated entries with done / next / known issues, newest first).
- **At session end:** append an entry to `PROGRESS.md` (done / next / known issues).

## Mandatory operating principles

Before any code change, the agent MUST:

1. **Read the constitution** at `specs/constitution.md`.
2. **Check whether a spec exists** for the feature at `specs/<feature>/spec.md`.
3. **If no spec exists**, propose writing one using the `spec-writer` skill before coding.
4. **Follow the SDD flow**: spec → plan → tasks → implementation.
5. **Never edit tests or task lists to make work appear done** (Constitution Principle 9).

## Code conventions

- `[e.g., ESLint config / Black + Ruff / gofmt]`
- `[e.g., tests required for every public function]`
- `[e.g., Conventional Commits]`

## Critical integrations

`[List internal systems this project integrates with. For each, indicate whether there's an MCP configured.]`

- `[System X]` — `[via MCP / via REST API / via client library]`

## How the agent should work

- **Current autonomy mode:** HIC (every code change requires explicit human approval before commit).
- **Change size:** prefer small, atomic changes. No sweeping refactors without an ADR.
- **Comments:** only when the *why* is not obvious from the code.
- **Tests:** changing code that affects behavior without changing/adding tests is forbidden.
- **Logging:** follow the convention defined in `docs/adr/0002-logging-strategy.md` (create one if missing).

## Available skills

See `.claude/skills/`:

- `spec-writer` — write SDD specs
- `code-reviewer` — review the current diff (delegates to the clean-context subagent in `.claude/agents/code-reviewer.md`; never pass it the implementation conversation)
- `adr-writer` — record architectural decisions
- `test-generator` — generate tests from a spec

## Contacts and governance

- **Maintainers:** `[names / emails]`
- **Review channel:** `[e.g., GitHub PR / Slack #channel]`
- **Human-response SLA:** `[e.g., 24h on business days]`
