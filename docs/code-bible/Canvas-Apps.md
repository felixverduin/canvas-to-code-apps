# Canvas Apps

## Naming Conventions

### Naming summary

| Category | Artifact / Control | Prefix | Example |
| --- | --- | --- | --- |
| **Variables** | Global Variables | gbl | gblCurrentUser |
|  | Context Variables | ctx | ctxFormMode |
|  | With Variables | var | varAppName |
|  | Collections | col | colEmployees |
|  | Named Formulas | nf | nfVATPercentage |
| **Screens & Components** | Screens | scr | Home Screen |
|  | Canvas Components | cmp | cmpHeader |
|  | Component Library Elements | cmp | cmpSearchBar |
| **Standard Controls** | Text Input | txt | txtFirstName |
|  | Button | btn | btnSubmit |
|  | Label | lbl | lblErrorMessage |
|  | Gallery | gal | galEmployeeList |
|  | Form | frm | frmEmployeeDetails |
|  | Dropdown | drp | drpDepartment |
|  | Combo Box | cmb | cmbCountrySelector |
|  | Radio Button | rad | radGender |
|  | Toggle | tgl | tglIsActive |
|  | Date Picker | dtp | dtpStartDate |
|  | Slider | sli | sliVolume |
| **Complex / Visual Controls** | Container | con | conHeader |
|  | Tab Control | tab | tabSettings |
|  | Timer | tmr | tmrCountdown |
|  | Image | img | imgLogo |
|  | Icon | icn | icnSearch |
|  | HTML Text Control | htm | htmDisclaimer |
|  | Shape - Rectangle | rec | recBackground |
|  | Shape - Circle | cir | cirStatusIndicator |
|  | Camera | cam | camCapture |
|  | Barcode Reader | bar | barTicketScanner |
|  | Add Picture Control | pic | picUploadProfile |
|  | Information Button | inf | infHelp |
|  | Pen Input | pen | penSignature |
|  | List Box | lis | lisOptions |
|  | Rich Text Editor | rte | rteComments |

### Screen Naming

> Existing ambiguity: the summary lists `scr`, but screen display-name examples use names such as `Home Screen` without that prefix.

- Use **Title Case with spaces** for screen display names.
- Examples: _Home Screen_, _Order Form Screen_.

### Control Prefixes

- Use a standard lowercase three-letter prefix + PascalCase purpose.
- Append `_ScreenName` for app-wide uniqueness.

**Examples:**

- `btnSubmit_MainScreen` (Button on MainScreen)
- `txtFirstName_UserInfo` (Text Input on UserInfo)

### Variable Naming

#### Global Variables

- Prefix with `gbl`.
- Use PascalCase after the prefix.
    - Example: `gblCurrentUserEmail`.

- Use when data must persist across multiple screens.
- See [`Set()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-set) documentation.

#### Context Variables

- Prefix with `ctx`.
- Use PascalCase after the prefix.
    - Example: `ctxFormLoading`.

- Scope limited to the screen where defined.
- See [`UpdateContext()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-updatecontext) documentation.

#### Collections

- Prefix with `col`.
- Use plural descriptive names.
    - Example: `colEmployees`, `colOrders`.

