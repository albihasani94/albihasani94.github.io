---
description: "Task list for Update Social Branding to X"
---

# Tasks: Update Social Branding to X

**Input**: Design documents from `/specs/001-x-brand-update/`  
**Prerequisites**: plan.md (required), spec.md (user stories), research.md, data-model.md, quickstart.md

**Tests**: Run `bundle exec jekyll build` for every story. Add browser or Lighthouse checks only if requested.  
**Organization**: Tasks are grouped by user story so each slice can be previewed independently.

## Format: `[ID] [P?] [Story] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: User story identifier (e.g., US1, US2, US3)
- Reference exact file paths (e.g., `_includes/social.html`)

## Path Conventions
- Content: `_posts/`, `_drafts/`, `index.markdown`, `about.markdown`
- Presentation: `_includes/`, `_sass/`, `assets/` (images, CSS)
- Configuration: `_config.yml`, `Gemfile`, `CNAME`
- Temporary build output (`_site/`) and Bundler artifacts (`vendor/`) stay uncommitted

<!--
  ============================================================================
  IMPORTANT: Replace the sample tasks below with real tasks derived from:
  - User stories and requirements in spec.md
  - Principles in the constitution (build verification, Markdown discipline, template sync)
  - Navigation, SEO, and asset considerations documented in plan.md

  Tasks MUST stay grouped by user story so each story ships independently and
  can be previewed via `bundle exec jekyll serve --drafts`.
  ============================================================================
-->

## Phase 1: Foundation Checks (Blocking)

**Purpose**: Ensure the repository has the official X asset and documented provenance before template work begins.

- [X] T001 Create `assets/custom_icons/` directory and add tracking file `assets/custom_icons/.gitkeep`.
- [X] T002 Download the official X SVG logo from the brand kit into `assets/custom_icons/x.svg` and record the source URL in `assets/custom_icons/README.md`.
- [X] T003 Optimize `assets/custom_icons/x.svg` with `svgo --multipass`, confirm the file size is ≤ 10 KB, and document the size and checksum in `assets/custom_icons/README.md`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Align global configuration with the new social presence before user story work.

- [X] T004 Update `_config.yml` social configuration to expose `site.x_username` pointing to `https://x.com/albihasani94` and remove active references to `site.twitter_username`.
- [X] T005 Run `bundle exec jekyll build` from project root `./` to confirm the site builds cleanly with the new asset and configuration baseline.

---

## Phase 3: User Story 1 - Follow the X Profile (Priority: P1) 🎯 MVP

**Goal**: Visitors can click the social icon and reach the X profile with accessible labeling.

**Independent Test**: `bundle exec jekyll serve --drafts` → footer social link renders X icon, opens `https://x.com/albihasani94` in new tab, and is announced as “X” by screen readers.

### Implementation

- [X] T006 [US1] Replace the Twitter entry in `_includes/social.html` with an X link that loads `/assets/custom_icons/x.svg`, points to `https://x.com/albihasani94`, and sets `aria-label="Follow Albi on X"`.
- [X] T007 [US1] Ensure the X list item in `_includes/social.html` opens in a new tab with `target="_blank"` and `rel="noopener noreferrer"`, and the visible label displays “X”.
- [X] T008 [US1] Run `bundle exec jekyll serve --drafts` in project root `./` and validate icon rendering, link destination, and screen-reader announcement for the X social link.

**Checkpoint**: US1 content live-ready; build passes locally with zero warnings.

---

## Phase 4: User Story 2 - Maintain Brand Consistency (Priority: P2)

**Goal**: All non-legacy references align with the X brand while other social links remain unchanged.

**Independent Test**: Repository-wide search (excluding `_posts/`, `_drafts/`) yields no active “Twitter” references, and social UI still renders uniformly.

- [X] T009 [US2] Update `_config.yml` metadata (e.g., SEO or social link labels) to say “X” where the social link is surfaced, removing “Twitter” text outside historical content.
- [X] T010 [US2] Replace remaining non-legacy “Twitter” mentions by auditing repository root `./` (excluding `_posts/`, `_drafts/`) and document any intentional exceptions in `specs/001-x-brand-update/research.md`.
- [X] T011 [US2] Re-run `bundle exec jekyll serve --drafts` in project root `./` and verify layout, spacing, and styling for all social icons remain consistent after copy updates.

**Checkpoint**: US2 renders independently and is linkable without US1 dependencies.

---

## Phase 5: User Story 3 - Track Referral Traffic (Priority: P3)

**Goal**: Analytics guidance ensures referral traffic continues to attribute to X without reconfiguration.

**Independent Test**: Documentation details expected referral names and manual validation steps sourced in analytics tooling.

- [X] T012 [US3] Expand the analytics guidance in `specs/001-x-brand-update/quickstart.md` to include explicit steps for validating X referral attribution post-deploy.
- [X] T013 [US3] Record the expected analytics referrer label (“x.com” or provider-specific equivalent) and validation notes in `specs/001-x-brand-update/research.md`.

**Checkpoint**: US3 documentation enables attribution checks without additional implementation dependencies.

---

## Phase N: Polish & Cross-Cutting Concerns

- [X] T014 Document the official X asset source and optimization steps in `README.md` to assist future maintainers.
- [X] T015 Capture before/after screenshots of the social section and save them to `specs/001-x-brand-update/assets/x-icon-before-after.png` for PR evidence.
- [X] T016 Run final `bundle exec jekyll build` from project root `./` and confirm zero warnings ahead of review.

---

## Dependencies & Execution Order

- Phase 1 must complete before any entry-point files reference the X asset.
- Phase 2 depends on Phase 1 and must complete before user story work begins.
- US1 (Phase 3) depends on Phase 2 and delivers the MVP slice.
- US2 (Phase 4) depends on US1 completion to avoid conflicting template edits.
- US3 (Phase 5) depends on US1 (for the link) but can run in parallel with US2 once Phase 2 finishes.
- Polish tasks run after all desired user stories finish.

## Parallel Example: User Story 1

```bash
# Run preview and accessibility validation together after template updates
Task: T006 [US1] Replace the Twitter entry in _includes/social.html
Task: T007 [US1] Ensure new tab behavior and visible label in _includes/social.html
Task: T008 [US1] Run bundle exec jekyll serve --drafts for validation
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 (asset setup) and Phase 2 (configuration alignment).
2. Execute US1 tasks (T006–T008) to ship a functional X link.
3. Stop and validate via local preview before merging if fast follow stories are deferred.

### Incremental Delivery

1. Foundation (Phases 1–2) → US1 for MVP.
2. Ship US2 to polish branding consistency.
3. Ship US3 to finalize analytics guidance.
4. Run Polish phase to document and verify before release.

### Parallel Team Strategy

1. One contributor owns asset preparation (Phase 1) while another reviews configuration (Phase 2).
2. After Phase 2, US1 can proceed; US2 can start once US1 template changes merge; US3 can draft documentation concurrently with US2.
3. Coordinate on shared files (`_config.yml`, `_includes/social.html`) to avoid conflicts.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] labels map tasks to specific user stories for traceability
- Each user story must remain independently previewable with `bundle exec jekyll serve --drafts`
- Capture build output and screenshots in PR to satisfy preview requirements
- Commit after each task or logical grouping with imperative subject lines
- Avoid vague tasks, shared file conflicts, or cross-story dependencies that break independence
