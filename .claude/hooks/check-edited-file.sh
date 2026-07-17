#!/bin/bash
# PostToolUse hook: fast per-file feedback right after a Write/Edit, so the
# agent sees breakage immediately instead of the human finding it at review.
# Exit 2 feeds stderr back to the agent. Checks are per-file and cheap; the
# full suite runs via init.sh and the Stop hook. Extend per stack (ruff,
# eslint, gofmt...) — keep each check under ~2s or it will drag every edit.
FILE="$(HOOK_INPUT="$(cat)" python3 -c 'import json,os; print(json.loads(os.environ.get("HOOK_INPUT") or "{}").get("tool_input",{}).get("file_path",""))')"
[ -f "$FILE" ] || exit 0

case "$FILE" in
  *.sh)
    ERRORS="$(bash -n "$FILE" 2>&1)" || { echo "$ERRORS" | head -20 >&2; exit 2; }
    ;;
  *.json)
    ERRORS="$(python3 -m json.tool "$FILE" 2>&1 >/dev/null)" || { echo "Invalid JSON in $FILE: $ERRORS" | head -20 >&2; exit 2; }
    ;;
  *.py)
    ERRORS="$(python3 -m py_compile "$FILE" 2>&1)" || { echo "$ERRORS" | head -20 >&2; exit 2; }
    ;;
esac
exit 0