- Avoid naming collisions with actual data sources.
- Limit: **2,000 records maximum**.
- See [`ClearCollect()` and `Collect()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-clear-collect-clearcollect).

#### Named Formulas

- Prefix with `nf`.
- Used for static values that do not change during app runtime.
    - Example: `nfVATPercentage = 0.21`.

- Keep all named formulas in a single section for maintainability.
- See [Named Formulas](https://learn.microsoft.com/en-us/power-platform-release-plan/2022wave1/power-apps/power-fx-named-formulas-ease-development-improve-performance).

### Canvas Component Naming

- Use `cmp` + PascalCase purpose (`cmpHeader`, `cmpDialogConfirm`); suffix variants such as `cmpHeaderDark`.

## Controls and UI Components

### Standard Controls

#### Text Inputs

- Use clear and descriptive names with the `txt` prefix.
- Apply input constraints (e.g., number, email, date) to reduce user errors.
- Keep labels consistently aligned.
- Default values should be meaningful, not placeholders.

#### Buttons

- Prefix with `btn`.
- Use **action-driven labels** (_Submit_, _Save_, _Next_).
- Maintain consistent sizing, padding, and placement.
- Highlight primary actions with distinct styling.

#### Galleries

- Prefix with `gal`.
- Use galleries for displaying **lists of related records**.
- Always apply delegation-friendly filters on large data sources (see Microsoft Learn’s [Delegation overview](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/delegation-overview)).
- Limit displayed columns to what’s necessary.
- Use consistent template sizes across similar galleries.
- Refer to [Gallery control documentation](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/controls/control-gallery) for properties and best practices.

#### Forms

- Prefix with `frm`.
- Use **Edit Forms** for create/update, **Display Forms** for read-only (see Microsoft Learn’s [Edit form / Display form control](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/controls/control-form-detail)).
- Group related fields logically.
- Set **DefaultMode** explicitly (`FormMode.New`, `FormMode.Edit`) (see Microsoft Learn’s [Form mode documentation/functions](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/working-with-forms)).
- Validate inputs at the form level where possible.

### Complex Controls

#### Containers

- Prefix with `con`.
- Use containers for grouping controls and maintaining layout responsiveness.
- Name containers based on purpose (e.g., `conHeader`, `conFooter`).
- Avoid deep nesting unless required.

#### Tab Controls

- Prefix with `tab`.
- Use tab controls when multiple logical sections exist on a single screen.
- Keep tab labels short and descriptive.
- Ensure accessibility: indicate which tab is active clearly.

### Classic Controls vs. Modern Controls

#### Classic Controls

- Original Canvas controls supporting older application patterns.
- Offer **maximum flexibility** for customization.
- Require effort to make responsive.
- Styling inconsistent unless themed.

#### [Modern Controls](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/controls/modern-controls/overview-modern-controls)

- Built on Microsoft’s **Fluent UI design system**.
- Provide **consistent, accessible, responsive design** out of the box.
- Easier to style and align with Microsoft 365 apps.
- Fewer customization options compared to classic controls.

## Reusable Components & Libraries

### When to Create a Component

- Use lightweight components for UI or logic reused across screens or apps: headers, footers, dialogs.
- Encapsulate complexity and expose input/output properties; avoid over-engineering.

### Component Library Management

- Store common components in a **Component Library** for reuse.
- Version and document changes in a changelog.
- Test thoroughly before publishing updates.
- Naming convention: prefix with `cmp` + purpose (`cmpSearchBar`, `cmpDialog`).

### Standard Organization Components

- Prefer the organization's approved branding components where available.
- Have the responsible team review shared components for branding, accessibility, and performance.

## Power Fx Patterns & Formulas

### Formula Formatting

- Use consistent indentation and line breaks.
- Place operators (`And`, `Or`, `;`) on new lines.
- Example:

        If(
            ctxFormLoading,
            Notify("Form is still loading", NotificationType.Warning),
            SubmitForm(frmRegistration)
        )

### Common Logical Patterns

- Use [IfError()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-iferror) to handle data source errors gracefully.
- Use [Switch()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-if) instead of multiple nested `If()` statements.
- Apply [IsBlankOrError()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-iferror) before patching/submitting data.
- Use Boolean logic directly for toggles/checkboxes.
- Validate inputs early with `If()` + `IsBlank()` / `IsEmpty()`.
- Use [And() / Or() / Not()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-logicals) for combining conditions.

### With Function Usage

- Use [With()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-with) to name temporary values and avoid repeated expressions.
- Example:

        With(
            { today: Today() },
            If(
                DateDiff(today, DateValue(ExpirationDate)) < 30,
                Notify("Certificate will expire soon")
            )
        )

### Avoiding Deep Nesting

- Avoid long chains of nested `If()` or `LookUp()`.
- Break into smaller formulas using `nf`, `ctx`, or `gbl`.
- Refactor into reusable functions/components.

## Variables & Collections

### Scope Management

- Follow the global (`gbl`) and screen-local (`ctx`) scopes under Variable Naming.
- Clean up variables when leaving a screen if no longer needed; avoid reusing names across contexts.

### Initialization & Reset

- Initialize variables in **App.Formulas** ([Named Formulas](https://learn.microsoft.com/en-us/power-platform-release-plan/2022wave1/power-apps/power-fx-named-formulas-ease-development-improve-performance)) rather than only in `OnStart`.
- Provide sensible default values to prevent `Blank()` or error conditions.
- Use the [`Reset()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-reset) function to reinitialize controls.
- Reinitialize collections after clearing them to maintain schema consistency.

