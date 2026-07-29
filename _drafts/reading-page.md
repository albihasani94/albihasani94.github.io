---
layout: post
title: "A Reading Page, One Pixel at a Time"
description: "How I built, measured, revised, deployed, and debugged the Reading section on albinhasani.net with Codex running gpt-5.6-sol."
categories: [engineering, ai]
tags: [jekyll, goodreads, codex, performance]
excerpt_separator: <!--more-->
---

This started with a small question: would it be nice to put “What am I
reading?” in the header of this blog, or add some kind of Goodreads
integration?

The result is a dedicated [Reading]({{ '/reading/' | relative_url }}) page. It
looks simple. Getting there involved RSS parsing, Jekyll data, GitHub Actions,
responsive images, performance traces, several naming changes, a reverted
optimization, and one stale Cloudflare stylesheet.

I built it with Codex running `gpt-5.6-sol`, but the useful part was not simply
having a model generate code. It was the loop around the code: implement,
inspect, measure, question the result, reverse it when it became worse, and
debug production as its own environment.

<!--more-->

## From a header status to a page

The first idea was a compact status in the header. I liked the personal signal,
but not the full phrase as navigation. “What am I reading?” is a question;
“Reading” is a destination.

I also considered whether Hugo would make the Goodreads side substantially
easier than Jekyll. Hugo has nicer built-in ergonomics for fetching remote data,
but the practical architecture is broadly the same for this use case. Either
the data has to be ingested during a build, or the browser has to fetch it at
runtime. The browser-side route adds availability and cross-origin concerns to
an otherwise static page. Migrating an existing Jekyll site for a slightly
nicer remote-data function would have been solving the wrong problem.

A dedicated page became the cleaner outcome. It gave the current books enough
room for covers and metadata, while leaving space for finished books grouped by
year. It also kept the header label short.

During exploration I shared a keyed Goodreads user-updates RSS feed. It mixed
different kinds of activity: progress updates, shelf changes, ratings and
finished books. More importantly, the URL contained a private key. It was
useful for understanding the available data, but it was not the right source to
commit or expose.

The final implementation uses Goodreads’ public official shelf RSS feeds:
`currently-reading` for the current list and `read` for the history. No private
feed key is stored in the repository or emitted into the page.

## The build-time architecture

The implementation is deliberately boring:

```text
Goodreads public shelf RSS
        ↓
scripts/update_goodreads.rb
        ↓
_data/goodreads.yml
        ↓
Jekyll + Liquid
        ↓
/reading/
```

The Ruby importer uses `Net::HTTP` with ten-second open and read timeouts,
limited redirect handling, an explicit RSS/XML `Accept` header, and a
site-specific user agent. It parses both documents with REXML.

For currently reading books, it stores the fields the page uses:

- `title`
- `author`
- `url`
- `cover`
- `cover_large`
- `pages`, when Goodreads supplies a non-empty value

For read books, it stores:

- `title`
- `author`
- `url`
- `cover`
- `read_at`, when a completion date exists

Goodreads book links inside the feed description can contain query parameters.
The importer extracts the canonical-looking `/book/show/...` portion and drops
the query string. If that link cannot be extracted, it constructs a book URL
from `book_id`.

The read dates are normalized to `YYYY-MM-DD`. Dated books are grouped into
years, with newer years first and books inside each year sorted from newest to
oldest. Books without a completion date are preserved in a separate
`undated_read` list instead of having a year guessed for them.

The generated YAML also records the profile URL, both public source URLs and
the `lastBuildDate` value from each feed. Jekyll loads that file through
`site.data.goodreads`, and `reading.markdown` renders normal HTML with Liquid.
There is no client-side JavaScript and no runtime call from a reader’s browser
to Goodreads for the book data.

The snapshot is also a fallback. In its default tolerant mode, a network, HTTP,
XML, date or other parsing error leaves an existing `_data/goodreads.yml`
unchanged and exits successfully. That keeps optional local refreshes from
blocking unrelated work. The scheduled workflow sets `GOODREADS_STRICT=1`, so
the same failure stops the refresh and remains visible in Actions.

## The page kept changing

