# Dataverse

## Naming Conventions

Describe every component’s purpose and business meaning; include dependencies, ownership, and operating instructions where relevant.

### Naming summary

| Artifact Type | Convention Pattern | Example(s) |
| --- | --- | --- |
| **Tables (Entities)** | Business-Friendly Singular/Plural Name | Certificate / Certificates |
| **Table Icons** | SVG web resource using Solution Name - Table Icon display name | SolutionName - Certificate Table Icon |
| **Columns (Fields)** | Title Case with spaces; IDs end with “Id” | Certificate Id, Expiration Reminder Date |
| **Choices / Option Sets** | Logical, simple values; sequences must be clear | One, Two, Three |
| **Relationships (Lookups)** | Table Name - Related Table (Schema ends with Id) | Certificate - Account (schema: personId, display: Person) |
| **Web Resources** | Solution Name - Description | SolutionName - Rich Text Editor Config |
| **Ultimate/Alternate Keys** | Solution Name - Related Table/Column | SolutionName - Module |
| **Business Rules** | Table Name - Purpose - Target Column(s) | Certificate - Visibility - Expiration Reminder Date |
| **Security Roles** | Solution Name - Role Name | SolutionName - Approver |
| **Field Security Profiles** | Solution Name - Role Name | SolutionName - Confidential Data |
| **Teams** | Solution Name - Team Purpose | SolutionName - Approvers Team |
| **Plugins** | Solution Name - Plugin Purpose | SolutionName - Sync Module Data |
| **Custom APIs** | Solution Name - API - Purpose | SolutionName - API - Validate Document |
| **Environment Variables** | Solution Name - Variable Purpose | SolutionName - API Base URL |
| **Connection References** | Solution Name - Connector Purpose | SolutionName - SharePoint Connection |
| **Dataflows** | Solution Name - Source System - Purpose | SolutionName - SharePoint - Import Documents |
| **App Registrations** | Solution Name - API Purpose | SolutionName - Graph API Access |
| **Azure Integrations** | Solution Name - Azure Service Purpose | SolutionName - Service Bus Listener |
| **Client-Side JS Scripts** | Solution Name - Purpose - Context | SolutionName - Form Validation - On Load |

### Tables (Entities)

- **Display Names** must be business-friendly and descriptive.
- **Plural Names** must align logically with the Display Name.
  - Example: *Certificate* → *Certificates*.
- Always provide a **Description** for each table explaining its business purpose.
- Every custom table must have a fitting table icon before it is considered complete.
  - Use a **regular Fluent UI SVG icon** from the Microsoft Fluent UI system icons set.
  - Store the SVG as a Dataverse **web resource** in the solution.
  - Set the table's vector icon metadata to the SVG web resource.
  - Choose an icon that reflects the table's business purpose rather than a generic database or list symbol.
  - Follow the web resource naming convention and use the display name pattern **Solution Name - Table Name Table Icon**.

### Columns (Fields)

- Use **Title Case with spaces** between words.
  - Example: *Expiration Reminder Date*.
- Unique identifiers always end with **Id**.
  - Example: *Certificate Id*.
  - Dataverse generates the **Primary Id** column.
    - Its display name defaults to the singular table name.
    - Update this display name immediately to identify it clearly.
- Primary Name column remains *Name* unless justified.
- Use the out-of-the-box **Status** and **Status Reason** columns for lifecycle state wherever possible.
  - Do not create custom status/state columns unless the standard Dataverse columns cannot represent the business requirement.
  - If a custom status/state column is required, document why the out-of-the-box columns were not sufficient.

### Choices (Option Sets)

- Use short, logical, and easy-to-read values.
  - Example: *One*, *Two*, *Three*.
- Replace long numeric codes with simpler equivalents.
- Always provide a **Description** for the purpose of each choice set.
- Always assign **pastel colors** to choice values when the platform supports option colors.
  - Use colors that provide clear contrast with **black text**, since this is the default in model-driven apps.
  - Keep option colors visually distinct from each other while staying within a pastel palette.

### Global Option Sets

- Prefer global option sets for business-domain choices reusable across tables or views. Keep labels and maintenance consistent across tables and solutions.
- When to use global option sets: classification values (e.g., Event Format), status-like enums used across tables, or any choice that may appear on more than one table or in shared views.
- Use local choices only for UI-only or one-off values where reuse is impossible.
- Implementation notes:
  - Create global option sets inside the project's designated solution when possible, or in a shared reference solution if multiple solutions need the same set.
  - Use descriptive naming: `<PublisherPrefix>_<Purpose>_Options` (e.g., `contoso_EventFormat_Options`).
  - Provide a clear **Description** explaining the purpose and intended reuse sites for the option set.
  - When adding new values, update the option set once rather than changing local copies.

### Relationships and Lookups

- **Always create a relationship explicitly** rather than just adding a lookup column.
  - If you create a lookup column directly, Dataverse will auto-generate the relationship and you lose control over its naming.
- **Relationship display name:** use **Table Name – Related Table** in singular form.
  - Example: `Certificate – Account`.
