---
description: "Task list template for static-site feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`  
**Prerequisites**: plan.md (required), spec.md (user stories), research.md, data-model.md (if includes changes)

**Tests**: Run `bundle exec jekyll build` for every story. Add browser or Lighthouse checks only if requested.  
**Organization**: Tasks are grouped by user story to enable independent implementation and preview of each slice.

## Format: `[ID] [P?] [Story] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: User story identifier (e.g., US1, US2, US3)
- Reference exact file paths (e.g., `_posts/2025-10-20-update.md`)

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

**Purpose**: Ensure compatibility before touching content

- [ ] T001 Confirm plugin/dependency set remains GitHub Pages compliant
- [ ] T002 [P] Capture baseline Lighthouse/performance for impacted page(s)
- [ ] T003 Document navigation/includes/assets that require updates

---

## Phase 2: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [Preview path, e.g., "`bundle exec jekyll serve --drafts` → `/posts/...` renders and links from home page"]

### Build & Verification (if requested)

- [ ] T010 [P] [US1] Run `bundle exec jekyll build` and capture warnings (must be zero)
- [ ] T011 [P] [US1] Manual responsive check (desktop + mobile widths)

### Implementation

- [ ] T012 [US1] Add/modify content in [_posts/... or page] with valid front matter and two-space indentation
- [ ] T013 [US1] Update `_includes/nav.html` or related navigation anchors
- [ ] T014 [P] [US1] Optimize or add assets in `assets/images/` (alt text, sizes)
- [ ] T015 [US1] Refresh SEO metadata (front matter `title`, `description`, `image`)

**Checkpoint**: US1 content live-ready; build passes locally with zero warnings.

---

## Phase 3: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [Describe preview + verification flow]

- [ ] T020 [US2] Implement content/include updates
- [ ] T021 [P] [US2] Adjust `_sass/` partials with minimal scoped rules
- [ ] T022 [US2] Validate internal/external links
- [ ] T023 [P] [US2] Re-run build + targeted browser check

**Checkpoint**: US2 renders independently and is linkable without US1 dependencies.

---

## Phase 4: User Story 3 - [Title] (Priority: P3)

- Mirror US2 pattern. Add additional stories as required by spec.

---

## Phase N: Polish & Cross-Cutting Concerns

- [ ] T030 Update documentation/README references if guidelines changed
- [ ] T031 [P] Confirm `.specify` templates/scripts remain accurate (update if needed)
- [ ] T032 [P] Capture final Lighthouse snapshot and attach to PR
- [ ] T033 Verify commit messages follow "imperative, ≤50 char" rule

---

## Dependencies & Execution Order

- Phase 1 must complete before any story work begins.
- User stories can proceed in priority order or in parallel once dependencies for that story are satisfied.
- Every story includes its own `bundle exec jekyll build` check; failures block merging.
- Navigation/SEO updates that affect multiple stories need coordination — document shared tasks in Phase N.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Foundation Checks.
2. Deliver all Phase 2 tasks for User Story 1.
3. **Stop and validate**: run `bundle exec jekyll build`, preview via `serve --drafts`, capture screenshots.
4. Deploy/demo only after US1 meets acceptance scenarios.

### Incremental Delivery

1. Complete Phase 1 once.
2. Ship US1 (Phase 2) → preview → merge or queue for release.
3. Ship US2 (Phase 3) → preview → merge.
4. Continue with additional stories or move to Phase N for cross-cutting work.
5. Each story provides independent value and retains site stability.

### Parallel Team Strategy

1. Complete Phase 1 collectively (shared understanding of constraints).
2. Assign one user story per contributor; coordinate shared includes/assets in stand-ups.
3. Require each contributor to provide build output and preview evidence before integration.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story must be independently previewable with `bundle exec jekyll serve --drafts`
- Capture build output/screenshots in PR to satisfy preview principle
- Commit after each task or logical grouping with imperative subject lines
- Avoid: vague tasks, shared file conflicts, cross-story dependencies that break independence

