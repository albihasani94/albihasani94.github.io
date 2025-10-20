# Feature Specification: Update Social Branding to X

**Feature Branch**: `001-x-brand-update`  
**Created**: 2025-10-20  
**Status**: Draft  
**Input**: User description: "This is an established project. The upcoming changes might be just aesthetic changes, theme switching, or plugins maintenance and build automation. The posts will never be AI written. The planned change I have is switching the url and icon from `twitter` to `X` after its rebrand."

> All content additions MUST include valid YAML front matter, use two-space indentation for HTML/Markdown fragments, and note any navigation or include updates required.

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value (e.g., a new article,
  refactored include, or refreshed asset).
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Follow the X Profile (Priority: P1)

Site visitors want to follow the author on social media by using the social link provided on every page.

**Why this priority**: The social link is a high-visibility call-to-action in the header/footer; keeping it accurate preserves trust and traffic.

**Independent Test**: Preview the site via `bundle exec jekyll serve --drafts`, click the social icon from the home page footer, confirm the page title references X and loads the correct profile.

**Acceptance Scenarios**:

1. **Given** a published page with social links, **When** a visitor selects the X icon, **Then** the link opens `https://x.com/albihasani94` in a new tab.
2. **Given** the same page, **When** assistive technology reads the link, **Then** it announces the destination as “X” (or “X profile”) and not “Twitter”.

---

### User Story 2 - Maintain Brand Consistency (Priority: P2)

The site owner wants the social section, metadata, and assets to reflect the X rebrand without regressions to other social links.

**Why this priority**: Accurate branding keeps the site professional and avoids confusion when sharing content.

**Independent Test**: Review the header/footer/social include and Lighthouse accessibility report to confirm the icon and label meet X branding while other social links remain unchanged.

**Acceptance Scenarios**:

1. **Given** the updated build, **When** the social icons render, **Then** the X glyph replaces the Twitter bird while layout and styling remain consistent with other icons.
2. **Given** the updated repository, **When** searching for the string “Twitter” (case-insensitive) outside legacy post content, **Then** no matches exist.

---

### User Story 3 - Track Referral Traffic (Priority: P3)

The site owner needs analytics to continue attributing visits from X without reconfiguration.

**Why this priority**: Reliable referral tracking supports marketing decisions and validates the rebrand work.

**Independent Test**: After deploying to a staging environment, verify that analytics tools classify clicks from the updated link under X (or the equivalent referrer) without creating a new, unknown channel.

**Acceptance Scenarios**:

1. **Given** existing analytics dashboards, **When** the updated link is clicked, **Then** the session source shows as X (or the expected referrer) rather than “twitter.com”.
2. **Given** the site configuration, **When** previewing the HTML `<a>` tag, **Then** the `href` uses `https://x.com/…` and no URL shorteners that would obscure attribution are introduced.

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- Social link handle is absent or different between environments (e.g., production vs. local config).
- SVG sprite cache persists in browsers, temporarily showing the old Twitter icon.
- Legacy blog posts embed Twitter content that must remain untouched and functional.

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: Site MUST present the social link as “X” across all global surfaces (header, footer, feed metadata) with consistent copy.
- **FR-002**: Site MUST update the social hyperlink to `https://x.com/albihasani94` (opening in a new tab) without breaking existing analytics tracking.
- **FR-003**: Site MUST display an X-branded icon that meets accessibility requirements (contrast, descriptive text, focus states).
- **FR-004**: Site MUST remove non-legacy references to “Twitter” from configuration, includes, and navigation labels while preserving embedded historical content.
- **FR-005**: Build MUST pass (`bundle exec jekyll build`) and report zero warnings related to the social link or icon update.
- **FR-006**: Site MUST source the X icon from official brand assets, optimize it to ≤ 10 KB, and store it at `assets/custom_icons/x.svg`.

### Key Entities *(include if feature involves data)*

- **Social Presence**: Represents the author’s public social profiles; includes handle, display label, and target URL.
- **Brand Iconography**: Set of SVG glyphs used for social links; each glyph pairs with accessible labels and must align with current brand guidelines.

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: 100% of audited pages show “X” (not “Twitter”) in visible copy and assistive technology labels for the social link.
- **SC-002**: `bundle exec jekyll build` completes with 0 warnings or errors related to social links or assets.
- **SC-003**: Lighthouse accessibility score remains ≥ 90 after the icon swap on the affected pages.
- **SC-004**: Referral analytics continue attributing ≥ 95% of social traffic from this link to X (or equivalent) within 30 days of release.

## Assumptions

- The handle `albihasani94` remains valid on X and should replace the twitter.com domain everywhere the social link is constructed.
- Embedded historical tweets inside posts/drafts remain unchanged because they provide historical context and use Twitter’s script.
- No additional social networks are introduced or removed as part of this update; scope is limited to the existing Twitter → X transition.
- The official X asset download URL remains publicly accessible for the duration of the project.
