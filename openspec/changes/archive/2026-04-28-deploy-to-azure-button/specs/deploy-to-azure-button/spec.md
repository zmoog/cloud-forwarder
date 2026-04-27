## ADDED Requirements

### Requirement: ARM template exists as committed JSON
The repo SHALL contain `infra/main.json`, an ARM template compiled from `infra/main.bicep`, so Azure Portal can reference it via a raw GitHub URL.

#### Scenario: ARM template present in repo
- **WHEN** a user browses `infra/` in the repository
- **THEN** `main.json` is present and is valid ARM JSON

#### Scenario: Regenerate ARM template
- **WHEN** a developer runs `make arm`
- **THEN** `infra/main.json` is regenerated from `infra/main.bicep` using `az bicep build`

### Requirement: Custom UI form definition exists
The repo SHALL contain `infra/uiFormDefinition.json` conforming to the Azure UI Form Definition schema (`2021-09-09`), driving the portal deployment wizard.

#### Scenario: Form definition is valid
- **WHEN** `infra/uiFormDefinition.json` is submitted to the Azure Portal
- **THEN** the portal renders a two-step wizard (Basics, Advanced) without errors

#### Scenario: Basics step collects required parameters
- **WHEN** a user fills in the Basics step
- **THEN** they can provide: Elasticsearch OTLP endpoint, Elasticsearch API key (password field), container image (editable TextBox defaulting to `mauriziobranca626/cloud-forwarder-aca:dev`), and Event Hub SKU

#### Scenario: Advanced step collects scaling parameters
- **WHEN** a user expands the Advanced step
- **THEN** they can set minimum replicas, maximum replicas, partition count, and message retention days

#### Scenario: Form outputs map to Bicep parameters
- **WHEN** the user completes the wizard and clicks Deploy
- **THEN** the portal passes all form values to the ARM template parameters, including `elasticsearchOtlpEndpoint`, `elasticsearchApiKey`, `containerImage`, `eventHubSku`, `minReplicas`, `maxReplicas`

### Requirement: Deploy to Azure button URL is correct
The README badge href SHALL encode both the ARM template URL and the UI form definition URL using double URL-encoding, pointing at `raw.githubusercontent.com/zmoog/cloud-forwarder/main/infra/`.

#### Scenario: Button opens Azure Portal deployment wizard
- **WHEN** a user clicks the "Deploy to Azure" button in the README
- **THEN** the Azure Portal opens and loads the custom deployment wizard pre-populated with the Cloud Forwarder ACA template
