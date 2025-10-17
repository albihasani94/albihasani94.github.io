# albinhasani.net

This repository hosts the source for [albinhasani.net](https://albinhasani.net), a personal site published with GitHub Pages.

## Deployment

The `master` branch is served by GitHub Pages. Pushes to `master` trigger a Pages build that runs the site with the
[`github-pages`](https://github.com/github/pages-gem) gem. The custom domain is configured via the [`CNAME`](CNAME) file and
DNS `ALIAS` records pointing `albinhasani.net` at GitHub's infrastructure.

### GitHub Pages tooling

The repository tracks the minimal configuration GitHub Pages needs:

- [`Gemfile`](Gemfile) depends on `github-pages ~> 232` and lists the supported plugins.
- `Gemfile.lock` is intentionally omitted so GitHub Pages can supply its managed dependency versions.
- `_config.yml` enables [`jekyll-feed`](https://github.com/jekyll/jekyll-feed), [`jekyll-seo-tag`](https://github.com/jekyll/jekyll-seo-tag), and [`jekyll-sitemap`](https://github.com/jekyll/jekyll-sitemap) — all whitelisted for GitHub Pages builds.

## Updating the site

Site content lives in the standard Jekyll locations:

- Blog posts in [`_posts/`](./_posts/)
- Drafts in [`_drafts/`](./_drafts/)
- Pages like the home and about sections in the repository root

To make changes, edit the relevant files, commit the updates, and push to `master`.