### Data Shaping in Collections

- Use [`ClearCollect()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-clear-collect-clearcollect) for initial loads and [`Collect()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-clear-collect-clearcollect) for incremental updates.
- Use [`AddColumns()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-addcolumns), [`DropColumns()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-dropcolumns), [`RenameColumns()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-renamecolumns) to shape data.
- Apply the Delegation Practices below when shaping large datasets.
- Follow the collection limit under Variable Naming.

## User Experience (UX) Guidelines

### Layout Consistency

- Maintain a consistent layout across all screens.
- Place navigation elements (menus, buttons) in familiar and predictable locations.
- Align text, inputs, and buttons using **containers** (`con`) to keep spacing uniform.
- Use consistent control sizing (e.g., all primary buttons have the same width).

### Accessibility Standards

- Follow Microsoft’s [Accessibility guidelines for Power Apps](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/accessibility-checker-overview).
- Always provide labels for inputs and ensure they’re read correctly by screen readers.
- Ensure color contrast meets accessibility standards (e.g., WCAG AA).
- Use the [Accessibility Checker](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/accessibility-checker-overview) built into Power Apps to validate compliance.
- Avoid using color as the only indicator of status or error.

### Theming and Branding

- Use a **centralized theme** for colors, fonts, and styles to ensure brand consistency.
- Use the organization's approved branding kit or catalog components where available.
- Keep theme colors minimal (primary, secondary, accent, error).
- Document and share theme definitions so they can be applied consistently across apps.

### Responsive Design

- Use **containers and flexible layouts** instead of fixed pixel values.
- Leverage the `App.Width` and `App.Height` properties to adapt layouts dynamically.
- Test apps across different form factors (desktop, tablet, mobile).
- Follow [Responsive design principles in Power Apps](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/create-responsive-layout).
- Prioritize vertical scrolling on smaller devices rather than horizontal scrolling.

## Performance Optimization

### Delegation Practices

- Check supported functions in the [delegation overview](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/delegation-overview).
- Always use delegation-friendly functions when working with large data sources.
- Avoid non-delegable operations (`CountIf`, `ForAll` with lookups, complex filters) when data may exceed the **delegation limit**.
- Use server-side filtering with `Filter()` and indexed fields instead of pulling all records into collections.
- Document known delegation limitations in app documentation.

### Control Count Management

- Limit the number of controls per screen to reduce load times.
- Combine static elements (e.g., icons, text) into fewer controls if possible.
- Use **reusable components** for repeating patterns instead of duplicating controls.
- Remove hidden or unused controls; they still affect performance.

### Data Caching Strategies

- Cache frequently used reference data in **collections** with `ClearCollect()`.
- Refresh cached data only when necessary (e.g., on app load or manual refresh).
- Use Concurrent Loading below for independent data sources.
- Avoid caching transactional or volatile data that must always be current.

### Concurrent Loading

- Load independent data sources with [`Concurrent()`](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-concurrent).
- Example:

        Concurrent(
            ClearCollect(colEmployees, Employees),
            ClearCollect(colDepartments, Departments),
            ClearCollect(colProjects, Projects)
        )

- Use with caution when data sources are large or have dependencies.

## Error Handling

### Input Validation

- Validate all user input at the control level before submission.
- Use properties like `Required`, `MaxLength`, and `Format` to restrict invalid input.
- Provide immediate feedback using [Notify()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-showerror) with `NotificationType.Error` when values are invalid.
- Avoid saving records until mandatory fields are validated.
- Use `IsMatch()` for enforcing patterns such as email addresses or phone numbers.

### Formula-Level Error Handling

- Wrap risky operations in [IfError()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-iferror) to gracefully handle failures (e.g., missing data, service errors).
- Use [IsBlankOrError()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-iferror) before submitting data to avoid null reference issues.
- Provide fallback values where possible (e.g., default to “N/A” if a lookup fails).
- Avoid exposing raw error messages from connectors or APIs directly to users.

### OnError Usage

- Use the [OnError property](https://www.matthewdevaney.com/power-apps-onerror-property-capture-log-unexpected-errors/) at the app or control level to catch unexpected runtime errors.
- Log errors to a monitoring system (Dataverse table, Application Insights, or a logging service).
- Provide user-friendly notifications when unexpected issues occur.
- Ensure that errors caught in `OnError` do not block core user workflows unless critical.

## Code Readability & Maintainability

### Commenting Guidelines

- Use the **`//` inline comment style** in Power Fx to explain the purpose of formulas.
- Comment **why** the logic exists, not just what it does.
- Keep comments concise but meaningful.
- Update comments when logic changes to avoid misleading information.
- Example:

        // Check if certificate expires within 30 days
        If(
            DateDiff(Today(), ExpirationDate) < 30,
            Notify("Certificate is about to expire")
        )

### Code Structure

- Break long formulas into smaller, reusable parts using:
    - **Named formulas (`nf`)** for constants or static calculations.

    - **Context variables (`ctx`)** for screen-local logic.

    - **Global variables (`gbl`)** when cross-screen values are required.

- Keep all initialization logic in **App.Formulas** for clarity.
- Use the [With()](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-with) function to simplify repeated expressions.
- Organize screens and components logically: Home, Forms, Galleries, Admin, etc.

### Avoiding Magic Numbers

- Replace numeric or string literals with **named formulas (`nf`)** for clarity and reuse.
- Example: Instead of hardcoding `0.21`, use `nfVATPercentage = 0.21`.
- Avoid hardcoding error messages or URLs; use environment variables or centralized constants.
- Document all constants in a dedicated section for easy updates.

## Integration & Extensibility

### PCF Components in Canvas

- Use [Power Apps Component Framework (PCF)](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/overview) when standard or modern controls don’t meet requirements.
- Ensure PCFs are thoroughly tested across devices (desktop, tablet, mobile).
- Only import PCFs from trusted sources (internal libraries or Microsoft-certified).
- Document which PCFs are used, their version, and purpose.
- Provide fallback behavior when PCFs fail to load or aren’t supported.

### Custom Connectors

- Use [Custom Connectors](https://learn.microsoft.com/en-us/connectors/custom-connectors/define-postman-collection) to connect apps to APIs not available in standard connectors.
- Always authenticate securely, preferably with **OAuth 2.0**.
- Define clear actions and triggers with descriptive names.
- Store API keys and secrets in **Environment Variables**, not hardcoded in the connector.
- Maintain version control and document usage of each custom connector.

### Azure AD App Registrations

- Use [Azure Active Directory App Registrations](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) when apps require authentication against APIs (Graph API, SharePoint, etc.).
- Follow organizational conventions for naming app registrations (see Naming Conventions section).
- Assign only the **minimum required permissions** to reduce security risks.
- Rotate secrets regularly and store them in **Azure Key Vault** or environment variables.
- Document the registration ID, purpose, and assigned owners in solution documentation.

### DLP & Environments

- [DLP policies](https://learn.microsoft.com/en-us/power-platform/admin/wp-data-loss-prevention) and environment configuration can restrict PCFs, custom connectors, and app registrations.
- Confirm the target environment permits the required features. Coordinate restricted or advanced integrations with the responsible Power Platform team.
