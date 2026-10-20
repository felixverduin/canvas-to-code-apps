# Agent Instructions

## Project Context

- This repository contains a Power Platform project. Read CONTEXT.md for its purpose, solution name, publisher prefix, and environment details.
- Read `CONTEXT.md` before making project, Dataverse, Power Apps, Power Automate, or solution-level changes.
- Confirm the environment strategy in CONTEXT.md before applying changes. Treat changes as production-impacting when the environment is shared or its purpose is unknown.

## Git Workflow
- Always create a new branch for any change. Never commit directly to `main` or `develop`.
- Use the following naming convention exactly:
  - Features: `feature/short-description`
  - Bug fixes: `fix/short-description`
  - Chores/Refactoring: `chore/short-description`
- Keep branch names lowercase, using hyphens instead of spaces (e.g., `feature/dark-mode`).

## Code Bible

The Code Bible in `docs/code-bible/` is the mandatory source for naming conventions and implementation practices.

Before creating, renaming, or materially changing Power Platform components, read the relevant Code Bible chapter:

- Canvas apps and custom pages: `docs/code-bible/Canvas-Apps.md`
- Copilot Studio agents, topics, prompts, and entities: `docs/code-bible/Copilot-Studio.md`
- Dataverse tables, columns, choices, relationships, security roles, plugins, APIs, environment variables, and connection references: `docs/code-bible/Dataverse.md`
- Model-driven apps, forms, tabs, sections, views, command bars, sitemap items, JavaScript, plugins, PCFs, and deployment behavior: `docs/code-bible/Model-Driven-Apps.md`
- Power Automate flows, triggers, actions, variables, scopes, child flows, connection references, and solution structure: `docs/code-bible/Power-Automate.md`

## Required Workflow

- State which Code Bible chapter applies before creating new Power Platform assets.
- Follow the naming conventions from the relevant chapter for all new components.
- If a user request conflicts with the Code Bible, explain the conflict before making the change.
- Prefer solution-aware Power Platform changes and keep new assets inside the project's designated solution unless the user explicitly asks otherwise.
- Avoid destructive changes to Dataverse schema, solution components, apps, or flows unless the user explicitly approves the impact.
- If a Code Bible rule, best practice, naming convention, or requested implementation step cannot be executed, tell the user exactly what was not done and why, so the user can complete it manually if needed.
- Always check whether implementation changes require deployment or publishing before calling the work complete. Report whether deployment is required, completed and verified, or still pending; local edits and passing tests alone do not establish that the live app or environment has changed. Follow the authentication and permission requirements below before applying environment changes.

- Agent Standard: When the user requests direct environment changes, agents will follow an interactive apply pattern: the user must authenticate in the local terminal (PAC CLI or equivalent) and grant the agent permission to run the required commands. Agents will not request or accept secrets; they will use the authenticated session in the workspace terminal to perform changes. This interactive authenticate-and-apply pattern is the standard for direct, environment-changing operations in this repository.

## Documentation

- Update `CONTEXT.md` when project-level facts change, such as environment strategy, solution naming, architecture, or operational constraints.
- Keep implementation notes close to the relevant component or workflow instead of relying only on chat history.

## Learning-first code style

Assume the repo owner is learning TypeScript and React.

When adding or changing TypeScript or React code, add helpful comments that
explain what the code does and why it exists. Comments should teach the local
idea behind the code, especially for:

- React state, props, hooks, memoized values, and event handlers.
- TypeScript types, interfaces, unions, generics, and non-obvious narrowing.
- Data transformations such as filtering, sorting, grouping, and mapping.
- Power Apps host integration, generated services, connector calls, and
  Dataverse-facing assumptions.
- Any workaround, tradeoff, or demo-specific simplification.

Prefer comments above a meaningful block of code. Avoid comments that merely
repeat the syntax, such as "increment i" or "return the value". The best
comments should help a TypeScript/React beginner understand the intent, the
inputs, the output, and the reason the code is shaped that way.

## Agent skills

### Issue tracker

Issues and PRDs are tracked in GitHub Issues for this project. Confirm the target repository from its Git remote before using the tracker. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the default mattpocock/skills triage label vocabulary. See `docs/agents/triage-labels.md`.

### Domain docs

This is a single-context repo with root `CONTEXT.md` and ADRs under `docs/adr/` when needed. See `docs/agents/domain.md`.

### Wayfinder and tickets

Repository-scoped Wayfinder skills are installed in `.agents/skills/`. When asked to use Wayfinder, read `.agents/skills/wayfinder-maps/SKILL.md` and use `docs/agents/wayfinder.md` as the repository's GitHub tracker adapter. GitHub Issues in the confirmed project repository are the source of truth for maps and tickets.

Use `to-tickets` for implementation slices after the decisions are clear; use Wayfinder for investigation tickets. Follow the repository adapter when publishing either kind. Installing these skills does not authorize creating a map for an unspecified effort, resolving tickets, or making Power Platform environment changes.

- Before starting a requested feature or plan, check whether an existing ticket or Wayfinder map covers it. If no ticket covers the request, ask the user whether to create a full Wayfinder plan for the feature or effort before proceeding with implementation. Do not create a map automatically; the user may choose direct work instead.
- When picking up a Wayfinder ticket, read the map, the skill, and the repository adapter first. Check blockers and existing claims, then claim the ticket before starting work. Keep its GitHub state, labels, assignment, and claim comments consistent with the adapter throughout the session; do not invent a separate status scheme or maintain a duplicate local status list.
- Before ending ticket work, update its status to match the actual outcome using the adapter's workflow. Resolve only after recording the answer and linking the decision from the map; rule out work with an explanation and the appropriate map pointer. Keep unfinished or blocked work open, record what remains, and release the claim when finishing the session. Verify the ticket and map agree, and report any tracker update that could not be completed.
- After changing any Wayfinder ticket state or map decisions in GitHub, run `./scripts/Refresh-WayfinderPlans.ps1 -Repository owner/repo` with the confirmed project repository from the repository root before reporting completion. Verify the affected ignored viewer cache reflects the change: completed tickets must have a populated `## Answer` section and a local map link. GitHub remains the source of truth; closing an issue alone does not refresh the viewer. Follow `docs/agents/wayfinder.md`, and report any refresh failure explicitly.
- For implementation tickets, include the deployment check in the completion assessment and record any pending deployment or publishing explicitly. A Wayfinder investigation ticket may resolve with a decision alone; that does not imply the feature has been implemented or deployed.
