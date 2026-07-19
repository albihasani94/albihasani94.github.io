# Repository Guidelines

## Project Structure

- This is a Jekyll site published from `master` by GitHub Pages at
  `albinhasani.net`. Treat `_config.yml`, `CNAME`, and `Gemfile` as
  deployment-sensitive files.
- Root-level pages include `index.markdown`, `about.markdown`, and `404.html`.
  Blog posts live in `_posts/` and use `YYYY-MM-DD-title.md` filenames. Put
  unpublished work in `_drafts/`, creating that directory when needed.
- `_includes/social.html` overrides the theme's social links. Sass partials in
  `_sass/` are imported through `assets/main.scss`; images and icons belong
  under `assets/`.
- `_site/`, Jekyll caches, `.bundle/`, `vendor/`, and `Gemfile.lock` are ignored
  local artifacts. Do not edit or commit them.

## Build and Development Commands

- `bundle install --path vendor/bundle` installs the dependencies in the
  ignored `vendor/` directory.
- `bundle exec jekyll serve` starts a preview at <http://127.0.0.1:4000>.
- `bundle exec jekyll serve --drafts` includes content from `_drafts/`.
- `JEKYLL_ENV=production bundle exec jekyll build` performs the production
  build used for final validation.
- Restart the Jekyll server after changing `_config.yml`; configuration changes
  are not reloaded automatically.

## Content and Style Conventions

- Use YAML front matter on every page and post. Posts require `layout: post`,
  `title`, and `date`; preserve an existing `permalink` because changing it
  breaks published URLs. Add `description`, `image`, `categories`, `tags`, and
  excerpt metadata when they improve discovery or the home-page summary.
- Prefer Markdown for prose and fenced code blocks with a language identifier.
  Put post images in `assets/images/` and use descriptive lowercase filenames.
- For every new post being published, suggest a dedicated social-preview image
  for both X and LinkedIn. Prefer a 1200×630 PNG or JPEG in `assets/images/`
  and set the post's `image.path`, `image.width`, `image.height`, and
  `image.alt` front matter so `jekyll-seo-tag` emits the sharing metadata.
- Use `assets/images/post-social-background.svg` as the authoring base for new
  post previews. It carries the visual language established by
  `fable-5-handover-social.png`: a deep navy field, a quiet square grid,
  oversized cropped indigo circles, and a warm amber vertical rail. Keep the
  background SVG free of post-specific text or illustrations so it remains
  reusable.
- Layer each post's identity over that base with a bold off-white sans-serif
  title, a shorter muted blue-gray description, and a footer containing
  `ALBINHASANI.NET` in amber plus a compact topic line in blue-gray. Keep text
  left-aligned, begin it to the right of the amber rail, preserve generous
  negative space, and keep essential content at least 60 px from the canvas
  edges. Aim for a title around 72–88 px, description around 28–32 px, and
  footer around 22–26 px, reducing or wrapping text rather than crowding it.
- A post-specific motif may replace or complement one of the circles, but keep
  it simple, geometric, low-contrast, and subordinate to the title. Preserve
  the navy, indigo, amber, off-white, and blue-gray palette across posts; use
  the Fable card as the reference when a design choice is ambiguous.
- Treat SVGs as editable source assets. Export the finished post preview to a
  1200×630 PNG or JPEG, check it at thumbnail size for legibility, and point
  front matter at the raster export rather than the authoring SVG.
- Use two spaces for nested YAML and SCSS. For HTML and Liquid, match the
  surrounding file and keep whitespace-control markers such as `{%-` intact.
- Keep site-wide identity, plugin, and social-handle settings in `_config.yml`.
  Update `_includes/social.html` only when the rendered social markup changes.
- Keep Sass rules in `_sass/` and import new partials from `assets/main.scss`.
  Avoid duplicating styles already supplied by the Minima theme.

## Testing Guidelines

- Run the production build before pushing. Resolve Liquid, YAML, plugin, and
  missing-include errors and review all warnings.
- Preview affected pages for visible changes. Check navigation, social links,
  `/feed.xml`, `/sitemap.xml`, image loading, and relevant SEO metadata.
- Jekyll does not comprehensively validate hyperlinks. Manually check any
  internal links, external links, and asset paths touched by the change.
- Do not treat generated `_site/` files as source or include them in reviews.

## Commit & Pull Request Guidelines

Follow the Pro Git style: write an imperative subject of about 50 characters or
fewer. When a body adds useful context, separate it with a blank line and wrap
it at about 72 characters; explain why the change is needed and reference
issues when applicable. Pull requests should summarize visible changes, list
validation performed, include screenshots for UI changes, and call out
deployment or configuration impacts. Keep contributor-facing commands and
deployment details here and in `README.md` synchronized.
