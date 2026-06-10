# IADEF Project Template

AIDEF is a framework for disciplined AI-native software engineering.

Specification-driven development, agent skills, MCP integration, and human-in-command governance built into the workflow.

A pre-configured **Integrated Agentive Development Environment (IADE)** for disciplined vibe coding with AI assistants (Claude Code, Cursor, Windsurf, Codex, etc.).

Use this as the base for any new project where you want AI-assisted development with proper guardrails: spec-first, test-first, human-in-command.

## What you get out of the box

Three native amplifiers wired up and ready:

- **Skills** in `.claude/skills/` — reusable agent procedures (spec writing, code review, ADRs, test generation)
- **MCPs** in `.mcp.json` — Model Context Protocol server config (filesystem, postgres, GitHub, custom APIs)
- **SDD** in `specs/` — Spec-Driven Development structure with a working example

## Structure

```
.
├── .claude/
│   ├── settings.json          Permissions and model
│   ├── CLAUDE.md              Project briefing (auto-loaded by the agent)
│   └── skills/                Available skills
│       ├── spec-writer.md     Writes SDD specs
│       ├── code-reviewer.md   Reviews the current diff
│       ├── adr-writer.md      Writes Architecture Decision Records
│       └── test-generator.md  Generates tests from specs
├── .mcp.json                  Model Context Protocol config
├── specs/                     Spec-Driven Development
│   ├── constitution.md        Non-negotiable principles
│   ├── README.md              How to use the SDD flow
│   ├── template/              Spec / plan / tasks templates
│   └── example-feature/       Complete example (spec → plan → tasks)
├── docs/                      Project documentation
│   └── adr/                   Architecture Decision Records
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

### 3. Open in your agentive IDE

- **Claude Code**: run `claude` in the project root
- **Cursor / Windsurf**: open the folder; both honor `.claude/`
- **Codex**: point the CLI at the directory

### 4. Start with the SDD flow

**Don't ask for code before writing a spec.** Use the `spec-writer` skill:

```
/spec-writer I want to add: users can export their history as CSV
```

The skill walks you through: **spec → plan → tasks → implementation**, with a human gate at each step.

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
