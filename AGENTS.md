# Repository Guidelines

## Project Structure

- This is a Jekyll site built from `master` by
  `.github/workflows/pages.yml` and published through GitHub Pages at
  `albinhasani.net`. The Pages publishing source must remain **GitHub
  Actions**, and the `github-pages` environment must permit deployments only
  from `master`. Treat `_config.yml`, `CNAME`, `Gemfile`, `Gemfile.lock`,
  `.ruby-version`, and `.github/workflows/pages.yml` as deployment-sensitive
  files.
- Do not restore the `github-pages` gem unless intentionally returning to
  GitHub's managed Jekyll build.
- Root-level pages include `index.markdown`, `about.markdown`, and `404.html`.
  Blog posts live in `_posts/` and use `YYYY-MM-DD-title.md` filenames. Put
  unpublished work in `_drafts/`, creating that directory when needed.
- `_includes/social.html` overrides the theme's social links. Sass partials in
  `_sass/` are loaded through `assets/main.scss` using `@use`; images and icons
  belong under `assets/`.
- `_site/`, Jekyll caches, `.bundle/`, and `vendor/` are ignored local
  artifacts. Do not edit or commit them. `Gemfile.lock` is tracked; update it
  only through Bundler and review its diff.

## Build and Development Commands

- `bundle config set --local path vendor/bundle` configures the ignored local
  install path; `bundle install` installs the locked dependencies there.
- `bundle exec jekyll serve` starts a preview at <http://127.0.0.1:4000>.
- `bundle exec jekyll serve --drafts` includes content from `_drafts/`.
- `JEKYLL_ENV=production bundle exec jekyll build --trace` performs the
  production build used for final validation.
- Restart the Jekyll server after changing `_config.yml`; configuration changes
  are not reloaded automatically.

## Dependency Updates

- `.github/dependabot.yml` checks Bundler and GitHub Actions monthly. Minor and
  patch updates are grouped; major updates receive separate pull requests.
- Review updates before merging and run production validation. Dependabot does
  not update `.ruby-version`; handle Ruby updates manually and regenerate
  `Gemfile.lock`.

## External Services, Branding, and Tools

- When adding or changing a link, icon, badge, embed, or integration for an
  external service, verify the current canonical URL, account identifier, and
  branding against a first-party source at the time of the change.
- Use current official brand assets from the service owner's brand kit, press
  or media page, production site, or officially distributed package. Prefer an
  official SVG for icons when one exists. Do not silently substitute Simple
  Icons, Font Awesome, community icon sets, search-result downloads, traced or
  generated artwork, or a remembered version of the mark.
- Preserve official geometry, proportions, and usage guidance. Do not redraw,
  distort, or recolor a mark unless the owner's guidelines allow it. When a
  compact mark is taken from an official wordmark, keep its path geometry
  unchanged and record the first-party source in the asset or nearby code.
- For integrations and verification, prefer the service owner's official
  connector, API, SDK, CLI, documentation, and validation tools over browser
  automation or third-party wrappers. Use a third-party tool only when the
  official option cannot perform the required task and the user approves the
  fallback.
- If the required official asset, source, connector, or tool is unavailable,
  inaccessible, incompatible with the project, or cannot be verified, stop and
  prompt the user before approximating the result, installing or switching to
  an unofficial alternative, or omitting the branded or integrated element.

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
- Encode in-post raster images as WebP, resized to at most 1600 px wide
  (2× the ~740 px content column) with height following the aspect ratio, at
  quality 75–82. Use Google's official WebP tooling: [Squoosh](https://squoosh.app)
  or `cwebp` from libwebp (`brew install webp`). Give every image descriptive
  alt text, not a filename. Social-preview images are the exception: keep them
  1200×630 PNG or JPEG for crawler compatibility.
- For every new post being published, create a dedicated social-preview image
  for both X and LinkedIn by following the project-local
  `$create-social-preview` skill in
  `.agents/skills/create-social-preview/SKILL.md`. Default to the fixed
  `assets/images/post-social-editorial-template.svg` with an empty
  `post-visual` group. Use the exact post title and set the single label to the
  uppercase first category and first tag joined by ` · `. Do not add a
  description, metaphor, illustration, icon or photograph unless explicitly
  requested. Never change taxonomy to alter the label. Use
  `assets/images/post-social-template.svg` only when the description-based
  classic template is explicitly requested.
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
- Keep Sass rules in `_sass/` and load new partials from `assets/main.scss`
  using `@use`. Avoid duplicating styles already supplied by the Minima theme.

## Testing Guidelines

- Changes to `Gemfile`, `Gemfile.lock`, `.ruby-version`, `_config.yml`, or the
  Pages workflow require a production build.
- When editing the Pages workflow, preserve the separation
  between read-only build permissions and deployment permissions, and verify
  that pull requests build without deploying.
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
- Under the current locked dependency set, `jekyll-seo-tag` 2.9.0 copies
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
- After deployment, confirm that both workflow jobs succeeded and check the
  homepage, `/about/`, `/feed.xml`, `/sitemap.xml`, and `/assets/main.css`.

## Commit & Pull Request Guidelines

Follow the Pro Git style: write an imperative subject of about 50 characters or
fewer. When a body adds useful context, separate it with a blank line and wrap
it at about 72 characters; explain why the change is needed and reference
issues when applicable. Pull requests should summarize visible changes, list
validation performed, include screenshots for UI changes, and call out
deployment or configuration impacts. Keep contributor-facing commands and
deployment details here and in `README.md` synchronized.
