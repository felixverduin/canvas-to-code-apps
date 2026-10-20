# Power Automate

## Naming Conventions

### Summary Table of Naming Conventions

| Artifact Type | Convention Pattern | Example(s) |
| --- | --- | --- |
| **Flows** | Solution Abbreviated Name - Table/Entity/Button Name - Purpose | `SolutionName - Module - Update Status` |
| **Triggers** | Original trigger name + specific table and change type | `When a Module is Added, When a Module is Added or Modified`, `Recurrence \| Every 10 Minutes` |
| **Actions** | Keep action name, add context with " \| " separator | `List Rows From Selected Environment \| Ended Open Services`, `Filter array \| Eligible for Autocomplete` |
| **Variables** | Prefix according to type: int (integer), str (string), arr (array) | `varUserId`, `arrFormState`, `intCertificates` |
| **Child Flows** | Solution Name (or Abbrev) - Child Flow - Table Name - Purpose | `SolutionName - Child Flow - Module - Retrieve Recipients`, `SolutionName - Child Flow - Module - Send Notification` |

### Flow Naming

- Pattern: **Solution Abbreviated Name – Table/Entity/Button Name – Purpose**.
    - Example: `SolutionName – Module – Approval`.

- Use the **solution name** first to anchor flows in their project context.
- Always include the **table name** to clarify the data domain.
- Finish with the **purpose** (action being performed).
- Keep names concise, clear, and consistently applied across environments.

### Trigger Naming

- For **Dataverse triggers**:
    - Replace generic “record” with the actual **table/entity name**.

    - Include the **Change Type** in the name.

    - Examples:
        - `When a Module is Added`

        - `When a Module is Modified`

        - `When a Module is Added or Modified or Deleted`

- For **Recurrence triggers**:
    - Use format: `Recurrence | Every X minutes/hours`.

    - Example: `Recurrence | Every 10 minutes`.

### Child Flows

