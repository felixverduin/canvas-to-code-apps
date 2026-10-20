# Model-Driven Apps

## Naming Conventions

### Naming summary

| Artifact Type | Convention Pattern | Example(s) |
| --- | --- | --- |
| **Forms** | Table Name – Purpose | Certificate – Main, Certificate – Quick Create |
| **Views** | Table Name – View Purpose | Certificate – Active |
| **Tabs** | tab_purpose | tab_details, tab_compliance |
| **Sections** | sec_scope | sec_ownership, sec_expiration |
| **Subgrids** | subgrid_tablename | subgrid_bookings, subgrid_modules |
| **Plugins** | Solution Name – Table – Event | SolutionName – Create – Validate Expiry Date |
| **Webhooks** | Solution Name – Webhook – TargetService | SolutionName – Webhook – AzureFunction |
| **Virtual Tables** | Solution Name – ExternalSystem – TableName | SolutionName – SAP – Status |

### Forms (Form Names & Labels)

- **Form Name pattern:** _Table Name – Purpose_ (e.g., `Certificate – Main`, `Certificate – Quick Create`).
- Keep the **Form Display Name** business-friendly; avoid abbreviations.
- Use short, action-oriented Title Case labels and headers.
- Follow Microsoft guidance on **[creating and designing forms](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/create-design-forms)** (Main, Quick Create, Quick View, Card).

### Tabs (Names & Labels)

- **Tab Name pattern (internal):** `tab_purpose` (e.g., `tab_details`, `tab_compliance`).
- **Tab Label (visible):** short Title Case nouns (e.g., _Details_, _Compliance_, _Related_).
- Keep one topic per tab; avoid mixed concerns.
- You can manage tab labels/visibility using the form designer and Client API (`formContext.ui.tabs`).

### Sections (Names & Labels)

- **Section Name pattern (internal):** `sec_scope` (e.g., `sec_ownership`, `sec_expiration`).
- **Section Label (visible):** concise Title Case (e.g., _Ownership_, _Expiration_).
- Group related fields; avoid more than 2–3 columns per section for readability.
- See Microsoft’s guidance on [**adding/configuring sections**](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/add-move-or-delete-sections-on-form) in forms.

## UI Design: Forms, Views and App Layout

### Form Layout

- Keep forms **simple and task-focused**, prioritizing fields that users interact with most frequently.
- Group related information logically — for example, group ownership, dates, and metadata together.
- Keep field order, alignment, and spacing consistent across forms.
- Avoid horizontal scrolling by limiting columns; aim for **one or two columns per section** for readability.
- Use **Quick Create forms** for fast data entry scenarios and **Main forms** for full record context.
- Include form-level **tooltips** and **descriptions** to guide users where needed.
- Apply **business process flows** only when necessary to guide users through complex data entry steps.

### Tabs and Sections

> Existing conflict: internal section names above use `sec_scope`; this section specifies `Sec – Purpose`.

- Use tabs to separate **logical data areas** (e.g., _Details_, _Relationships_, _History_).
- Avoid more than **five tabs** per form; excessive navigation reduces usability.
- Label tabs in **Title Case**, using short, descriptive nouns.
- Within each tab, organize fields in sections for **clarity and readability**.
- Sections should follow consistent naming: `Sec – Purpose` (e.g., `Sec – Status`, `Sec – Audit Info`).
- Avoid hiding sections dynamically unless required by logic; use **business rules** to control visibility when applicable.

### View Configuration

> Existing conflict: the guidance below both limits personal views and encourages users to create them.

- Keep [**views**](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/create-edit-views) focused on key data for the user’s task (e.g., _Active Certificates_, _Pending Approvals_).
- Include only relevant columns (5–10 max) to maintain performance and readability.
- Sort by business-relevant fields (e.g., _Modified On_, _Status_).
- Always use **filters** to limit unnecessary record retrieval and improve loading times.
- Name views clearly following the pattern: _Table Name – View Purpose_ (e.g., `Certificate – Active`, `Module – Pending Approval`).
- Provide **personal views** for individuals only when necessary — encourage shared system views for consistency. Encourage users to create personal views. Assume they know their own work process best. After working with the app for a while, they’ll be perfectly capable of creating and sharing their own views.

### Command Bar

