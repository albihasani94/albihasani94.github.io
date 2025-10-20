# Repository Guidelines

## Project Structure & Module Organization
- The root directory stores page content (`index.markdown`, `about.markdown`) and standalone assets such as `404.html` and `favicon.ico`.
- Jekyll posts live under `_posts/` using dated filenames; drafts stay in `_drafts/` until promoted.
- Shared includes sit in `_includes/`, while Sass partials stay in `_sass/` and are composed through `assets/main.scss` alongside `assets/images/`.
- The generated `_site/` output and Bundler artifacts are ignored; never commit them or `Gemfile.lock`.

## Build, Test, and Development Commands
- `bundle install --path vendor/bundle` — install Ruby gems locally inside `vendor/` so the repository stays clean.
- `bundle exec jekyll serve` — start a local preview at http://127.0.0.1:4000 with incremental rebuilding.
- `bundle exec jekyll serve --drafts` — include `_drafts/` content in the preview for editorial review.
- `JEKYLL_ENV=production bundle exec jekyll build` — produce a production build in `_site/` to sanity-check GitHub Pages output.

## Coding Style & Naming Conventions
- Posts and pages use YAML front matter matching the minima theme; prefer Markdown for prose and fenced code blocks with language tags.
- Name posts `YYYY-MM-DD-title.md`; drafts can keep the same pattern until published.
- Follow two-space indentation for HTML snippets, Markdown front matter, and SCSS, mirroring existing files; keep SCSS rules minimal and import via `assets/main.scss`.
- Do not add a `Gemfile.lock`; GitHub Pages supplies dependency versions.

## Testing Guidelines
- Rely on `bundle exec jekyll build` to surface Liquid syntax or front matter errors before pushing.
- Preview changes with `bundle exec jekyll serve (--drafts)` and click through navigation, feeds, and social cards.
- Watch the console for warnings (broken links, missing includes) and resolve them before opening a PR.

## Commit & Pull Request Guidelines

Follow the Pro Git book style for commits: a single-sentence subject in the imperative (aim for 50 characters or fewer), a blank line, then wrap any body text at ~72 characters to explain the why. Use the body only when it adds context or references issues. Pull requests should link issues, capture proof of tests, and call out deployment or configuration impacts. When this cheat sheet diverges from the contributor docs, update both to prevent drift.
