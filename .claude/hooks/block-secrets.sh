#!/bin/bash
# PreToolUse hook: blocks Write/Edit calls whose content matches known secret
# patterns. Exit code 2 rejects the tool call and feeds stderr back to the
# agent. Enforces Constitution Principle 6 (secrets never enter the repo)
# as a mechanism rather than an instruction.
# The heredoc occupies python's stdin, so the hook payload is passed via env.
HOOK_INPUT="$(cat)" python3 - <<'PY'
import json, os, re, sys

data = json.loads(os.environ.get("HOOK_INPUT") or "{}")
tool_input = data.get("tool_input", {})
content = "\n".join(str(tool_input.get(k, "")) for k in ("content", "new_string"))

# Placeholder values (as used in .env.example files) are allowed.
PLACEHOLDER = re.compile(r"YOUR_|CHANGE_?ME|PLACEHOLDER|EXAMPLE|xxx|<[^>]+>", re.I)

PATTERNS = [
    (r"-----BEGIN [A-Z ]*PRIVATE KEY-----", "private key material"),
    (r"\bAKIA[0-9A-Z]{16}\b", "AWS access key ID"),
    (r"\bghp_[A-Za-z0-9]{36}\b", "GitHub personal access token"),
    (r"\bgithub_pat_[A-Za-z0-9_]{22,}\b", "GitHub fine-grained token"),
    (r"\bsk-ant-[A-Za-z0-9_\-]{20,}\b", "Anthropic API key"),
    (r"\bsk-[A-Za-z0-9]{32,}\b", "API secret key"),
    (r"\bxox[baprs]-[A-Za-z0-9\-]{10,}\b", "Slack token"),
]

for pattern, label in PATTERNS:
    match = re.search(pattern, content)
    if match and not PLACEHOLDER.search(match.group(0)):
        print(
            f"Blocked: content matches a secret pattern ({label}). "
            "Constitution Principle 6: secrets never enter the repository. "
            "Use .env.example with placeholder values instead.",
            file=sys.stderr,
        )
        sys.exit(2)
PY
