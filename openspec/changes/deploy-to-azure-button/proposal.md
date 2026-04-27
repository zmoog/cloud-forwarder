## Why

One-click deployment from the README lowers the barrier to trying Cloud Forwarder ACA: users can deploy the full stack (Event Hubs + Container App + Elasticsearch wiring) directly from the Azure Portal without touching the CLI.

## What Changes

- Add a `uiFormDefinition.json` in `infra/` that defines the Azure Portal custom deployment UI (fields for Elasticsearch endpoint, API key, container image, Event Hub SKU, replica counts)
- Compile `infra/main.bicep` to `infra/main.json` (ARM template) so it can be referenced by a stable raw GitHub URL
- Add a `make arm` target to regenerate `main.json` from Bicep
- Add a "Deploy to Azure" badge/button to `README.md` pointing at the hosted ARM template + UI definition

## Capabilities

### New Capabilities
- `deploy-to-azure-button`: One-click Azure Portal deployment flow — ARM template + custom UI form definition wired up via a README badge

### Modified Capabilities
- `readme`: Add the Deploy to Azure button and brief usage note

## Impact

- New files: `infra/uiFormDefinition.json`, `infra/main.json`
- Modified: `README.md`, `Makefile`
- No code changes; no breaking changes
