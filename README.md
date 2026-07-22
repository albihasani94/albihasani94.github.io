# albinhasani.net

This repository hosts the source for
[albinhasani.net](https://albinhasani.net), a personal site published with
GitHub Pages.

## Deployment

The `master` branch is served by GitHub Pages. The
[`pages.yml`](.github/workflows/pages.yml) workflow builds the site with the
repository's locked Jekyll dependencies and deploys the generated artifact.
Pull requests run the same production build without deploying. The custom
domain is configured via the [`CNAME`](CNAME) file and DNS `ALIAS` records
pointing `albinhasani.net` at GitHub's infrastructure.

In the repository's Pages settings, **Build and deployment > Source** must be
set to **GitHub Actions**.

### GitHub Pages tooling

The repository tracks its complete build environment:

- [`.ruby-version`](.ruby-version) selects Ruby 3.4.10 locally and in Actions.
- [`Gemfile`](Gemfile) pins the supported Jekyll, theme, and plugin series.
- [`Gemfile.lock`](Gemfile.lock) makes local and production builds reproducible.
- `_config.yml` enables
  [`jekyll-feed`](https://github.com/jekyll/jekyll-feed),
  [`jekyll-seo-tag`](https://github.com/jekyll/jekyll-seo-tag), and
  [`jekyll-sitemap`](https://github.com/jekyll/jekyll-sitemap).

## Local development

Install the Ruby version in [`.ruby-version`](.ruby-version) with a Ruby
version manager, then install the bundle into the ignored `vendor/` directory:

```sh
bundle config set --local path vendor/bundle
bundle install
```

Start a local preview at <http://127.0.0.1:4000>:

```sh
bundle exec jekyll serve
```

Run the production build before pushing:

```sh
JEKYLL_ENV=production bundle exec jekyll build
```

When intentionally updating dependencies, run `bundle update`, review the
`Gemfile.lock` diff, and repeat the production validation.

## Updating the site

Site content lives in the standard Jekyll locations:

- Blog posts in [`_posts/`](./_posts/)
- Drafts in `_drafts/` (create the directory when needed)
- Pages like the home and about sections in the repository root

To make changes, edit the relevant files, commit the updates, and push to
`master`.
