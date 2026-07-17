#!/bin/bash
# Stop hook: before the agent ends its turn with uncommitted changes, make
# sure the configured test suite is green. Exit 2 blocks the stop and feeds
# stderr back to the agent (Principle 8: fail visibly). No-ops when there is
# no diff or no test runner configured.
HOOK_INPUT="$(cat)"

# Guard against blocking loops: if this hook already fired for this stop,
# let the agent finish (it has seen the failure and reported it).
echo "$HOOK_INPUT" | python3 -c 'import json,sys; sys.exit(1 if json.load(sys.stdin).get("stop_hook_active") else 0)' || exit 0

git diff --quiet && git diff --staged --quiet && exit 0

# Secrets: git-aware scan of the uncommitted changes. Deeper than the
# PreToolUse regex hook (entropy + full ruleset), and catches files that
# entered via Bash instead of Write/Edit. Skipped silently when gitleaks is
# not installed; blocks only on leaks (exit 1), never on tool errors.
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks protect --no-banner --redact >/dev/null 2>&1
  if [ $? -eq 1 ]; then
    echo "Stop blocked: gitleaks found secret(s) in the uncommitted changes. Remove them before ending (Constitution Principle 6); run 'gitleaks protect --redact' to see the findings." >&2
    exit 2
  fi
fi

if [ -f package.json ] && grep -q '"test"' package.json; then
  npm test --silent >/dev/null 2>&1 || {
    echo "Stop blocked: uncommitted changes with a failing test suite (npm test). Fix the tests or report the failure explicitly before ending." >&2
    exit 2
  }
elif command -v pytest >/dev/null 2>&1 && [ -d tests ]; then
  pytest -q >/dev/null 2>&1
  STATUS=$?
  # exit 5 = no tests collected; acceptable for a fresh template
  if [ "$STATUS" -ne 0 ] && [ "$STATUS" -ne 5 ]; then
    echo "Stop blocked: uncommitted changes with a failing test suite (pytest). Fix the tests or report the failure explicitly before ending." >&2
    exit 2
  fi
fi
exit 0
