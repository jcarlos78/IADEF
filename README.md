# GAIDE Project Template

GAIDE is a framework for disciplined AI-native software engineering.

Specification-driven development, agent skills, MCP integration, and human-in-command governance built into the workflow.

A pre-configured **Integrated Agentive Development Environment (IADE)** for disciplined vibe coding with AI assistants (Claude Code, Cursor, Windsurf, Codex, etc.).

Use this as the base for any new project where you want AI-assisted development with proper guardrails: spec-first, test-first, human-in-command.

## What you get out of the box

Three native amplifiers wired up and ready:

- **Skills** in `.claude/skills/` — reusable agent procedures (spec writing, code review, ADRs, test generation)
- **MCPs** in `.mcp.json` — Model Context Protocol server config (filesystem, postgres, GitHub, custom APIs)
- **SDD** in `specs/` — Spec-Driven Development structure with a working example

## Structure

```text
.
├── .claude/
│   ├── settings.json          Permissions, hooks, and model
│   ├── CLAUDE.md              Project briefing (auto-loaded by the agent)
│   ├── hooks/                 Deterministic enforcement scripts
│   │   ├── block-secrets.sh   Blocks secrets from entering the repo
│   │   ├── check-edited-file.sh  Per-file syntax check after every edit
│   │   ├── check-security.sh  SAST (semgrep) + dependency scan (osv-scanner) per edit
│   │   └── check-before-stop.sh  Blocks ending a turn with red tests or leaked secrets
│   ├── agents/                Subagents with clean contexts
│   │   ├── code-reviewer.md   Independent reviewer (sees only diff + docs)
│   │   └── security-reviewer.md  Security reviewer (authz logic, suppression audit)
│   └── skills/                Available skills
│       ├── spec-writer.md     Writes SDD specs
│       ├── code-reviewer.md   Reviews the current diff
│       ├── security-reviewer.md  Security review of the current diff
│       ├── verifier.md        Exercises features end-to-end vs. the spec
│       ├── adr-writer.md      Writes Architecture Decision Records
│       └── test-generator.md  Generates tests from specs
├── .github/workflows/         Outer harness: CI security scans (push/PR)
├── .pre-commit-config.yaml    Same scanners for human committers
├── .mcp.json                  Model Context Protocol config
├── specs/                     Spec-Driven Development
│   ├── constitution.md        Non-negotiable principles
│   ├── README.md              How to use the SDD flow
│   ├── template/              Spec / plan / tasks templates
│   └── example-feature/       Complete example (spec → plan → tasks)
├── docs/                      Project documentation
│   └── adr/                   Architecture Decision Records
├── PROGRESS.md                Session log (local only, gitignored)
├── init.sh                    Session bootstrap: bring-up + health check
├── src/                       Source code (empty by design)
├── tests/                     Tests
├── LICENSE                    MIT
└── README.md                  This file
```

## Getting started

### 1. Use this template

On GitHub, click **"Use this template"**. Or clone manually:

```bash
git clone <this-repo-url> my-project
cd my-project
rm -rf .git && git init
```

### 2. Customize

