# Wayfinder and tickets

The repository uses [Wayfinder Maps](https://github.com/rengwu/wayfinder-maps) for planning an effort whose decisions span multiple sessions. Skills live under `.agents/skills/` at the Git repository root. Existing Power Platform permissions and Code Bible rules still apply.

## Use

- `$wayfinder-maps <idea>`: establish the destination with the user and chart investigation tickets. Charting ends before resolving a ticket.
- `$wayfinder-maps <map issue URL>`: read the map and work one frontier ticket in a fresh session. Human-in-the-loop tickets require the user's live input.
- `$to-tickets <plan or spec>`: propose implementation slices and dependencies; publish after the user approves the breakdown, as required by that skill.

Supporting skills installed alongside these are `grill-me`, `research`, `prototype`, and `domain-modeling`. Existing project context and ADRs remain authoritative; domain modeling should extend them rather than replace them.

## GitHub tracker adapter

This file is the repository adapter for `wayfinder-maps`. Use GitHub Issues in the confirmed project repository through the authenticated `gh` CLI. Determine its `owner/repo` from `git remote -v`; if no remote is configured, ask the user for the target repository before tracker operations. Follow [issue-tracker.md](issue-tracker.md) and [triage-labels.md](triage-labels.md). Always pass `--repo owner/repo` with that confirmed repository to issue commands. Write multiline bodies and comments to temporary files and pass `--body-file`.

### Map and investigation tickets

- Create the map as a parent issue. Its body uses the skill's Destination, Notes, Decisions so far, Not yet specified, and Out of scope sections. Link ticket titles with their full issue URLs. Do not duplicate open-ticket lists or progress counts in the map.
- Create each investigation ticket as an issue with a `## Question` body. Add exactly one type label: `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, or `wayfinder:task`. Create missing labels when creating the first map, without changing the existing triage labels. Use `needs-triage` until the ticket has been evaluated; use `ready-for-agent` or `ready-for-human` according to the existing triage conventions.
- Attach tickets as native GitHub sub-issues of the map. Allocate every issue first, then wire native blocking dependencies in a second pass. With `gh api`, the relevant endpoints are `repos/{owner}/{repo}/issues/{number}/sub_issues` (POST with the child's numeric `sub_issue_id`) and `repos/{owner}/{repo}/issues/{number}/dependencies/blocked_by` (POST with the blocker's numeric `issue_id`). Numeric issue IDs differ from visible issue numbers; obtain IDs from the issue API.
- Read all sub-issue pages, their labels, comments, assignees, and dependencies. The frontier is an open, unclaimed ticket whose blockers are all resolved. Prefer the lowest issue number. A blocker closed as not planned is out of scope and does not unblock a dependent.
- Claim before work by assigning the ticket to the authenticated GitHub user and leaving a comment with a unique session identifier and UTC timestamp. Release the assignment when finishing. Run only one session per map: an assignee identifies a user, not independent sessions using the same account. Investigate a claim older than 72 hours; do not silently take another session's claim.
- Resolve with an answer comment, link any assets committed in the repository, close the issue as completed, release the claim, and add a linked one-line gist to Decisions so far. An issue closed without an answer is not a verified resolution.
- Rule out with an explanation comment, close as not planned, release the claim, and link it in Out of scope instead of Decisions so far. Preserve the issue and its references.
- If a later answer undermines a decision, record a warning linking the later ticket in the affected ticket and the map's decision gist. The optional GitHub mirror cannot represent `undermined_by`; read GitHub for these warnings.

Before ending a session, verify membership, labels, claims, and blocking edges; check for dangling references and cycles; confirm each resolution has an answer and map pointer; and remove fog that has become a ticket. Counts are derived. If native sub-issues or dependencies cannot be written, report the exact failure and leave the setup incomplete rather than silently substituting prose edges.

### Implementation tickets

For `to-tickets`, follow its context gathering, slicing, and user review steps. Override its default Step 5 storage with this repository's GitHub tracker: publish the approved slices as issues, include acceptance criteria and a source-plan link, then wire native dependencies after all issue IDs exist. Attach them to a parent implementation-plan issue if one exists. Implementation tickets use the repository's triage labels, not Wayfinder investigation-type labels. Keep the local source spec; do not maintain a second live ticket-status list in `.plan/<slug>/tickets.md`.

When the user requests implementation tickets in an existing Wayfinder map, attach them as native sub-issues of that map and extend its destination/notes to cover the approved implementation effort. Preserve the investigation decisions and distinguish local completion from live deployment. Use exactly one `type:feature` or `type:task` label for each implementation ticket. The viewer refresh maps those labels to its local `task` display type without altering GitHub labels. This tracking arrangement does not itself authorize implementation or environment changes.

## Optional viewer

The skills work without the Wayfinder binary. The upstream viewer reads local Markdown rather than GitHub directly. Its `scripts/wayfinder-pull` can mirror a parent issue and its sub-issues into `.plan/` using Bash, `gh`, and `jq`; mirrored output is a disposable cache and must be ignored by Git before using it. Do not edit a mirror as the source of truth.

Run `./scripts/Refresh-WayfinderPlans.ps1 -Repository owner/repo` with the confirmed project repository after updating any Wayfinder ticket state or map decisions in GitHub, before reporting completion. It automatically discovers all open and closed map issues whose titles start with `Wayfinder:` and whose bodies contain a `## Destination` section. Use this convention for every future map so it is included without script changes. The script reads GitHub only; it does not modify issues.

Each map gets an ignored viewer cache at `.plan/wayfinder/map-<issue-number>`. Existing caches are reused only when their source metadata matches the repository and issue number. A generated `github-source.json` records the repository and issue number so later title changes keep the same directory. New empty maps are supported. The required `-Repository owner/repo` parameter selects the project repository. Cache paths must not collide with an existing mirror from another repository.

The refresh includes answer comments, claims and blocking edges, and validates each map's tickets before writing that map's cache. Verify that completed tickets have a populated `## Answer` section and local links from their map. The viewer derives completion from that section, so closing a GitHub issue alone does not refresh the displayed map. Open or reload the affected cache directory in the viewer if it retains the old display. Cached files are disposable; retain source specs outside the ignored cache directories.

## Installation provenance

Installed from `rengwu/wayfinder-maps` commit `c252110ee01e36f4e17e4c9b0c6fc8cd1beb7aa0` on 2026-10-10 using the Codex skill installer. The six skill directories are upstream copies; repository-specific tracker behavior is defined here and referenced by `AGENTS.md`. License: [WAYFINDER-LICENSE](../../.agents/skills/WAYFINDER-LICENSE).
