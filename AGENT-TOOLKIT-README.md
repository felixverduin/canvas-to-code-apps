# Agent toolkit for Power Platform projects

Reusable agent guidance, Code Bible chapters, scripts, and repository-local planning skills for session attendees.

## Contents

- `AGENTS.md`: agent workflow and Power Platform conventions.
- `docs/code-bible/`: five Power Platform Code Bible chapters.
- `.agents/skills/`: six separate skills: `wayfinder-maps`, `grill-me`, `domain-modeling`, `research`, `prototype`, and `to-tickets`, including their supporting resources.
- `.agents/skills/WAYFINDER-LICENSE`: keep this license when redistributing the skills.
- `docs/agents/`: GitHub tracker, triage, domain documentation, and Wayfinder adapter.
- `scripts/Refresh-WayfinderPlans.ps1`: optional GitHub-to-local Wayfinder viewer cache refresh.

## Project setup

1. Place these files at your project's repository root, preserving the directory structure. Initialize Git or use an existing clone before making project changes; create a branch according to AGENTS.md.
2. Create a root CONTEXT.md describing your project's purpose, terminology, solution name, publisher prefix, and environment strategy. Use your own publisher prefix in component names; `contoso` in examples is illustrative.
3. Configure your Git remote and confirm the target GitHub repository. The adapter uses GitHub Issues as the source of truth; authenticate the GitHub CLI locally and configure the labels described in docs/agents/. Never share credentials with an agent.
4. If using the optional viewer cache, add `.plan/wayfinder/` to your project's .gitignore and run:

   ```powershell
   ./scripts/Refresh-WayfinderPlans.ps1 -Repository 'your-account/your-repo'
   ```

   The repository parameter is required; there is no default target. The script requires PowerShell, Git, and an authenticated GitHub CLI. It reads GitHub and writes a disposable local cache. The optional Wayfinder viewer is installed separately.

Invoke skills by name, for example `$wayfinder-maps <idea>` or `$to-tickets <approved plan>`. The GitHub adapter overrides to-tickets' default local ticket storage. To use local Markdown instead of GitHub, follow `.agents/skills/wayfinder-maps/TRACKER-MARKDOWN.md` and update AGENTS.md and the tracker adapter consistently.

Keep the separate skill directories, supporting resources, and license together when distributing the toolkit. No global skill installation is needed for these repository-local copies.

These are local guidance and tooling files. Deployment or publishing is not required.