- Name child flows `Solution Name (or Abbreviation) - Child Flow - Table Name - Purpose`; use recognizable abbreviations and plain-language purposes.
- Example: `SolutionName - Child Flow - Module - Retrieve Recipients`.
- Use [child flows](https://learn.microsoft.com/en-us/power-automate/child-flows) to centralize reusable logic and keep parent flows short.
- Describe purpose and expected use cases in the details page.

### Action Naming

> Existing conflict: the summary uses ` | ` as the action separator; this section uses ` – `.

- **Keep the original action name** (from the connector).
- Append a descriptive suffix with `–` (space-dash-space) to explain purpose, table, or filter.
- Examples:
    - `List Rows From Selected Environment – Ended Open Services`

    - `Filter array – Eligible for Autocomplete`

    - `Get A row by ID from Selected Environment – Service`

### Variable Naming

> Existing conflict: the summary specifies `int`/`str`/`arr`; this section specifies `var`/`arr`/`obj`/`dt`, with different casing guidance.

- Prefix by type for readability:
    - `var` for variables → `varTotalAmount`

    - `arr` for arrays → `arrEmails`

    - `obj` for objects → `objResponse`

    - `dt` for dates → `dtSubmittedOn`

- Use consistent camel casing (camelCase).
- Initialize close to first use; avoid reusing variables for multiple purposes.

## Variables & Expressions

### Initialize vs Compose

- Use [Initialize Variable](https://learn.microsoft.com/en-us/power-automate/variables) for values that persist across steps or branches: counters, flags, accumulators.
- Use [Compose](https://learn.microsoft.com/en-us/power-automate/data-operations#compose) for one-off transformations or long expressions.

### Complex Expressions

- Use the [expression editor](https://learn.microsoft.com/en-us/power-automate/use-expressions-in-conditions); split long formulas into Compose actions.
- Reuse [previous outputs](https://learn.microsoft.com/en-us/azure/logic-apps/expression-functions-reference#outputs) instead of extra API calls: `outputs('ListRows')?['body']?['value']?[0]?['name']`.
- Use [Parse JSON](https://learn.microsoft.com/en-us/power-automate/data-operations#parse-json) when strongly typed dynamic content is needed across many steps; otherwise use direct output navigation.

### Environment Variables

- Use **Environment Variables** instead of hard-coding config (URLs, keys, addresses). [Use environment variables in Power Automate cloud flows](https://learn.microsoft.com/en-us/power-automate/guidance/coding-guidelines/use-environment-variables).
- **Naming**: include the **SolutionName** and a clear purpose, e.g., `SolutionName – API Base URL`, `SolutionName – Email Sender Address`. Provide a **Description** explaining usage and environment differences.
- Pair environment variables with **connection references** for ALM portability. See [Create connection references](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-connection-reference).

## Workflow Design Patterns

### Scopes and Grouping

- Use [Scopes](https://learn.microsoft.com/en-us/power-automate/scopes) to logically group related actions.

- Common usage:
    - Grouping related tasks (e.g.,).

    - Separating stages like _Validation_, _Processing_, _Notifications_.

- They are especially useful in **error handling** when combined with `Configure Run After`.

### State Machine Patterns

- Represent workflow stages with a status variable, Switch actions, and Scopes; update status on each transition.
- Use for branching, multi-step processes such as Pending → Approved → Completed. This reduces repeated conditions and simplifies debugging.
- Power Automate has no built-in state machine; see [conditions and switches](https://learn.microsoft.com/en-us/power-automate/add-condition).

## Error Handling

### Try–Catch–Finally with Scopes

- Use [Scopes](https://learn.microsoft.com/en-us/power-automate/scopes) to implement **[structured error handling](https://youtube.com/watch?v=qLADf8ne5qQ)**.
- Design three scopes:
    - **Try** → main business logic.

    - **Catch** → handles exceptions, logs details, sends notifications.

    - **Finally** → performs cleanup (reset variables, close sessions, archive).

### Configure Run After

- Use [Configure Run After](https://learn.microsoft.com/en-us/power-automate/run-after-configuration) on actions to control execution when a previous action **fails, times out, is skipped, or succeeds**.
- Examples:
    - Run a “Send Failure Notification” email **only if** “Update Dataverse Row” fails.

    - Run a retry scope if the initial API call times out.

- Avoid excessive “parallel run after” conditions; keep logic **clear and purposeful**.

### Notifications and Logging

- **Notifications**:
    - Send alerts via Outlook or Teams when errors occur.

    - Include key context (Flow name, Environment, Record ID, Error Message).

- **Logging**:
    - Log errors in a dedicated **Dataverse table** or [Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).

    - Capture user, timestamp, trigger data, and error details.

    - Use a reusable “Error Logger” child flow for consistency.

- Always provide **friendly error messages** to users, and technical details to admins only.

## Performance & Concurrency

### Parallel Branching

- Run independent work in **[parallel branches](https://learn.microsoft.com/en-us/power-automate/concepts-parallel)** to reduce total runtime.
- Keep branches **side-effect free**, and **join** later steps only when all required branches complete.

### Apply to Each Concurrency

- Enable **[concurrency control](https://learn.microsoft.com/en-us/power-automate/triggers-introduction#limit-concurrency)** on **Apply to each** to process items in parallel; tune the degree of parallelism based on connector limits and throttling risk.
- Prefer **batching/aggregation** when supported (e.g., Dataverse or Graph) rather than calling an API once per item; see Dataverse **[Web API query guidance](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/query-data-web-api)**.

### Reducing API Calls (Fetch Less, Fetch Smarter)

- **Filter at the source** with OData (`$filter`, `$select`, `$top`, paging) instead of retrieving everything and filtering in-flow; see Dataverse **[query examples](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/query-data-web-api)**.
- **Project only needed columns** using `$select` to shrink payloads and speed up downstream actions.
- Reuse previous outputs as described under Complex Expressions; use [data operations](https://learn.microsoft.com/en-us/power-automate/data-operations) for local shaping.

### Return full metadata functionality

- Use the option **[return full metadata](https://learn.microsoft.com/en-us/power-automate/dataverse/list-rows?tabs=new-designer#return-full-metadata)** and set this as default to **No** to limit the amount of data returned. 

### Concurrency on Triggers

- Where supported, set **trigger concurrency** to process events sequentially or in parallel; see **[trigger settings & conditions](https://learn.microsoft.com/en-us/power-automate/triggers-introduction#limit-concurrency)** and ensure downstream actions are idempotent.

### Retry, Timeout & Throttling Awareness

- Configure **retry policies** and **timeouts** on actions that call external services and combine with **Run after** paths for graceful recovery; review **[API request limits & allocations](https://learn.microsoft.com/en-us/power-platform/admin/api-request-limits-allocations)**.
- Monitor connector-specific limits and dial back parallelism when you observe **429 throttling**.

### Practical Patterns

- **Parallel fan-out + join** to fetch multiple datasets simultaneously, then continue when all complete (a common **[parallel pattern](https://learn.microsoft.com/en-us/power-automate/concepts-parallel)**).
- **Paged retrieval** with server-side paging in Dataverse/Web API for large datasets (see **[query paging](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/query-data-web-api)**).
- **Server-side filters first**, **client shaping second** (use **[data operations](https://learn.microsoft.com/en-us/power-automate/data-operations)** like Compose/Filter array only when necessary).

## Connectors & Integration

### Standard Connectors

- Prefer **[standard connectors](https://learn.microsoft.com/en-us/connectors/connector-reference/)** over custom ones for stability and long-term support.
- Always review the **licensing implications** before using premium connectors.
- Verify throttling and API limits for frequently used connectors to avoid slowdowns.
- Use **service accounts** instead of personal accounts when creating connections to ensure continuity and governance.

### Custom Connectors

- Build **[custom connectors](https://learn.microsoft.com/en-us/connectors/custom-connectors/)** only when a standard connector does not exist or lacks required functionality.
- Provide clear names and descriptions that reflect the external system or API.
- Document the required authentication scheme (OAuth2, API key, etc.) and validate that it aligns with organizational security requirements.
- Maintain versioning and update processes, ensuring backward compatibility where possible.
- Publish custom connectors through **solutions** to enable ALM practices.

### Secure Connections

- Use **[Azure AD authentication](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis)** whenever available to avoid hard-coded secrets or API keys.
- Store sensitive values such as client IDs or secrets in **[environment variables](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables)** instead of embedding them in flows.
- Restrict connection ownership to administrators or service accounts; avoid shared personal credentials.
- Regularly audit connections and update credentials before expiration.

### HTTP Trigger URLs and Environment Variables

- When triggering a Power Automate flow using an **HTTP POST request**, always store the **HTTP trigger URL** in an **[Environment Variable](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables)** rather than hardcoding it.
- Update the variable when endpoints change during deployment or migration.
- If flows are invoked from **buttons, ribbon commands, or model-driven forms**, using environment variables prevents the need to manually edit URLs in multiple places when endpoints change.

## Reusable Child Flows

### Parameter Passing

- Use child flows for reusable logic as described under Child Flows.
- Pass parameters explicitly via input/output properties to make dependencies clear.
- Use strongly typed data structures (objects, arrays) instead of multiple scalar parameters where possible.
- Validate inputs early in the child flow to prevent downstream errors.
- Document what each parameter means and its expected format.

### Common Utility Flows

- Create **utility flows** for recurring needs such as:
    - Sending templated notifications (Teams, Outlook).

    - Standardized logging or telemetry pushes.

    - Reusable record creation or updates in Dataverse.

- Store them in a **dedicated utility solution** for shared usage across projects.
- Maintain clear versioning and update notes to avoid breaking dependent flows.
- Reference utility flows consistently using their **solution-published names**.

## Maintainability & ALM

### Solutions Structure

- Always build flows inside **[Dataverse solutions](https://learn.microsoft.com/en-us/power-automate/overview-solution-flows)** for portability, versioning, and ALM.
- Avoid unmanaged flows in production; always deploy managed solutions.
- Document solution purpose in the solution description field.

### Connection References

- Create **[connection references](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/create-connection-reference)** manually inside solutions to avoid unreadable auto-generated names.
- Use service accounts, not personal credentials for production connections.
- Reuse references across flows in the same solution instead of creating duplicates.

### Documentation in Flows

- Add a meaningful flow description explaining purpose, trigger, main actions; use the **Details page** in the flow’s _Description_ section to reference this.
- Use inline comments and Notes for actions when expressions or logic are complex; explain both _why_ and _what_ the action does in the note.
- Always refer to Microsoft’s guidance on [**Application lifecycle management (ALM) with Power Platform for best practices**](https://learn.microsoft.com/en-us/power-platform/alm/overview-alm).
