# Code Apps — quick demo

## 1. Scaffold

```powershell
npx degit github:microsoft/PowerAppsCodeApps/templates/vite customer-spotlight
cd customer-spotlight
npm install
```

Initialize before running locally (creates `power.config.json`):

```powershell
pa app init --display-name "Customer Spotlight" --environment-id "YOUR-ENVIRONMENT-ID"
```

## 2. Run locally

```powershell
pa app run
```

Open **Local Play**. Leave this terminal running.

## 3. Add functionality with AI

Paste into your IDE assistant:

```text
Make the vite and react logo spin really fast!
```

## 4. Connect to Dataverse

In a second terminal, from the app folder:

```powershell
pa app add data-source --connector dataverse --table systemuser --org-url "https://fsvtechdev.crm4.dynamics.com/"
```

The `systemuser` data source provides access to the Users table. Loading all users requires querying that service and following pagination, subject to your Dataverse permissions.

Paste into your IDE assistant:

```text
I have added the systemuser table, let's see which users are in that table, show them on the screen in a simple table, don't add error states or checks, just show me the names and emails!
```
Run pa app run

## 5. Publish

```powershell
npm run build
```

After the build succeeds:

```powershell
pa app push
```

Open the returned app URL.