- Edit `.claude/CLAUDE.md` with your project briefing
- Adapt `specs/constitution.md` to your team's principles
- Edit `.mcp.json` to point at the systems you actually use (or remove servers you don't)
- Keep or drop skills as needed
- Install the security scanners so the inline security layer activates (hooks skip silently without them; CI still enforces):

  ```bash
  brew install semgrep gitleaks osv-scanner   # macOS
  # or: pipx install semgrep && go install github.com/zricethezav/gitleaks/v8@latest ...
  pipx install pre-commit && pre-commit install   # optional: same scanners for human commits
  ```

### 3. Open in your agentive IDE

- **Claude Code**: run `claude` in the project root
- **Cursor / Windsurf**: open the folder; both honor `.claude/`
- **Codex**: point the CLI at the directory

### 4. Start with the SDD flow

**Don't ask for code before writing a spec.** Use the `spec-writer` skill:

```text
/spec-writer I want to add: users can export their history as CSV
```

The skill walks you through: **spec → plan → tasks → implementation**, with a human gate at each step.

## The harness: what GAIDE uses and why

GAIDE applies **harness engineering** — the discipline of shaping the environment an AI agent operates in, popularized by Anthropic's work on [long-running agent harnesses](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) and [harness design](https://www.anthropic.com/engineering/harness-design-long-running-apps). The core insight: **instructions degrade, mechanisms don't**. An agent under context pressure will forget or rationalize away a rule written in prose; it cannot ignore a hook that rejects its tool call.

Each piece of the template exists for a specific failure mode of AI-assisted development:

| Mechanism | Failure mode it prevents |
| --- | --- |
| **Constitution** (`specs/constitution.md`) | Knowledge about "how we work here" living only in chat history |
| **Specs** (`specs/`) | Drift between what the app does and what people believe it does |
| **Hooks** (`.claude/hooks/`) | The agent violating critical rules (e.g. committing secrets) under pressure — enforcement is deterministic, not trust-based |
| **Deny permissions** (`.claude/settings.json`) | The agent reading credentials or running destructive commands, even accidentally |
| **`PROGRESS.md`** session log | Each session starting blind — context windows die, durable artifacts don't |
| **`init.sh`** session bootstrap | Building on top of broken inherited state — every session proves the app runs *before* new work |
| **Task status lifecycle** (`specs/template/tasks.md`) | "Done" meaning "I wrote code" — `done` requires passing tests, `verified` requires independent checking against the spec |
| **Clean-context review** (`.claude/agents/code-reviewer.md`) | Self-review bias — the context that wrote the code contains the rationalizations that produced its bugs, so the reviewer sees only the diff and the docs |
| **Sprint contracts** (`specs/template/plan.md`) | "Done" drifting during implementation — observable done-criteria are agreed before coding and checked one by one at review |
| **`verifier` skill** (+ Playwright MCP) | "Tests pass" being mistaken for "it works" — criteria reach `verified` only by exercising the running app as a user would |
| **ADRs** (`docs/adr/`) | Re-litigating settled decisions; losing the *why* behind the architecture |
| **Skills** (`.claude/skills/`) | Reinventing procedures ad hoc, with quality varying per session |
| **Principle 9** (tests are load-bearing) | The agent editing tests or task lists to make work *appear* done — a failure mode Anthropic observed directly in long-running agents |
| **Security hooks** (`check-security.sh`, gitleaks in the Stop hook) | Vulnerable code or dependencies entering silently — semgrep/osv-scanner findings block the edit and feed back while context is fresh |
| **Principle 10** (security findings are load-bearing) | The agent silencing scanners (`# nosemgrep`, ignore files) instead of fixing the vulnerability — suppressions only in dedicated, justified commits |
| **Security considerations** in specs (`specs/template/spec.md`) | Logic-level flaws no scanner sees (IDOR, authz bypass, tenant leakage) — abuse cases become negative acceptance criteria, tested and verified |
| **`security-reviewer` subagent** (`.claude/agents/`) | Scanner blind spots at review time — authorization reasoning, abuse-case coverage, and diffs that quietly disarm the scanners |
| **CI + pre-commit** (`.github/workflows/security.yml`, `.pre-commit-config.yaml`) | Hooks only guard the agent's session — CI and pre-commit extend the same scanners to every commit from anyone |

The adoption of these practices is recorded in [ADR 0001](docs/adr/0001-adopt-harness-engineering-practices.md) and [ADR 0002](docs/adr/0002-adopt-security-harness.md) (security harness).

## Philosophy

Vibe coding works best with guardrails. This template enforces a few non-negotiables (see `specs/constitution.md`):

1. **Spec before code** — describe observable behavior before generating implementation
2. **Tests track behavior** — every behavioral change needs tests
3. **Human approval before commit** — Human-In-Command (HIC) mode by default
4. **Comments explain *why*, not *what*** — naming documents the what
5. **Architectural decisions become ADRs** — immutable, traceable
6. **Secrets never enter the repo** — even in example files
7. **Atomic changes** — one concern per commit/PR
8. **Fail loudly, not silently** — no swallowed errors
9. **Tests and task lists are load-bearing** — never edited to make work *appear* done
10. **Security findings are load-bearing** — scanners are fixed against, never silenced

You can relax any of these as your team matures — but only via an explicit ADR.

## Suggested first steps after cloning

1. Read `specs/constitution.md` together as a team and edit it to match your beliefs.
2. Use `specs/example-feature/` as a reference for your first real spec.
3. Try one full loop: `spec-writer` → review → `test-generator` → implement → `code-reviewer`.
4. Document your first real architectural decision with the `adr-writer` skill.

## Contributing

This is a community template. PRs that improve the defaults, skills, or documentation are welcome. Please open an issue first to discuss substantial changes.

## License

[MIT](LICENSE) — free to use, modify, and distribute, including commercially.
