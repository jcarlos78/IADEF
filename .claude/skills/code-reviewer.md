---
name: code-reviewer
description: Reviews the current diff (uncommitted or open PR) for bugs, security risks, constitution violations, and divergences from specs. Delegates the review to a clean-context subagent. Use before relevant commits or when the user asks "review what changed".
---

# Skill: code-reviewer

## Why a subagent

An agent that wrote the code is biased when reviewing it: its context contains the rationalizations that produced the bugs. The review therefore runs in a **clean context** — the `code-reviewer` subagent (defined in `.claude/agents/code-reviewer.md`) sees only the diff and the governing documents, exactly like a future maintainer would. Your job in this skill is orchestration, not judgment.

## When to activate

- Before commits that affect behavior
- When the user asks for an explicit review
- After implementation guided by a spec
- Before opening a PR

## Playbook

### 1. Identify the review scope

```bash
git diff --staged   # if anything is staged
git diff            # otherwise, working tree
```

For an open PR, use `gh pr diff <number>`.

### 2. Locate the governing documents

- `specs/constitution.md`
- The feature's `specs/<feature>/spec.md` and `plan.md` (the plan carries the sprint contract)
- Relevant ADRs in `docs/adr/`

### 3. Spawn the reviewer with a minimal brief

Launch the `code-reviewer` subagent. Pass **only**:

- How to collect the diff (the exact command from step 1)
- The document paths from step 2

Do **not** pass: summaries of the implementation conversation, justifications for choices made, or hints about which parts you're confident in. If the reviewer needs author context to understand the code, that's a finding, not a gap to pre-fill.

### 4. Deliver the report

Present the subagent's report to the human **verbatim** — do not soften blockers, do not pre-answer findings. The human decides what to fix, dismiss, or justify.

## Expected output

The subagent's structured Markdown report. **Do not commit nor apply changes** — this flow is read-only and advisory.
