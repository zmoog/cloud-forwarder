## ADDED Requirements

### Requirement: README contains Deploy to Azure button
The `README.md` SHALL include a "Deploy to Azure" button near the top (after the intro paragraph, before the Architecture Overview section) using the standard Azure badge image and a correctly-encoded portal URL.

#### Scenario: Button is visible at the top of the README
- **WHEN** a user views the README on GitHub
- **THEN** they see a "Deploy to Azure" badge/button before the architecture diagram

#### Scenario: Button links to the correct portal URL
- **WHEN** the button href is inspected
- **THEN** it contains the double-URL-encoded raw GitHub URLs for both `infra/main.json` and `infra/uiFormDefinition.json`
