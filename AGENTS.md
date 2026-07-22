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
- When editing `about.markdown`, set `seo.date_modified` in its front matter
  to the current date. GitHub Pages cannot derive it automatically, and a
  stale value is worse than none.
- Prefer Markdown for prose and fenced code blocks with a language identifier.
  Put post images in `assets/images/` and use descriptive lowercase filenames.
- For every new post being published, suggest a dedicated social-preview image
  for both X and LinkedIn. Use `assets/images/post-social-template.svg` as the
  complete source of truth and replace only its `{{POST_TITLE}}` and
  `{{POST_DESCRIPTION}}` values; do not alter the fixed design or footer.
- Render the completed template in a browser and export it to a 1200×630 PNG
  or JPEG in `assets/images/`. Check it at thumbnail size and commit only the
  raster export unless editable source was requested. Set `image.path`,
  `image.width`, `image.height`, and `image.alt` in the post front matter.
- Use two spaces for nested YAML and SCSS. For HTML and Liquid, match the
  surrounding file and keep whitespace-control markers such as `{%-` intact.
- Keep site-wide identity, plugin, and social-handle settings in `_config.yml`.
  Update `_includes/social.html` only when the rendered social markup changes.
- `_includes/identity-json-ld.html` owns the canonical `Person` and
  `ProfilePage` graph. Keep `site.person.id` stable, keep
  `ProfilePage.mainEntity` pointing to that identifier, and reuse the identifier
  instead of minting additional Person IDs. Use absolute canonical URLs and
  reserve `sameAs` for authoritative profiles belonging to Albin.
- Keep Sass rules in `_sass/` and import new partials from `assets/main.scss`.
  Avoid duplicating styles already supplied by the Minima theme.

## Testing Guidelines

- Run the production build before pushing. Resolve Liquid, YAML, plugin, and
  missing-include errors and review all warnings.
- Preview affected pages for visible changes. Check navigation, social links,
  `/feed.xml`, `/sitemap.xml`, image loading, and relevant SEO metadata.
- When structured data changes, run the production build and validate the
  rendered HTML for the homepage, About page, and a representative post using
  the code-input modes of both the Schema.org Validator and Google's Rich
  Results Test. After deployment, use their URL modes when public
  accessibility, crawling, or production rendering also needs verification.
  Schema.org checks general vocabulary usage; Google's tool reports only markup
  used by supported Google Search features, so their results are not expected
  to match.
- Under the current GitHub Pages dependency set, `jekyll-seo-tag` 2.8.0 copies
  `image.alt` into its JSON-LD `ImageObject`, although `alt` is not a Schema.org
  property. Preserve `image.alt` because it generates valid Open Graph and X
  image-alt metadata. Treat the repeated Schema.org warning as a known plugin
  limitation and re-evaluate it after dependency upgrades.
- Minima's post layout emits `BlogPosting` Microdata while `jekyll-seo-tag`
  emits a separate JSON-LD `BlogPosting`. Two detected post items are therefore
  expected. The JSON-LD author includes the profile URL; Minima's Microdata
  author includes only the name. Treat a missing optional `author.url` on the
  Microdata item as non-blocking unless the post layout is intentionally
  overridden.
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
