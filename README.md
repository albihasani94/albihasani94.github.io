# albinhasani.net

This repository hosts the source for [albinhasani.net](https://albinhasani.net), a personal site published with GitHub Pages.

## Deployment

The `main` branch is served by GitHub Pages. Pushes to `main` trigger a Pages build that runs the site with the [`github-pages`](https://github.com/github/pages-gem) gem. The custom domain is configured via the [`CNAME`](CNAME) file and DNS `ALIAS` records pointing `albinhasani.net` at GitHub's infrastructure.

## Updating the site

Site content lives in the standard Jekyll locations:

- Blog posts in [`_posts/`](./_posts/)
- Drafts in [`_drafts/`](./_drafts/)
- Pages like the home and about sections in the repository root

To make changes, edit the relevant files, commit the updates, and push to `main`.
