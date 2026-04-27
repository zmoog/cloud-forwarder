## 1. ARM Template

- [ ] 1.1 Add `make arm` target to `Makefile` that runs `az bicep build --file infra/main.bicep --outfile infra/main.json`
- [ ] 1.2 Run `make arm` to generate `infra/main.json` from the current Bicep

## 2. UI Form Definition

- [ ] 2.1 Create `infra/uiFormDefinition.json` with `$schema` set to `https://schema.management.azure.com/schemas/2021-09-09/uiFormDefinition.schema.json`
- [ ] 2.2 Add Basics step: `Microsoft.Common.ResourceScope`, OTLP endpoint (TextBox), API key (PasswordBox), container image (TextBox with default), Event Hub SKU (DropDown: Standard/Premium)
- [ ] 2.3 Add Advanced step: min replicas (Slider 0–10, default 1), max replicas (Slider 1–10, default 3), partition count (Slider 2–32, default 4), message retention days (Slider 1–7, default 1)
- [ ] 2.4 Wire `outputs.parameters` to map all form fields to Bicep parameter names

## 3. CI Check

- [ ] 3.1 Create `.github/workflows/check-arm.yml` — on push/PR when `infra/main.bicep` or `infra/main.json` changes, run `az bicep build` and `git diff --exit-code infra/main.json` to fail if the committed JSON is stale

## 4. README Button

- [ ] 4.1 Construct the Deploy to Azure portal URL: double-encode the raw GitHub URLs for `infra/main.json` and `infra/uiFormDefinition.json`
- [ ] 4.2 Add the Deploy to Azure badge to `README.md` after the intro paragraph and before the Architecture Overview section