- **Relationship SchemaName (logical name):** always include your **publisher prefix** and follow a clear **directional pattern**:
  - N:1 (many-to-one): `prefix_<from>_N1_<to>`
    - Example: `abc_booking_N1_location`
  - 1:N (one-to-many): `prefix_<from>_1N_<to>`
    - Example: `abc_location_1N_booking`
  - N:N (many-to-many): `prefix_<a>_NN_<b>` (or alphabetically `prefix_<a>_<b>`, but pick one style and stick to it)
    - Example: `abc_employee_NN_project`
- **Lookup column naming (on the “many” side):**
  - Schema (logical) names always end with **Id**.
    - Example: `abc_locationid`.
  - Display names exclude **Id**.
    - Example: *Location*.
- **Consistency & hygiene:**
  - Create and name relationships **within your Solution** so the correct prefix is applied.
  - Use **Title Case with spaces** between words for name parts and **underscores** instead of spaces in logical names only.
- Always provide a **Description** for each relationship.

### Web Resources

- Store table icons as regular Fluent UI SVG web resources; use `Solution Name - Table Name Table Icon`.

### Alternate Keys

- Enforce uniqueness and describe the uniqueness logic; see Keys & Identifiers below.

### Business Rules

- Describe each rule’s purpose and target columns.

### Security Roles

