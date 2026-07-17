# ADR 0002 — Adopt a security harness (SAST, secrets, SCA)

**Status:** accepted
**Date:** 2026-07-17

## Context

ADR 0001 turned the constitution's *process* principles into mechanisms, but security remained a single instruction-grade guardrail: a regex-based secret hook and one rubric line in the code reviewer. Meanwhile the highest-frequency security failure modes of AI-assisted development are mechanical and scanner-detectable: vulnerable code patterns generated confidently, vulnerable or hallucinated dependencies added casually, and secrets pasted into files. A fourth failure mode is not scanner-detectable at all: logic-level flaws (authorization bypass, IDOR, tenant leakage) that only a spec can define and only observation can verify.

Tool selection had one hard constraint: GAIDE is a stack-agnostic template, so every default scanner must be language-agnostic, run locally in seconds, and be freely installable — which selected **semgrep** (SAST), **gitleaks** (secrets), and **osv-scanner** (SCA) over per-language or CI-only alternatives (Bandit, gosec, CodeQL), which remain per-stack extensions.

## Decision

Extend the harness with a security layer at every level where a mechanism can live:

1. **Inline (hooks)** — `PostToolUse` runs semgrep on each edited file and osv-scanner on each edited lockfile/manifest (`check-security.sh`); the `Stop` hook adds a gitleaks pass over uncommitted changes. Findings block and feed back to the agent while the edit context is fresh.
2. **Commit (pre-commit)** — `.pre-commit-config.yaml` runs gitleaks + semgrep for *human* committers, so the harness covers everyone who touches the repo.
3. **Repo (CI)** — `.github/workflows/security.yml` runs all three scanners on push/PR; this is the enforcement backstop for the graceful degradation below.
4. **Spec (SDD)** — specs gain a mandatory **Security considerations** section (data sensitivity, authn/authz, abuse cases); abuse cases become negative acceptance criteria, flow into `test-generator` (abuse tests) and `verifier` (abuse cases exercised against the running app).
5. **Review** — a `security-reviewer` clean-context subagent covers what scanners cannot: authorization logic, abuse-case coverage, and an audit of scanner suppressions.
6. **Constitution** — **Principle 10**: security findings are load-bearing; suppressions only in dedicated, justified commits. Deny-permissions hardened (SSH/AWS/gcloud credential paths, pipe-to-shell installs).

Local scanners degrade gracefully: a missing tool skips silently rather than breaking sessions on machines without it. CI does not degrade — it fails.

## Consequences

- The template gains a soft dependency on semgrep, gitleaks, and osv-scanner; without them the inline layer is inert and only CI enforces. README documents installation.
- Semgrep registry rulesets require network on first use (cached afterwards); fully offline environments should vendor rules or rely on CI.
- Scanners produce false positives; the escape hatch is a suppression in a dedicated, explained commit (Principle 10) — friction is the point, silent suppression is the failure mode being blocked.
- Blocking on osv-scanner findings at lockfile-edit time can surface *pre-existing* vulnerable dependencies, not just newly added ones; that is treated as a feature (the debt becomes visible at the moment someone is already touching dependencies).
