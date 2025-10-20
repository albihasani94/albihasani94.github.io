# Research: Update Social Branding to X

## Decision: Use official X SVG wordmark
- **Rationale**: Ensures brand compliance and legal usage while providing the crispest rendering on high-DPI displays. SVG keeps file size minimal when optimized.
- **Alternatives considered**:
  - PNG raster export from brand kit (rejected: larger file, loses scalability).
  - Reusing legacy Twitter icon (rejected: conflicts with rebrand directive).

## Decision: Store asset under `assets/custom_icons/x.svg`
- **Rationale**: Keeps bespoke assets separate from minima defaults and aligns with sponsor request for `assets/custom_icons/`.
- **Alternatives considered**:
  - Overwriting `assets/minima-social-icons.svg` (rejected: harder to maintain and diverges from upstream minima updates).
  - Hosting icon via CDN (rejected: introduces external dependency and possible availability issues).

## Decision: Optimize SVG to ≤ 10 KB
- **Rationale**: Meets performance goal to avoid asset bloat while preserving vector quality.
- **Alternatives considered**:
  - Leaving raw brand kit SVG (rejected: often includes metadata increasing weight).
  - Converting to icon font glyph (rejected: adds complexity and unused font data).

## Decision: Update `_includes/social.html` to reference new asset
- **Rationale**: Ensures consistent icon usage across site footer/header and maintains ARIA labeling.
- **Alternatives considered**:
  - Embedding inline SVG markup per page (rejected: duplicates code and increases maintenance effort).

## Reference Audit
- Removed active “Twitter” copy from configuration and includes; remaining occurrences exist only within planning/specification documents that describe the migration history.
- Legacy blog content under `_posts/` and `_drafts/` is intentionally untouched to preserve historical accuracy.

## Analytics Attribution
- Expected referral domain: `x.com` (with possible redirect domain `t.co` when shortened).
- Validation approach: After deployment, trigger a real click-through and confirm analytics dashboards classify traffic under X-branded sources; document evidence alongside release artifacts.