The first version showed only current books. Adding the public `read` shelf
made it possible to build the history, but the first history design used
collapsible years: the current year was open and previous years were closed.
After looking at it in the browser, I preferred the history to be a document,
not a set of controls. The years are now permanently open.

The wording went through more revisions than the architecture. The page moved
through “Readings” and “My Reads” before returning to “Reading.” The final
navigation and page title are both **Reading**, with two clear section headings:
**Currently Reading** and **Read by Year**.

Historical covers were another reversible decision. They are controlled by:

```yaml
show_reading_history_covers: true
```

They are enabled by default, but changing the setting to `false` restores a
text-only history without removing the imported data. Both variants were built
locally during development.

The bottom of the page went through its own small argument. It briefly linked
to the two RSS feeds, then became styled metadata, then lost the styling. The
final version is the plain profile link:

> Source: Goodreads

The About page no longer sends readers straight out to Goodreads. It links
internally to `/reading/`, making the Reading page the site’s own presentation
of that data.

None of these are difficult changes. They are still product decisions. The
fact that a model can change a label in seconds does not decide whether the
label belongs there.

## Refreshing it on the third and eighteenth of every month

The first implementation ran the importer before every Jekyll build. That made
push and pull-request validation depend on Goodreads, and a scheduled update
existed only inside its temporary Actions checkout. A later build could
therefore redeploy the older committed snapshot.

The final implementation separates the jobs. The Pages workflow always builds
from committed data. A dedicated refresh workflow can be dispatched manually
and has this twice-monthly schedule:

```yaml
schedule:
  - cron: "17 5 3,18 * *"
```

That means 05:17 UTC on the third and eighteenth days of every month. The
choice of minute 17 is modestly intentional: it avoids scheduling at the exact
start of the hour, when many jobs tend to be submitted. It is not a guarantee
of punctual execution.

On a refresh run, Actions checks out `master`, tests the parser, fetches both
feeds in strict mode, and checks whether the snapshot changed. If it did, the
workflow performs a production build, commits only `_data/goodreads.yml`, and
pushes it to `master`.

A commit made with the workflow's `GITHUB_TOKEN` does not trigger another push
workflow, so the refresh explicitly dispatches the Pages workflow after the
commit. If the snapshot did not change, there is nothing to commit or deploy.
Normal pushes and pull requests never contact Goodreads.

## The cover-image rabbit hole

The current code has two distinct image strategies.

Currently reading covers render in an `80 × 120` CSS-pixel box. Their `src`
points to Goodreads’ medium image, commonly about 98 pixels wide, and their
`srcset` offers the medium URL as the `1x` candidate and Goodreads’
`book_large_image_url` as the `2x` candidate. The larger examples are generally
around 315–318 pixels wide, although Goodreads sometimes supplies a
height-oriented variant.

The browser can use display density, zoom, cache state and its own selection
heuristics when choosing between candidates. The descriptors express the
intended density; they do not promise that every browser will fetch one exact
file in every situation. At standard density the medium image is the economical
choice. On a high-density display the large image is sharper, but it is also
more data than the roughly 160 physical pixels an 80 CSS-pixel cover needs.
Goodreads does not provide a clean in-between candidate through the fields used
here.

The displayed width itself went through 74, 76, 78, 79 and finally 80 pixels.
There was no material compatibility or performance difference between 79 and
80. The current value won because `80 × 120` is an exact 2:3 box and is easier
to reason about than a fractional height.

History covers render at `48 × 72` CSS pixels. They use only the medium
Goodreads source, commonly around 98 pixels wide, and retain
`loading="lazy"`. Currently reading covers are lazy-loaded too. The final
markup leaves image decoding at the browser default.

I did try to make the history more responsive. The experiment stored
Goodreads’ small cover URL as well as the medium one and used them as `1x` and
`2x` density candidates. The feed was not uniform enough to describe them
honestly as fixed `50w` and `98w` widths: many small images were height-based
and landed around 45–50 pixels wide. I also added `decoding="async"` to every
Reading cover.

Chrome probes confirmed that a standard-density display could select the small
source and a high-density display could select the medium source. The browser
could also reuse an already cached medium image instead of downloading a new
small one. Technically, the experiment worked.