- Use the **[Ribbon Workbench (XrmToolBox)](https://www.youtube.com/watch?v=5_gnIQGLL0M)** or the **Modern Command Bar editor** to customize the command bar and hide unnecessary buttons or options that are not relevant to the current user role.
- Prefer the **Modern Command Bar editor** for quick UI-level changes — it supports most standard commands.
- Use the **Ribbon Workbench** when deeper customization is required (e.g., hiding system buttons, adding enable/disable rules, or controlling visibility by security role).
- Clearly name your custom commands using the pattern:
    - `cmd_[table]_[purpose]` — for example: `cmd_certificate_validate` or `cmd_module_approve`.

- Regularly review command bar configurations to ensure relevance and usability after each release.
- Keep the command bar clean — every visible button should serve a direct business purpose.
- Prevent confusion by hiding functionality that is not relevant to the user. Ensure a clear and structured app layout by maintaining an organized command bar. Not all buttons can be hidden through the Modern Command Bar editor — for those, use the Ribbon Workbench instead.

### Sitemap (Areas → Groups → Subareas)

- Define **one area per persona** (e.g., _Sales_, _Service_, _Admin_). Avoid “mega” areas that mix roles or functions.
- **Groups** represent _tasks_, not _data structures_ (e.g., “My Work”, “Planning”, “Reports”).
- **Subareas** should list only the elements that the persona needs daily — hide configuration or administrative items from end users.
- Use **singular nouns** for records (“Account”, “Case”) and **verbs** for actions (“Import Data”, “Create Report”).
- Apply **conditional visibility** based on security roles, not client-side scripts, to improve maintainability and performance.
- Review sitemap structure with users periodically to ensure it aligns with their workflow.
- Hide irrelevant functionality; use Ribbon Workbench for adjustments unavailable in the modern editor.

### Custom Pages

Choose a custom page for:
- A **task-centric workspace** — for example, a multi-section dashboard, command center, or role-specific home page.
- A **process or wizard-style experience** with step-by-step logic and dynamic branching.
- To display **multi-source data** on a single canvas (e.g., Dataverse, SharePoint, or APIs) using connectors.
- **Rapid iteration** with makers using Power Fx and low-code principles.
- A simpler alternative to a PCF component — embedding a Canvas app inside a model-driven app is often less complex and provides similar functionality for many use cases.
- **PCFs remain valuable** when you need tight form integration — for example, embedding a single interactive control (like a button) that directly interacts with model-driven form data.

## Business Logic Implementation

### Business Rules

- Use **Business Rules** to enforce simple logic directly in the Dataverse layer without code.
- Prefer them for declarative logic such as field visibility, field requirements, or default values.
- Name business rules according to the pattern: `Table Name – Purpose – Target Column(s)` (e.g., `Certificate – Visibility – Expiration Date`).
- Keep each rule focused on a single responsibility; avoid large rules with many branches.
- Enable “Client + Server” scope only when necessary to reduce performance overhead.
- Document each rule’s intent in its description field for debugging and reviews.

### Power Automate Integration

- Integrate **Power Automate flows** for asynchronous or cross-table automation.
- Use Dataverse triggers like _When a row is added, modified, or deleted_ and filters to narrow execution scope.
- Avoid triggering flows for every record update; use [**Trigger conditions**](https://alrafayglobal.com/power-automate-trigger-conditions/) to minimize unnecessary runs.
- When calling flows via ribbon buttons or form commands, store the HTTP trigger URL in an **Environment Variable** to simplify updates.
- Ensure flows provide meaningful error responses when returning data to the model-driven app.
- Log flow execution details (record ID, timestamp, status) when automation outcomes impact data quality.

### Plugins

- Implement **[Plugins](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/write-plug-in)** for synchronous, transactional logic that must run immediately on record changes.
- Use them for business-critical validations, custom calculations, or enforcing non-declarative rules.
- Keep plugin classes lightweight, with one responsibility each.
- Register plugins at minimal required stages (Pre-Validation, Pre-Operation, Post-Operation) and use **filtering attributes** to reduce unnecessary triggers.
- Include proper exception handling with user-friendly error messages.
- Always document plugin purpose and registration details (table, event, message) in the solution documentation.

### Classic Workflows

- Microsoft recommends **using Power Automate (cloud flows)** for new automation and reviewing or migrating background **classic workflows** where possible.
- Classic workflows are **still supported**, but they are considered legacy and receive minimal investment from Microsoft.
- These workflows can still be valuable in specific cases where **real-time, in-transaction validation or updates** are required — for example, when you need a **synchronous process** that can block a record save or display a message to the user.
- Classic workflows can also execute actions **before record deletion**, making them useful when related records must be handled prior to the delete operation.
- Although Microsoft is moving toward low-code plug-ins and real-time flows, Power Automate will not completely replace all functionality offered by classic workflows in the short term.

## Client-Side Scripting (JavaScript)

### Event Binding

- Always register JavaScript functions through the **form properties** interface in the model-driven app form designer.
- Bind events explicitly to supported triggers: `OnLoad`, `OnSave`, and `OnChange`.
- Avoid hardcoding function calls directly in field event handlers—reference functions from registered libraries instead.
- When binding functions, specify the execution context parameter (`executionContext`) for full control over runtime context.
- Ensure all event registrations are **documented** in the web resource description, listing the form, event, and handler function name.

### Script Structure

- Each form should load only **one main script library** containing all related functions.
- Organize code into logical namespaces (e.g., `app.CertificateForm = {}`) to avoid name conflicts.
- Use the **formContext** object instead of deprecated `Xrm.Page`.
- Keep scripts modular and reusable across forms and tables.
- Follow naming conventions: `SolutionName – Purpose – Context` (e.g., `Certificate – Validation – OnChange`).
- Store scripts as **web resources** with meaningful descriptions, including version and owner.

### Performance Considerations

- Minimize DOM operations and API calls inside client scripts; prefer server-side automation when possible.
- Use **[asynchronous operations](https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/clientapi/reference/xrm-webapi/online)** for data retrieval through the Web API (`Xrm.WebApi.retrieveRecord`) to avoid blocking UI threads.
- Avoid multiple simultaneous data requests; batch operations where possible.
- Cache lookups or constants locally using variables when data doesn’t change often.
- Regularly review console logs and use browser developer tools to profile JavaScript performance.
- Test on multiple browsers to ensure cross-compatibility and accessibility remain intact.

## Code Components (PCF Controls)

### When to Use PCFs

- Use **[Power Apps Component Framework (PCF) controls](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/overview)** when standard or modern controls can’t deliver the required functionality or design.
- PCFs are ideal for complex UI behavior, custom data visualizations, or integrations with external systems.
- Compare PCF development and maintenance cost with native alternatives.
- Prefer reusability — design PCFs as **generic controls** that can be applied across multiple tables and apps.
- Avoid PCFs for basic validation or display logic already supported by native controls.

### Deployment and Updates

- Package PCFs inside **[managed solutions](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/import-custom-controls)** to ensure clean deployment across environments.
- Maintain **semantic versioning** for PCF updates (`Major.Minor.Patch`).
- Always test new PCF versions in a sandbox or test environment before promoting to production.
- Use descriptive control names that reflect purpose (e.g., `Certificate – Expiry Gauge`, `Module – Progress Bar`).
- Document each PCF’s inputs, outputs, dependencies, and styling.
- Keep JavaScript or TypeScript dependencies minimal for performance and maintainability.
- Reference static assets through **web resources**, and ensure they follow the organization’s naming conventions.
- Rebuild external PCF components before use to reduce the risk of malicious code.

## Plugins & Custom Processes

### Plugin Registration

- Always register plugins through the **[Plug-in Registration Tool](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/register-plug-in)** or the Power Platform CLI for consistent version management.
- Keep plugin assemblies within managed solutions; avoid unmanaged deployments in production.
- Use meaningful, consistent names for each registration — `SolutionName – Table – Event` (e.g., `Certificate – Create – Validate Expiry Date`).
- Specify only required **pipeline stages** (`Pre-Validation`, `Pre-Operation`, `Post-Operation`) and minimize the number of registered steps to reduce performance overhead.
- Use **Filtering Attributes** to limit execution to relevant field changes.
- Include all plugin dependencies in the solution to ensure portability.
- Document plugin details in the solution (table, event, and message) and store a reference to any linked custom APIs or child flows.
- Prefer [low-code plugins](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/low-code-plug-ins?tabs=instant) when generally available.

### Error Handling in Plugins

- Wrap business logic in **try/catch blocks** to prevent unhandled exceptions from halting operations.
- When throwing errors, use the **InvalidPluginExecutionException** class with clear, user-friendly messages (e.g., “The Expiration Date must be in the future.”).
- Log technical details (stack trace, record ID, user ID, timestamp) to a centralized location such as **Application Insights** or a dedicated Dataverse logging table.
- Avoid exposing sensitive system information in user-facing messages.
- Consider adding a **retry mechanism** for recoverable exceptions (e.g., transient connectivity failures).
- Keep exception messages concise and actionable.
- Review logs regularly to identify recurring issues or performance bottlenecks.

## Integration & External Data

### Virtual Tables

- Use **Virtual Tables** to surface external data in Dataverse without physically storing it.
- Ideal for **read-only scenarios** or when data resides in external systems that must remain the single source of truth.
- Secure external connections using **service principals** or **managed identities** instead of personal accounts.
- Avoid using virtual tables for **high-frequency transactional data**, as they rely on real-time queries that can impact performance.
- Use **custom data providers** only when standard connectors (e.g., SQL, SharePoint) are not sufficient.
- Document the data source type, authentication method, and refresh or latency expectations in your solution documentation.
- Follow a clear **naming pattern** for external sources:
    - `SolutionName – ExternalSystem – TableName` (e.g., `SolutionName – SAP – Status`).

- Be aware that **virtual tables do not provide the same functionality** as standard Dataverse tables — for example, they do not support **field-level security**, **row-level ownership**, or inclusion in **Dataverse Search**.
- Consider standard tables populated through Dataflows and Power Automate instead.
- See Microsoft’s documentation for a list of [limitations of virtual tables](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/virtual-entities/get-started-ve).

### Webhooks

- Use **[Webhooks](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/use-webhooks)** for lightweight, event-driven integrations that need to trigger external services on Dataverse changes.
- Prefer webhooks over plugins when the integration target is outside the Power Platform or when decoupling is beneficial.
- Always register webhooks as part of a managed solution for traceability and version control.
- Configure retries and error handling on the receiving system to ensure message delivery reliability.
- Secure endpoints with authentication (OAuth2 or API key) and enforce HTTPS to protect transmitted data.
- Provide descriptive names following the convention: `SolutionName – Webhook – TargetService` (e.g., `Certificate – Webhook – AzureFunction`).
- Log webhook execution results (success/failure, timestamp, target) to a Dataverse monitoring table or Application Insights.

## Performance & Optimization

### Indexing Strategies

- Use **[Dataverse indexing](https://learn.microsoft.com/en-us/power-platform/admin/configure-relevance-search-organization?tabs=new)** to optimize queries on frequently filtered or sorted columns.
- Index columns used in **views, lookups, and filter conditions** to improve load and query performance.
- Avoid indexing columns that are updated frequently (e.g., status or modified dates) to prevent unnecessary rebuilds.
- Review index utilization periodically using Dataverse analytics or SQL trace logs.
- Coordinate index changes with the Power Platform admin team to prevent duplication or conflicts across solutions.
- Document custom index rationale in solution notes.

### Reducing Form Load Times

- Minimize the number of **controls and subgrids** on forms to improve load performance.
- Load related data conditionally using **form events and visibility rules** only when necessary.
- Limit the number of **business rules** and **scripts** running on form load; defer non-essential logic to `OnChange` or asynchronous triggers.
- Remove hidden or unused fields from forms to reduce data payloads.
- Consolidate multiple tabs into fewer, purpose-driven layouts where possible.
- Evaluate form load times regularly using the **[Form Performance Analyzer](https://learn.microsoft.com/en-us/power-apps/maker/model-driven-apps/optimize-form-performance)** tool.
- Ensure PCF components and subgrids do not make redundant data calls.

## Error Handling & Data Validation

### User-Friendly Error Messages

- Always return **clear and actionable error messages** to the user; avoid exposing technical details or stack traces.
- Use [**business rules**](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/data-platform-create-business-rule) or [**plugins**](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/write-plug-in) to enforce validation and display messages aligned with business terms.
- Keep error text **short and contextual**, for example: _“Expiration Date must be in the future.”_
- Ensure validation messages are **consistent** across forms, plugins, and flows to avoid confusion.
- Capture **internal error details** (record ID, user ID, timestamp) in a secure log for debugging, not in user-facing messages.
- Use **Application Insights** or a dedicated **Dataverse “Error Log” table** for centralized tracking of validation failures and system errors.
- You can also use **web resources (JavaScript)** with _OnChange_ or _OnSave_ triggers to show **clear, immediate validation messages** directly within the user interface.

### Data Integrity Rules

- Define and enforce **column-level validation rules** in Dataverse to ensure data completeness and accuracy.
- Apply **required fields** and **business-required rules** only where they add clear business value.
- Validate related record existence before performing updates or deletes to maintain referential integrity.
- Use **real-time workflows or plugins** for transactional integrity checks that must occur before save.
- Implement **business process flows** only for guided scenarios where user input order matters.
- Review views and constraints periodically for redundant validation.
- Document validation logic for each key table in solution documentation.