- Describe privileges and follow [role-based security](https://learn.microsoft.com/en-us/power-platform/admin/database-security).

### Column-Level Security Profiles

- Describe protected data and follow [field-level security](https://learn.microsoft.com/en-us/power-platform/admin/field-level-security).

### Teams

- Describe each team’s role.

### Plugins

- Describe plugin purpose; follow [registration](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/tutorial-write-plug-in) and [exception handling](https://learn.microsoft.com/en-us/power-apps/developer/data-platform/handle-exceptions) guidance.

### Connection References

- Create connection references manually inside solutions to avoid unreadable generated names. Detailed naming: `Solution Name - Connector Name`.

## Data Modeling

### Normalization vs. Denormalization

- Normalize data models to avoid duplication and maintain integrity.
- Use separate tables for distinct entities (e.g., *Certificate*, *Headmaster*).
- Denormalize only when it reduces complexity or significantly improves performance (e.g., reporting tables).
- Always document and provide a **Description** where denormalization is applied and why.

### Keys & Identifiers

#### Primary Key (Row ID)

- Always use Dataverse’s system-generated **GUID** as the primary key (`<logicalname>id`).
- Don’t create a custom primary key; the GUID is immutable and optimized for relationships.
- Don’t expose the GUID to end users (use it only for lookups, relationships, and APIs).

#### Alternate Keys (for integration & uniqueness)

- Use **Alternate Keys** for external integrations (e.g., external IDs), **upsert** support, and to **enforce uniqueness**.
- Choose columns that are **stable and not user-editable** (e.g., External System ID, Code); **avoid frequently updated columns**.
- Prefer a **single-column** key; keep **composite** keys rare and well documented.
- Minimize alternate keys; each adds an index and write overhead.
- If values must never change, **enforce immutability** via validation (business rule/flow/plugin).
- **Document** the purpose and usage of each alternate key and add a clear **Description**.

#### Human-Readable Identifiers

- If users need a readable number, add an **Autonumber** column (e.g., `TKT-000123`).
- Only make an autonumber an **Alternate Key** if it is guaranteed **immutable** and its **format/length** will remain stable.

#### Anti-patterns

- Don’t use names, statuses, owners, or other **mutable** fields as keys.
- Don’t duplicate natural keys from related tables for joins, use **lookups** (GUIDs) instead.

### Relationship Types

- **1:N (One-to-Many):** Parent table holds unique records, child table references parent (e.g., *Certificate → Owner*).
- **N:N (Many-to-Many / End-to-End):** Use for equal relationships where records can be linked both ways (e.g., *Teachers ↔ Courses*).
- Always evaluate whether an intermediate linking table (with additional attributes) would provide more flexibility than a pure end-to-end relationship.
- Always provide a **Description** for relationships explaining their business meaning.

## Security & Access

### Security Roles

- Always follow the **principle of least privilege** — grant only the access required for the role.
- Use out-of-the-box roles as a starting point and extend when necessary.
- Create solution-specific roles with meaningful names (e.g., `SolutionName - Approver`).
- Avoid overuse of the **System Administrator** role — reserve it strictly for platform admins.

### Field-Level Security

- Apply field-level security for sensitive or confidential data (e.g., _Salary_, _Personal ID_).
- Use descriptive security profile names that match the business context (e.g., `SolutionName - Sensitive Fields`).
- Clearly document which fields are restricted so developers and testers know how to handle them.
- Regularly review and audit security profiles to ensure they remain aligned with business needs.

### Teams vs. Business Units

- Prefer **teams** for granting access to shared records instead of creating unnecessary business units.
- Keep the **business unit hierarchy** simple — avoid deep nesting to reduce complexity.
- Use **owner teams** when records must be shared across departments.
- Use **access teams** for ad-hoc sharing without affecting ownership.

### Record Ownership Strategy

- Define ownership carefully:
    - **User-owned tables** for collaborative and transactional data (e.g., cases, opportunities).

    - **Organization-owned tables** for static or reference data (e.g., product catalogs).

- Minimize ownership transfers between users or teams to reduce performance overhead and audit noise.

## Business Logic Implementation

### Business Rules

- Use **business rules** for simple validations, field updates, and visibility toggles.
- Best suited for logic that must run consistently across forms and views without custom code.
- Keep rules short and focused on a single purpose for maintainability.
- Avoid complex, multi-branch rules — consider Power Automate or plugins instead.

### Workflows vs. Power Automate

> Existing cross-chapter conflict: this section calls classic workflows deprecated; the Model-Driven Apps chapter calls them supported legacy functionality.

- **Classic Workflows** are deprecated but can still be used when **synchronous server-side changes** are required, because Power Automate flows cannot run synchronously.
- Prefer **Power Automate flows** for most automation needs, particularly when async execution is acceptable or when integrating across multiple services.
- Evaluate carefully whether a requirement truly demands synchronous execution before choosing Classic Workflows.

### Plugins

- Use plugins for complex business logic not possible with business rules or flows.
- Register plugins at the minimal required pipeline stage to reduce execution time.
- Use filtering attributes to prevent unnecessary triggers.
- Always provide meaningful error messages or logging.
- Always prefer lightweight low-code plugins instead of heavier pro-code ones.

### Calculated, Rollup & Power Fx Columns

- Use **calculated columns** for lightweight field-level computations that depend on other fields within the same or related tables.
    - Example: _Total Price = Quantity × Unit Price_.

- Use **rollup columns** to aggregate data across related records (e.g., _sum of all child activities_).
    - Rollups refresh asynchronously and are best suited for summary or reporting fields.

- Use **Power Fx columns** when you need richer formulas with Power Fx syntax or reusable logic that supports instant evaluation.
- Avoid over-nesting dependencies — circular references or deeply chained formulas can hurt performance.
- Always **document** each column’s formula and purpose in the description field.
- Apply **field-level security** carefully; rollup and calculated columns execute under system context and may expose restricted data indirectly.
- Validate performance: rollup recalculations can increase system load if used on high-volume tables.

## Solution Management

### Publisher Prefix Standards

- Always create solutions with a **unique publisher prefix** that clearly identifies your organization or department.
- Avoid using the default `new_` prefix in production environments.
- Publisher prefixes should be short but recognizable (e.g., `contoso`).

### Solution Layering

- Use Microsoft Learn’s [Solution Layers and Merge Behavior](https://learn.microsoft.com/en-us/power-platform/alm/solution-layers-alm) to understand how managed and unmanaged solutions stack and how component merge behavior works.
- Maintain separation between managed and unmanaged solutions.
- **Never make unmanaged customizations in downstream environments. Only deploy managed solutions.**
- Test layering in non-prod environments first and use the “Solution Layers” view to verify what customizations are active.

### Environment Variables

- **Default Value:** leave it **empty** unless you explicitly need a **fallback**.
  - Leaving it empty enforces that a **Current Value** must be set in every downstream environment.
- **Current Value:** must be configured per environment after import/deployment (Dev/Test/Prod).
- **Export Value:**
  - By default, this is set to **Yes** when you first create an Environment Variable.
  - Always re-open the variable after creation and switch **Export Value** to **No** in your **unmanaged** solution.
  - This prevents the current Dev value from being exported and imported into downstream environments.
- See Microsoft Learn’s [Environment Variables in Solutions](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables) for guidance.

## Error Handling & Monitoring

### User-Friendly Error Messages

- Provide clear, actionable messages.
- Avoid technical jargon.
- Always provide a **Description** for custom error messages.
- For Canvas apps use [Handling errors in Power Apps](https://learn.microsoft.com/en-us/power-apps/guidance/coding-guidelines/error-handling)

### Plugin Error Logging

- Centralize logging (e.g., Application Insights).
- Log user, time, and context.
- Use error codes internally, user-friendly text externally.
- Always provide a **Description** for logging design.

### Flow/Process Error Monitoring

- Enable failure notifications.
- Use dashboards to monitor flows.
- Implement retries where possible.
- Always provide a **Description** for monitoring setup.

### Telemetry with Application Insights

- Capture response times, errors, usage.
- Use telemetry for proactive optimization.
- Always provide a **Description** for telemetry configurations.

## Documentation & Maintainability

### Field Descriptions

- Always provide **Descriptions** for all fields in Dataverse.
- Descriptions must explain the field’s purpose and business meaning.

### Table Documentation

- Provide a **Description** for every table explaining purpose and relationships.
- Include key fields and usage scenarios.

### Solution Readme Pages

- Add a Readme to each solution describing purpose, dependencies, and usage.
- Keep updated with each version.
- Always provide a **Description** for updates.

### Handover Checklists

- Provide checklists for support/operations.
- Include contacts, limitations, error handling, monitoring setup.
- Ensure checklists are part of ALM.
- Always provide a **Description** for handover materials.