Visually, it did not. The history covers looked too compressed. I removed the
small-source field, both history `srcset` blocks, and every explicit
`decoding="async"` attribute. I briefly forced a large source for the current
covers as a comparison, then restored the medium/large responsive behavior
there. The final code is the result of that reversal, not the most elaborate
version we managed to implement.

## What the measurements actually said

These were local lab observations, not field data from real visitors.

Before the history responsive-source experiment, the rendered Reading HTML was
roughly 66.8 KB raw and 9.1 KB after gzip. Adding the repeated small and medium
URLs grew the raw HTML to about 83.1 KB. Because those URLs shared long repeated
prefixes, the projected gzip increase was only about 0.77 KB.

For the first 18 eligible history covers, the smaller sources were estimated to
save about 44.1 KB on a fresh `1x` load. On paper, the page transferred fewer
bytes overall.

Local Chrome traces around the later iterations showed roughly 228–455 ms LCP
and CLS of 0. The LCP element was text, not a cover. There was no Core Web
Vitals emergency to solve.

The byte calculation argued for keeping the experiment. My eyes argued
otherwise. Saving several tens of kilobytes on one display class was not worth
making the book covers visibly worse, especially on a page whose purpose is to
present books. Reverting was the optimization.

The same audit found an unrelated site-wide issue with a much clearer answer.
The official LinkedIn PNG was originally `840 × 779` pixels while rendering at
about `16 × 15`. I manually resized a local version to `48 × 45`, preserved its
geometry and kept it as PNG rather than converting an official mark to another
format for a negligible saving. That `48 × 45` version was verified during the
iteration; the repository history shows the eventually committed and current
asset is a `96 × 89` PNG. Either is dramatically more appropriate than the
original source, and the checked-in file still provides ample density at its
display size.

## When production disagreed with local

The first production deployment looked broken even though the local build had
passed. The new Reading HTML was present, including the books, but the cards and
history had lost their layout.

The problem was not Jekyll. Production was serving two generations of the
site:

- fresh `/reading/` HTML
- stale, unversioned `/assets/main.css` from Cloudflare’s cache

The cached stylesheet did not contain any `.reading-*` rules. Requesting the
same CSS with a cache-busting query returned the current generated stylesheet,
which proved that the GitHub Pages artifact was healthy.

The fix was a targeted purge of that one stylesheet URL. After the purge,
Cloudflare fetched the current asset and the Reading layout appeared as
expected. There was no need to roll back the deployment or purge the whole
zone.

Asset fingerprinting or build-versioned stylesheet URLs remain possible future
hardening. The important lesson was to diagnose production separately. A green
build and a correct local page do not prove that every cache between the origin
and a reader is serving the same generation.

## What I would harden next

The importer now rejects missing required fields and an empty historical shelf,
writes through a temporary file and atomic rename, and has fixture tests for
valid, empty, malformed and failed responses. Strict scheduled runs no longer
hide stale-data failures.

Two limitations remain. A syntactically valid but non-empty partial feed can
still look authoritative, and the importer does not explicitly paginate. The
current snapshot fits in one response, but the script assumes that one feed
response remains complete as the shelf grows. Fixtures for partial feeds,
pagination and more upstream field variations would be the next hardening
work.

## The useful part of working with an agent

The page did not emerge from one perfect prompt. The actual pattern was:

1. Implement a small version.
2. Run Jekyll locally.
3. Inspect the real page in Chrome.
4. Measure document and image behavior.
5. Question tiny choices, including a single CSS pixel.
6. Try the more optimized version.
7. Reverse it when visual quality suffered.
8. Run the production build.
9. Deploy.
10. Diagnose production independently.

Codex was useful across that entire loop: reading the repository, writing Ruby
and Liquid, restarting the preview, inspecting computed dimensions, tracing
performance, checking the deployment, and isolating the Cloudflare cache.

I still made the calls. Years stayed open because I preferred them open. The
page returned to “Reading” because that was the clearest name. The technically
successful responsive-history experiment was removed because it looked worse.
A one-pixel discussion ended at 80 because the geometry was cleaner.

That is the collaboration pattern I want from AI-assisted engineering. The
result is not just generated code. It is a human-in-the-loop process where the
agent makes experiments cheap, measurement keeps us honest, and judgment still
decides what ships.
