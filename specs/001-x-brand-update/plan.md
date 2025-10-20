# Implementation Plan: Update Social Branding to X

**Branch**: `001-x-brand-update` | **Date**: 2025-10-20 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-x-brand-update/spec.md` plus sponsor note to source an official lightweight X logo stored under `assets/custom_icons/`.

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/scripts/bash/setup-plan.sh` for the execution workflow.

## Summary

Replace the site’s current Twitter branding with the X rebrand by updating copy, links, and iconography. Pull an official X logo asset (SVG) from the brand kit, store it under `assets/custom_icons/`, reference it in `_includes/social.html`, and ensure accessibility and analytics parity remain intact. Confirm no non-legacy references to “Twitter” remain outside historical posts.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section if the change deviates
  from the default project context captured below.
-->

**Language/Version**: Ruby 3.x (GitHub Pages managed runtime)  
**Primary Dependencies**: `github-pages` suite (`jekyll`, `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`)  
**Storage**: N/A (static content)  
**Testing**: `bundle exec jekyll build` (must complete without warnings)  
**Target Platform**: GitHub Pages → modern desktop & mobile browsers  
**Project Type**: Static Jekyll site (minima-derived)  
**Performance Goals**: Maintain Lighthouse scores ≥ 90 and limit asset bloat (new icon ≤ 10 KB)  
**Constraints**: Only use GitHub Pages–supported plugins/themes; never commit `Gemfile.lock` or `_site/`; keep content accessible; X logo must come from official brand kit and live in `assets/custom_icons/`  
**Scale/Scope**: Single-author personal site — document impacted pages, posts, includes, and assets

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] GitHub Pages compatibility confirmed (supported plugins only, no `Gemfile.lock`, respects existing config)
- [x] Markdown front matter + two-space indentation defined for every new/changed page or post
- [x] Preview plan includes `bundle exec jekyll build` and `bundle exec jekyll serve [--drafts]` with warning remediation
- [x] Branch, spec, plan, and tasks artifacts captured and linked for review
- [x] Required updates to `.specify` templates/scripts or site navigation are identified (none required; document if discovery changes this)

## Project Structure

### Documentation (this feature)

```
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
```
repository-root/
├── index.markdown
├── about.markdown
├── _posts/
├── _drafts/
├── _includes/
├── _sass/
├── assets/
│   └── images/
├── 404.html
└── CNAME | favicon.ico | other root-level assets
```

**Structure Decision**: Update `_includes/social.html`, `_config.yml` social metadata, and global layout references if needed; add `assets/custom_icons/x.svg`; ensure `_site/` remains ignored.

## Complexity Tracking

*Fill ONLY if Constitution Check has violations that must be justified*

No constitution violations identified.
