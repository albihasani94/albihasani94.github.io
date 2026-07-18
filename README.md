# albinhasani.net

This repository hosts the source for
[albinhasani.net](https://albinhasani.net), a personal site published with
GitHub Pages.

## Deployment

The `master` branch is served by GitHub Pages. Pushes to `master` trigger a
Pages build that runs the site with the
[`github-pages`](https://github.com/github/pages-gem) gem. The custom domain is
configured via the [`CNAME`](CNAME) file and DNS `ALIAS` records pointing
`albinhasani.net` at GitHub's infrastructure.

### GitHub Pages tooling

The repository tracks the minimal configuration GitHub Pages needs:

- [`Gemfile`](Gemfile) depends on `github-pages` and lists the site plugins.
- `Gemfile.lock` is intentionally omitted; the production Pages build uses
  GitHub's managed dependency set.
- `_config.yml` enables
  [`jekyll-feed`](https://github.com/jekyll/jekyll-feed),
  [`jekyll-seo-tag`](https://github.com/jekyll/jekyll-seo-tag), and
  [`jekyll-sitemap`](https://github.com/jekyll/jekyll-sitemap).

## Updating the site

Site content lives in the standard Jekyll locations:

- Blog posts in [`_posts/`](./_posts/)
- Drafts in `_drafts/` (create the directory when needed)
- Pages like the home and about sections in the repository root

To make changes, edit the relevant files, commit the updates, and push to
`master`.

## Local deployment

First install:

`bundle install --path vendor/bundle`

Then:

`bundle exec jekyll serve`

or with drafts:

`bundle exec jekyll serve --drafts`

Restart the server after changing `_config.yml`, because Jekyll does not reload
configuration changes automatically.

Before pushing, run a production build:

`JEKYLL_ENV=production bundle exec jekyll build`
