#!/bin/bash
# PostToolUse hook: security feedback right after a Write/Edit, same pattern
# as check-edited-file.sh. Two layers, each skipped silently when its tool is
# not installed (install semgrep and osv-scanner to activate — see README):
#   SAST  semgrep on the edited file (pinned registry rulesets, cached locally)
#   SCA   osv-scanner when the edited file is a dependency lockfile/manifest
# Exit 2 feeds findings back to the agent while the edit context is still
# fresh. Blocks only on findings — tool errors (offline registry, unsupported
# language) never block the edit. Full-repo scans belong to CI, not here.
FILE="$(HOOK_INPUT="$(cat)" python3 -c 'import json,os; print(json.loads(os.environ.get("HOOK_INPUT") or "{}").get("tool_input",{}).get("file_path",""))')"
[ -f "$FILE" ] || exit 0

case "$(basename "$FILE")" in
  package-lock.json|pnpm-lock.yaml|yarn.lock|requirements*.txt|poetry.lock|uv.lock|Pipfile.lock|go.mod|Cargo.lock|Gemfile.lock|composer.lock|pom.xml)
    command -v osv-scanner >/dev/null 2>&1 || exit 0
    OUT="$(osv-scanner scan source -L "$FILE" 2>&1)"
    STATUS=$?
    # exit 1 = known vulnerabilities; other non-zero codes are tool/setup errors
    if [ "$STATUS" -eq 1 ]; then
      { echo "Blocked: osv-scanner found known vulnerabilities in $(basename "$FILE")."
        echo "Resolve by moving to patched versions — findings are fixed, not suppressed (Constitution Principle 10)."
        echo "$OUT" | head -40; } >&2
      exit 2
    fi
    exit 0
    ;;
esac

command -v semgrep >/dev/null 2>&1 || exit 0
case "$FILE" in
  *.md|*.txt|*.csv|*.lock) exit 0 ;;
esac
OUT="$(semgrep scan --quiet --metrics=off --error --config p/security-audit --config p/secrets "$FILE" 2>&1)"
STATUS=$?
# with --error: exit 1 = findings; exit >= 2 = scan error (never blocks)
if [ "$STATUS" -eq 1 ]; then
  { echo "Blocked: semgrep flagged security finding(s) in $FILE."
    echo "Fix the code. If a finding is genuinely a false positive, suppress it in a dedicated commit that explains why (Constitution Principle 10)."
    echo "$OUT" | head -40; } >&2
  exit 2
fi
exit 0
