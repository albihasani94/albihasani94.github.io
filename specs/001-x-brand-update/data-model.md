# Data Model: Update Social Branding to X

## Entities

### SocialPresence
- **Identifier**: `platform` (e.g., `x`, `github`)
- **Fields**:
  - `platform`: string, required, lowercase key used in templates.
  - `handle`: string, required, social username (e.g., `albihasani94`).
  - `display_label`: string, required, human-facing name (“X”).
  - `url`: string, required, absolute link (e.g., `https://x.com/albihasani94`).
  - `icon_path`: string, required, relative path to SVG asset (e.g., `/assets/custom_icons/x.svg`).
  - `aria_label`: string, required, accessible label (“Follow Albi on X”).
- **Relationships**:
  - Referenced by layout includes rendering social links; no external data store.
- **State Transitions**:
  - Updated when branding changes; no lifecycle beyond publish time.

### BrandAsset
- **Identifier**: `slug` (e.g., `x-logo`)
- **Fields**:
  - `slug`: string, required, unique asset key.
  - `source_url`: string, required, canonical brand-kit download URL.
  - `file_path`: string, required, repository location (`assets/custom_icons/x.svg`).
  - `file_size_kb`: number, required, must be ≤ 10.
  - `license_notes`: string, optional, record of usage terms.
- **Relationships**:
  - Associated with `SocialPresence.icon_path`.
- **State Transitions**:
  - Created during this feature; future updates occur when X revises branding.
