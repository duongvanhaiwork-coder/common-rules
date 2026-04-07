# Backend Implement API

Implement the backend task end-to-end with API and data safety.

Requirements:

- Keep controller/handler thin; place business logic in service/use-case layers.
- Validate and sanitize all boundary input (HTTP/message/event).
- Preserve API and schema compatibility by default; if breaking, document impact.
- For write paths, consider transaction boundaries and idempotency behavior.
- Do not run destructive commands unless explicitly requested.
- Do not commit or push unless explicitly requested.
- Add/update tests for meaningful logic and contract changes.
- Run relevant checks (lint/test/build) and report verification status.

Return:

- What changed
- Contract/data impact
- Files touched
- Verification results and remaining risks
