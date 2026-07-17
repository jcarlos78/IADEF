# Tasks: Export history as CSV

> **Prerequisite:** `plan.md` approved ✓

---

## Task 1 — Generate tests from the spec
**Status:** pending
**Files:** `tests/exports/test_csv_export.py` (new)
**Description:** Invoke the `test-generator` skill pointing at `specs/example-feature/spec.md`. Verify traceability (9 criteria → tests).
**Done when:**
- [ ] Each spec criterion has at least one matching test
- [ ] All tests are red (expected — implementation doesn't exist yet)
**Estimate:** 30 min
**Depends on:** —

---

## Task 2 — Record ADR 0003 (CSV streaming)
**Status:** pending
**Files:** `docs/adr/0003-csv-streaming.md` (new)
**Description:** Use the `adr-writer` skill to record the decision between in-memory generation and streaming.
**Done when:**
- [ ] ADR follows the project template
- [ ] Alternatives considered and consequences documented
**Estimate:** 20 min
**Depends on:** —

---

## Task 3 — Implement synchronous `csv_exporter`
**Status:** pending
**Files:** `src/exports/csv_exporter.py` (new)
**Description:** Module that takes an iterable of activities and returns a CSV compliant with RFC 4180.
**Done when:**
- [ ] Exporter unit tests pass
- [ ] Correct quoting of fields containing commas, quotes, line breaks
**Estimate:** 45 min
**Depends on:** Task 1, Task 2

---

## Task 4 — Synchronous HTTP endpoint
**Status:** pending
**Files:** `src/exports/handlers.py` (new)
**Description:** `GET /api/exports/history?from=...&to=...` returns CSV inline for volumes < 10,000 rows.
**Done when:**
- [ ] Authentication required (401 without session)
- [ ] Filters only the authenticated user's data
- [ ] Headers `Content-Type: text/csv` and `Content-Disposition: attachment`
**Estimate:** 45 min
**Depends on:** Task 3

---

## Task 5 — Async queue for large volumes
**Status:** pending
**Files:** `src/exports/async_job.py` (new)
**Description:** Queue generation when volume > 10,000; persist signed link.
**Done when:**
- [ ] Job processed by an isolated worker
- [ ] Signed link with 24h TTL, single-use
**Estimate:** 60 min
**Depends on:** Task 4

---

## Task 6 — Email with download link
**Status:** pending
**Files:** `src/exports/email.py` (new)
**Description:** Send an email when async generation completes via MCP `_email-service`.
**Done when:**
- [ ] Email contains a working signed link
- [ ] Email template approved by the PO
**Estimate:** 30 min
**Depends on:** Task 5

---

## Task 7 — Export UI
**Status:** pending
**Files:** `src/ui/settings/ExportPanel.tsx` (new)
**Description:** Component in "Settings > Export data" with a date picker and a submit button.
**Done when:**
- [ ] Keyboard accessible
- [ ] Loading / success / error states visible
**Estimate:** 45 min
**Depends on:** Task 4

---

## Task 8 — Review via the code-reviewer skill
**Status:** pending
**Files:** —
**Description:** Run the `code-reviewer` skill over the full diff. Address any blockers.
**Done when:**
- [ ] No remaining blockers
- [ ] Suggestions assessed (accepted or justified)
**Estimate:** 30 min
**Depends on:** Tasks 3–7

---

## Task 9 — Final verification and merge
**Status:** pending
**Files:** —
**Description:** All tests green; human review; merge.
**Done when:**
- [ ] 9 spec criteria verified
- [ ] DoD complete
**Estimate:** 20 min
**Depends on:** Task 8

---

## Traceability

| Spec criterion | Task(s) | Status |
| --- | --- | --- |
| C1: reach screen | Task 7 | pending |
| C2: select range | Task 7 | pending |
| C3: CSV header | Tasks 1, 3 | pending |
| C4: ISO 8601 dates | Tasks 1, 3 | pending |
| C5: file name | Tasks 1, 4 | pending |
| C6: 401 without auth | Tasks 1, 4 | pending |
| C7: no cross-tenant leakage | Tasks 1, 4 | pending |
| C8: async > 10,000 | Tasks 1, 5, 6 | pending |
| C9: 24h link expiry | Tasks 1, 5 | pending |
