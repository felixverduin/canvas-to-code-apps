# Customer Spotlight

Last updated: 2026-10-15

- The user added the Dataverse `systemuser` table using the Code Apps CLI.
- Generated files: `src/generated/services/SystemusersService.ts` and `src/generated/models/SystemusersModel.ts`. Leave generated files unchanged.
- `src/Users.tsx` displays name, internal email, username, job title, and enabled/disabled status through `SystemusersService.getAll`.
- Reads 100 users per page with a continuation token and a Load more button; includes loading, empty, error, retry, and refresh states. No records are modified.
- Existing Vite/React logos and their fast spin and horizontal animations are retained.
- Validation: `npm run build` and `npm run lint` passed. Live Dataverse response has not been verified; use the authenticated Power Apps Local Play session.
- No deployment performed.
