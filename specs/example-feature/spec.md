# Spec: Export history as CSV

> **Status:** approved (didactic example)
> **Author:** IADE Template
> **Date:** 2026-05-25

## Context

Authenticated users need to export their own activity history for offline analysis in tools like Excel. Today, history is only viewable on screen, which makes personal reporting cumbersome. This feature is part of the product's commitment to **user data portability**.

## Expected behavior

The application lets an authenticated user request and download a CSV file containing all of their activities within a selected date range.

### Use cases

1. **Main case — successful export**
   - Given: an authenticated user with 50 activities in the last 30 days
   - When: the user goes to "Settings > Export data" and selects "last 30 days"
   - Then: the system generates and makes available a file `history_<YYYYMMDD>.csv` with 50 rows, containing the columns `date`, `type`, `description`, `amount`

2. **Alternative case — empty range**
   - Given: an authenticated user with no activities in the selected range
   - When: the user requests an export
   - Then: the system generates a CSV with header only and shows the message "No activity in the selected range"

3. **Error case — unauthenticated user**
   - Given: a request without a valid session
   - When: the request hits the export endpoint
   - Then: HTTP 401 response with standard message; no data is exposed

4. **Edge case — very large range**
   - Given: a user with 50,000 activities over 5 years
   - When: they request a full export
   - Then: generation is queued in the background; the user receives an email with a download link valid for 24h

## Acceptance criteria

- [ ] An authenticated user can reach the export screen
- [ ] They can select a date range with start and end dates
- [ ] The generated CSV has the header `date,type,description,amount`
- [ ] Dates in the CSV use ISO 8601 (YYYY-MM-DD)
- [ ] The file name follows the pattern `history_<YYYYMMDD>.csv`
- [ ] Unauthenticated users get a 401, never data
- [ ] A user only sees their own activities (no cross-tenant leakage)
- [ ] Exports > 10,000 rows are processed asynchronously with email notification
- [ ] The async link expires in 24h

## Out of scope

- Export in formats other than CSV (PDF, native Excel, JSON)
- Editing/transforming data before export
- Scheduled/recurring exports
- Exporting other users' data (admin)

## Security considerations

- **Data sensitivity:** the export contains the user's full activity history (personal + financial data). Treat the generated file and the download link as sensitive.
- **Authentication / authorization:** only an authenticated user may export, and only their own history. Any request for another user's data is denied — there is no admin path in this feature (see Out of scope).
- **Abuse cases** (each mapped to a negative acceptance criterion above):
  - Tampering with the request to export another user's history → covered by "a user only sees their own activities"
  - Replaying an intercepted async link after expiry → covered by "the async link expires in 24h" (single-use signed token, see Risks)
  - Hammering the export endpoint to exhaust the worker queue → large exports are queued asynchronously; queue limits are the platform's concern, out of scope here

## Dependencies

- **Other specs:** authentication system (assumed pre-existing, `specs/auth/`)
- **External systems:** email service (via MCP `_email-service`)
- **Libraries:** the language's standard CSV library; no new dependency

## Constitution adherence

- **Principle 1 (Spec before code):** this spec was written before implementation ✓
- **Principle 2 (Tests track behavior):** 9 acceptance criteria → tests in [`tasks.md`](tasks.md), task 1
- **Principle 3 (Human approval):** HIC mode preserved
- **Principle 6 (Secrets):** no secret introduced
- **Principle 8 (Fail visibly):** async generation errors are logged and surfaced to the user

## Identified risks

- **Risk:** large synchronous exports could block the request → **Mitigation:** 10,000-row sync limit, anything above goes to the async queue (explicit criterion above)
- **Risk:** the async link could be intercepted → **Mitigation:** signed link with a single-use token, 24h expiry
