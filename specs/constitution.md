# Project Constitution

> The **constitution** is the document of **non-negotiable principles** for this project. It functions as a contract with any agent (human or AI) operating on the repository. Unlike a style guide, principles here are not broken without an explicit ADR.

---

## Principle 1 — Spec before code

Any change that affects observable behavior of the application requires a **versioned spec** at `specs/<feature>/spec.md`, approved before implementation. Trivial bug fixes (no behavioral change) are exempt; behavioral changes are not.

**Why:** prevents drift between what the application does and what people believe it does. In environments with generative agents, without versioned specs the knowledge about the system migrates into an untraceable prompt history.

---

## Principle 2 — Tests track behavior

Changes that alter behavior without changing or adding tests are forbidden. Tests reflect the acceptance criteria of the spec.

**Why:** keeps spec, code, and validation equivalent. In vibe coding, tests are the only external anchor that prevents uncritical acceptance of generated diffs.

---

## Principle 3 — Human approval before commit

The project's default configuration is **HIC (Human-In-Command)**: every code change proposed by an agent requires explicit human approval before commit. Switching to more autonomous modes (HOTL, HOOTL) requires an ADR.

**Why:** matches the current maturity of generative agents. Allows progressive migration toward more autonomy, but as a conscious, auditable decision.

---

## Principle 4 — Comments explain *why*, not *what*

Comments describing what the code does are forbidden. Comments about **why** a non-obvious choice was made are welcome: hidden constraints, subtle invariants, documented workarounds.

**Why:** well-named code already documents the *what*. Redundant comments age and lie; comments about *why* stay relevant.

---

## Principle 5 — Architectural decisions become ADRs

Any relevant architectural decision (stack choice, structural pattern, significant trade-off) is recorded at `docs/adr/NNNN-title.md` before implementation. ADRs are immutable once accepted — decisions change via a new ADR.

**Why:** lets future team members — human or AI — understand the historical reasoning of the project.

---

## Principle 6 — Secrets never enter the repository

Credentials, tokens, API keys, and similar are never committed, even in example files. Use `.env.example` with placeholder values. The agent is instructed to refuse commands that write secrets into versioned files.

**Why:** secrets in commits live forever in git history, even after removal. It's a common incident vector for teams that adopt vibe coding without discipline.

---

## Principle 7 — Atomic changes

Each PR/commit addresses a single concern. Changes that combine refactor + new feature + bug fix are split.

**Why:** makes review (human and `code-reviewer` skill) easier, simplifies rollbacks, improves bisect.

---

## Principle 8 — Fail visibly, not silently

Operational errors are not swallowed. Logs at appropriate levels, monitoring where applicable, exceptions propagated to where they can be handled with context.

**Why:** silencing errors is a classic temptation in agent-generated code. Silently-failing systems accumulate invisible debt.

---

## Principle 9 — Tests and task lists are load-bearing

Deleting or weakening a test, or removing/re-marking a task, to make work *appear* done is forbidden. A failing test is fixed by fixing the code or — if the test itself is wrong — by changing it in a dedicated commit that explains why. Task status only moves forward when the work actually happened.

**Why:** Anthropic's harness engineering work found that long-running agents, under pressure to show progress, edit tests and task lists instead of the code. Tests and task lists are the external record of truth; if they can be quietly rewritten, every other principle loses its anchor.

---

## How to modify this constitution

1. Propose the change in a dedicated PR, with no other changes in the same PR.
2. A constitution-modifying PR requires approval from **all** maintainers listed in `.claude/CLAUDE.md`.
3. Once accepted, create an ADR recording the change and its motivation.
4. Communicate explicitly to the team.
