<!--
Sync Impact Report
Version change: 0.0.0 → 1.0.0
Modified principles:
- [PRINCIPLE_1_NAME] → GitHub Pages Compatibility First
- [PRINCIPLE_2_NAME] → Content-Led Markdown Discipline
- [PRINCIPLE_3_NAME] → Preview Before Publish
- [PRINCIPLE_4_NAME] → Branch and Spec-Driven Changes
- [PRINCIPLE_5_NAME] → Templates and Automation Stay in Sync
Added sections:
- Operational Constraints
- Workflow Expectations
Removed sections:
- None
Templates requiring updates:
- ✅ .specify/templates/plan-template.md
- ✅ .specify/templates/spec-template.md
- ✅ .specify/templates/tasks-template.md
Follow-up TODOs:
- None
-->

# albinhasani.net Constitution

## Core Principles

### GitHub Pages Compatibility First
- Rely exclusively on the `github-pages` gem bundle and its whitelisted plugins, themes, and configuration.
- Keep `_site/`, `vendor/`, and `Gemfile.lock` out of version control; use `bundle install --path vendor/bundle` locally.
- Document any configuration change in `_config.yml` and demonstrate that GitHub Pages can build it.
- Rationale: The live site is deployed by GitHub Pages; incompatibilities or unmanaged dependencies break production.

### Content-Led Markdown Discipline
- Write and edit pages/posts in Markdown with complete YAML front matter, two-space indentation, and accessible language.
- Ensure every content change updates navigation, includes, assets, and SEO metadata so readers can reach and share it.
- Treat screenshots and images as first-class assets: optimized sizes, descriptive filenames, and mandatory alt text.
- Rationale: The site exists to communicate clearly; consistent Markdown and metadata keep the reading experience intact.

### Preview Before Publish
- Run `bundle exec jekyll build` (and address every warning) before requesting review or merging.
- Use `bundle exec jekyll serve` with `--drafts` when relevant to validate flow, links, and responsive layouts.
- Capture preview evidence (build output, screenshots, or Lighthouse deltas) in the PR description or linked artefacts.
- Rationale: Local previews surface issues before GitHub Pages builds, preventing broken pages or regressions from shipping.

### Branch and Spec-Driven Changes
- Perform all non-trivial work on `feature/<slug>` branches branched from `master`; avoid direct pushes.
- Produce or update spec-kit artefacts (plan.md, spec.md, tasks.md) before implementation, and keep them in sync with code.
- Reference the controlling spec/plan in commits and PRs so reviewers can trace requirement coverage quickly.
- Rationale: Structured planning and isolated branches protect the stable site while preserving traceability.

### Templates and Automation Stay in Sync
- Update `.specify` templates and scripts whenever the workflow, principles, or tooling changes; delete stale guidance.
- Note in PRs which automation or documentation files were touched (or why none were needed) to keep reviewers aligned.
- Audit new automation for compatibility with the rest of the toolchain before adoption.
- Rationale: Our templates drive how future work is executed—if they drift, the process decays.

## Operational Constraints

- The authoritative stack is Ruby 3.x with the `github-pages` gem (currently `~> 232`) and the enabled plugins in `_config.yml`.
- New layouts, includes, or Sass must remain compatible with the minima-derived theme; keep Sass rules scoped and minimal.
- Images belong under `assets/images/` and should be optimized for web delivery; avoid oversized or uncompressed assets.
- Source control excludes build output, transient caches, and local Bundler installs; enforce this via `.gitignore`.
- Follow the repository’s two-space indentation and avoid introducing non-ASCII characters unless demanded by content.

## Workflow Expectations

- Branch from `master`, name branches `feature/<slug>`, and keep them focused on a single spec or content change.
- Prepare implementation plans, specifications, and task lists using spec-kit templates before editing site files.
- Run `bundle exec jekyll build` (and `serve --drafts` when drafts are touched) before requesting review, documenting results.
- Commit messages follow the “imperative, ≤50 characters” rule; group related markdown, asset, and template updates logically.
- Pull requests must cite the relevant spec/plan, link preview evidence, and describe any template/automation updates made.

## Governance

- This constitution supersedes conflicting documentation. Amendments require a PR that details rationale, version impact, and template updates.
- Versioning follows semantic rules: MAJOR for principle removal/redefinition, MINOR for new principles or sections, PATCH for clarifications.
- Ratification occurs when the PR merges to `master`; `LAST_AMENDED_DATE` must match the merge date.
- Compliance is reviewed during plan/spec approvals and PR review checklists; violations block merge until resolved or explicitly waived.
- Waivers are exceptional: document them in the PR, update follow-up tasks, and schedule remediation.

**Version**: 1.0.0 | **Ratified**: 2025-10-20 | **Last Amended**: 2025-10-20
