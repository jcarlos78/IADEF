# Harness Engineering Roadmap

> **What this is:** the phased plan for incorporating harness engineering practices into GAIDE, tracked as a checklist so any session (human or agent) knows what is done and what comes next. Update this file at the end of every working session that touches the roadmap.
>
> **Sources:** Anthropic's [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) and [Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps).

**Guiding principle:** a rule that matters becomes a *mechanism* (hook, permission, artifact), not an instruction the agent is asked to remember.

---

## Phase 1 — Deterministic enforcement ✅

Turn the constitution's most critical principles into mechanisms that cannot be ignored.

- [x] Create this roadmap document
- [x] `PreToolUse` hook blocking secrets in `Write`/`Edit` calls (`.claude/hooks/block-secrets.sh`) — enforces Principle 6
- [x] Expand `permissions.deny` in `.claude/settings.json` (`.env` reads, key files, force pushes)
- [x] Add **Principle 9** to the constitution: tests and task lists are load-bearing — never edited to make work appear done
- [x] ADR 0001 recording the adoption of harness engineering practices
- [x] Update README with "What's in the harness and why" section

## Phase 2 — State across sessions ✅

Give agents durable memory of the *work* (specs already cover the *product*).

- [x] `PROGRESS.md` at repo root — structured session log (what was done, what's next, known issues); local and gitignored by decision
- [x] Session protocol in `.claude/CLAUDE.md`: start = read `PROGRESS.md` + recent `git log`; end = update `PROGRESS.md`
- [x] Evolve `specs/template/tasks.md` to per-task status tracking (`pending | in-progress | done | verified`)
- [x] `init.sh` template — environment bring-up + health check, run at session start to catch broken state early

## Phase 3 — Role separation with clean contexts ✅

An agent that wrote the code is biased when evaluating it.

- [x] Rework `code-reviewer` skill to run as a subagent with a clean context (receives only diff + spec, never the implementation conversation) — subagent defined in `.claude/agents/code-reviewer.md`
- [x] "Sprint contracts": add a *verifiable done-criteria* section to `specs/template/plan.md`, agreed before implementation, checked one by one at review

## Phase 4 — Empirical verification

"Tests pass" ≠ "the feature works". The agent must observe the running application.

- [ ] Add Playwright MCP as a commented-out option in `.mcp.json`
- [ ] New `verifier` skill: exercise the feature end-to-end as a user would, against the spec's acceptance criteria
- [ ] `PostToolUse` hook running lint/tests after edits (auto-detect project type; no-op when unconfigured)
- [ ] `Stop` hook: warn when the agent ends a turn with failing tests or a diff without a matching spec

## Phase 5 — Harness hygiene

Guardrails have expiry dates.

- [ ] Stop pinning a model in `.claude/settings.json` (or pin latest with a comment explaining the trade-off)
- [ ] Constitution note: re-examine the harness on every new model generation — remove scaffolding that is no longer load-bearing (via ADR, mechanism already exists)

---

## Session log

- **2026-07-17 — Phase 1:** implemented in full; `PROGRESS.md` and the session protocol from Phase 2 were pulled forward.
- **2026-07-17 — Phase 2:** completed — task status lifecycle in the SDD templates, `init.sh` session bootstrap. Decision: `PROGRESS.md` is local-only (gitignored), commits carry no AI attribution.
- **2026-07-17 — Phase 3:** completed — `code-reviewer` split into orchestrating skill + clean-context subagent (`.claude/agents/`); sprint contract section in plan template and example.
