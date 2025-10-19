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
- Keep commits small with imperative, Title-Case messages similar to recent history (`Update README`, `Drop the version from github pages gem`).
- Reference issues in the message body when applicable and explain the why alongside the what.
- PRs should include a summary of visible changes, screenshots for UI tweaks, and call out any content needing review.
- Confirm the Pages build will succeed by keeping `_site/` untracked and ensuring the preview build is clean.
