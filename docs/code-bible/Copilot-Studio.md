# Copilot Studio

## Naming & Organization

### Naming summary

| Artifact Type | Convention Pattern | Example(s) |
| --- | --- | --- |
| **Agents** | SolutionName – Purpose | SolutionName – Assistance Agent |
| **Topics** | Topic_Category – Purpose | Certificate_Management – Request |
| **Entities** | lowercase_with_underscores | certificate_type, request_status |
| **Flows (Actions)** | FlowName – Purpose | Certificate – Retrieve Details |
| **Plugins** | PluginName – Purpose | ValidateCertificate – ExpiryDateCheck |
| **Connectors** | ConnectorName – TargetSystem | CertificateConnector – SharePoint |
| **Fallback Topics** | Fallback – Purpose | Fallback – General Help |
| **Logs / Analytics IDs** | SolutionName – LogType | SolutionName – Conversation Log |
| **Session Variables** | session_variableName (camelCase) | session_userEmail, session_topicContext |

### Agent Naming

- Name agents for their business purpose.
    - Example: _Certificate Assistant_.

- Keep names short (2–4 words) and business-oriented—avoid technical jargon.
- Always include the owning department or process in the internal name (e.g., `Ops – Permit Request Helper`).
- Avoid using “test” or “demo” in production agent names.
- Reference: [Create and manage copilots in Microsoft Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/copilot-overview).

### Topic Naming

- Follow a consistent pattern: **Intent – Context** (e.g., `Request – New Certificate`, `Report – Missing Access`).
- Use Title Case for display names and lowercase_with_underscores for internal identifiers (e.g., `request_new_certificate`).
- Keep topics specific and action-focused; avoid generic titles like “General Help” or “Information.”
- For shared components (like authentication or small talk), use a prefix to indicate scope: `sys_` for system topics, `common_` for reusable ones.
- Include a **short description** in the topic metadata explaining its trigger phrases and purpose.

## Conversation Design & Prompting

### System Prompts

- Define the agent’s role, goals, capabilities, and limitations in system prompts.
- Keep prompts concise and business-specific; describe tasks rather than stylistic responses.
- Use neutral instructions, e.g., “Provide concise answers about certificate requests based on user input.”
- Avoid including organization-sensitive or internal instructions in prompt text visible to users.
- Test prompts regularly against real scenarios and expected outcomes.

### Topic Flow Design

- Make topics modular, with one intent each (e.g., Create Certificate).
- Include natural-language trigger phrases and variations.
- Apply branching logic sparingly; prefer guided questioning using yes/no or multiple-choice responses.
- Keep dialog short and purposeful — avoid more than 5–7 messages per topic before reaching a resolution.
- Use **redirects** between topics for shared functionality (e.g., authentication or record lookup).
- Test paths regularly for unreachable states.

### Tone and Style

- Maintain a consistent, professional tone aligned with **Microsoft’s Copilot design guidelines**.
- Be helpful, factual, and polite; avoid excessive friendliness or humor.
- Use concise sentences accessible to business users.
- Personalize responses by acknowledging user input where relevant (“I’ve found your certificate details.”).
- Avoid overusing dynamic expressions; keep formatting (bold, italics) minimal for readability.
- Test tone consistency across intents and authors.

## Variables & Entities

### Entity Definition

- Define entities for structured data or business objects (e.g., Certificate, User).
- Entities should have internal names in `lowercase_with_underscores` and display names in Title Case.
- Describe each entity and attribute, including intended use.
- Require only necessary fields to keep conversations flowing.
- Document attribute mappings to Dataverse or external APIs.
- Version conversations and update topics when entity structures change.

### Context Management

- Use **context variables** (session-scoped) to carry information across turns (e.g. current user, record ID, in-progress entity).
- Clear context variables when conversations finish or reset.
- Retrieve fresh source values instead of persisting large objects.
- Use **slot filling** (entity extraction) to capture user-provided values and reduce repetitive questioning.
- Retain only context needed for the next steps.
- Document what context variables exist, their types, and when they are reset or overridden.

## Agent Flows Integration

### Power Automate Actions

- Add agent flows as tools through the “Call an Action” node.
- Link existing flows or create new ones inside Copilot Studio using the integration canvas. See [the flow integration lab](https://microsoft.github.io/TechExcel-Designing-your-own-copilot-using-copilot-studio/docs/Ex03/0303.html).
- Ensure that flow triggers and connectors are properly exposed and authenticated for Copilot to use them. Use [connectors](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-connectors) in Copilot to wrap APIs as tools.
- Rename action nodes for their business purpose (e.g., `CreateCertificateRecord`).

### Data Passing

- Map **topic variables** to flow input parameters; validate types and formats before invoking the agent flow.
- Capture agent flow outputs and map them back into conversation context variables for subsequent prompt decisions.
- Use JSON path syntax (e.g. `outputs('FlowName')?['body']?['propertyName']`) to access deep data inside the flow response.
- Provide default fallback values in your topic logic if some outputs are missing or null.
- Document mapping logic in the topic description, so future makers know which variables are consumed or produced.

## Error Handling & Monitoring

### Fallback Topics

- Include a [system fallback topic](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/fallback-topic) for unrecognized intents.
- Ask users to rephrase or suggest supported questions.
- After a configured number of fallback attempts (typically two), escalate to a human agent or alternate route.
- Store the user’s unrecognized utterance using `UnrecognizedTriggerPhrase` and optionally pass it to a flow for logging or analysis.
- Guard fallback loops with counters or conditions.

### Session Logging

- Enable [**analytics**](https://learn.microsoft.com/en-us/microsoft-copilot-studio/analytics-overview) in Copilot Studio to monitor key metrics like session counts, topic usage, and failure rates.
- [**Log tool and flow**](https://learn.microsoft.com/en-us/microsoft-copilot-studio/flow-manage-monitor) invocation statistics to see which integrations are being used or failing.
- Optionally send custom telemetry to [**Azure Application Insights**](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-bot-framework-composer-capture-telemetry) to capture detailed events and diagnostics.
- Keep conversation transcripts, errors, and context snapshots for review but respect retention limits (e.g. default 30 days).
- Use logs to refine prompts and topic coverage.

### Analytics Review

- Use the **Copilot Analytics dashboard** to assess agent performance, topic drop-off points, and coverage gaps.
- Track session success, fallback frequency, and topic latency.
- Extend analytics using [**custom reports**](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/custom-analytics-strategy) (e.g. via Dataverse or Power BI) for deeper insights beyond built-in metrics.
- Review weekly or monthly; improve conversation design, prompts, and flow reliability.
