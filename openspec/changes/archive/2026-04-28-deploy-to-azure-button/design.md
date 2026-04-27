## Context

The project has a Bicep template (`infra/main.bicep`) that can deploy the full stack, but the only way to use it today is `make deploy` from the CLI. Azure Portal supports a "Deploy to Azure" button pattern: a badge in the README links to a portal URL that pre-loads an ARM template and an optional custom UI form definition, letting users fill in parameters through a guided wizard and deploy without any CLI.

The reference implementation in `edot-cloud-forwarder-azure` uses:
- An ARM template JSON (`ecf.json`) compiled from Bicep
- A `uiFormDefinition.json` that drives the portal wizard UI
- A README badge whose `href` encodes both file URLs

Both files must be accessible at stable public URLs. GitHub raw (`raw.githubusercontent.com`) on the `main` branch is the simplest option.

## Goals / Non-Goals

**Goals:**
- One-click deploy from the README via Azure Portal
- Custom portal UI with friendly labels/descriptions for all required parameters
- ARM template generated from the existing Bicep (no duplication)
- `make arm` target to regenerate `main.json` whenever Bicep changes

**Non-Goals:**
- Azure Marketplace listing
- CI-automated ARM regeneration (manual for now)
- Multi-region or subscription-level deployments (resource group scope only)

## Decisions

### Compile Bicep → ARM JSON and commit it

The portal button needs a static URL pointing to a raw JSON file. Options:

| Option | Tradeoff |
|--------|----------|
| Commit `infra/main.json` to repo | Simple; always in sync if `make arm` is run before push |
| Generate via CI and attach to release | Decoupled but requires release workflow |
| Use Azure Bicep registry | More setup, overkill for a prototype |

**Decision**: Commit `infra/main.json`. Add `make arm` to regenerate it. Document that it must be regenerated when Bicep changes.

### UI form parameter scope

Expose only the parameters users must or commonly want to set:

| Parameter | UI step | Rationale |
|-----------|---------|-----------|
| `elasticsearchOtlpEndpoint` | Basics | Required, user-specific |
| `elasticsearchApiKey` | Basics | Required, secret |
| `containerImage` | Basics | Required; default to latest published image |
| `eventHubSku` | Advanced | Only Standard/Premium (Basic disallows Kafka) |
| `minReplicas` / `maxReplicas` | Advanced | Scaling knobs users may want to tune |

`baseName` and `location` are handled by `Microsoft.Common.ResourceScope`.

### Button URL encoding

Standard Azure Portal pattern:
```
https://portal.azure.com/#create/Microsoft.Template/uri/<arm-url-encoded>/createUIDefinitionUri/<ui-url-encoded>
```

Both URLs are double-encoded (URL-encoded, then the result goes into the portal URL).

## Risks / Trade-offs

- **`main.json` drift**: If Bicep is updated but `main.json` is not regenerated, the portal deploys stale infra. Mitigation: CI workflow fails the PR if `infra/main.json` is out of sync with `infra/main.bicep`.
- **Raw GitHub URL availability**: `raw.githubusercontent.com` is public and reliable for open repos.
- **ARM template size**: Compiled ARM from a small Bicep stays well under portal limits.

## Open Questions

- ~~Should `containerImage` default to a specific public Docker Hub tag, or leave blank?~~ **Resolved**: default to `mauriziobranca626/cloud-forwarder-aca:dev` (matches Makefile), editable.
