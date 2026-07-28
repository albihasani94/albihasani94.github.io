---
layout: post
title: "The Footnote Was Already There"
date: 2026-07-28 12:00:00 +0200
description: "How a small edit marker became custom HTML, ARIA and CSS before four lines of native Kramdown replaced it all."
categories: [notes, jekyll]
tags: [jekyll, markdown, ai]
excerpt_separator: <!--more-->
---

I wanted to add an Edits section to the bottom of a post and put a small number next to every passage touched by an edit. It sounded like a tiny change.

<!--more-->

It became a useful example of how quickly a technically correct solution can grow before someone asks the more important question: does the system already do this?

## The first edit note

The first version was just a heading and a numbered item:

```markdown
## Edits

1. **July 28, 2026:** Clarified that I still review every line of Java code, but no longer necessarily every line in other domains such as Ruby and PHP.
```

That kept the history at the bottom, but it did not connect the note to the two passages it described. The next version added a superscript link to each passage:

```html
<sup>
  <a href="#edit-1" aria-label="See edit 1">1</a>
</sup>
```

The destination began as an empty anchor inside the edit:

```html
<span id="edit-1"></span>
```

This worked. Clicking the number moved the reader to the edit. It was also the point where a Markdown post had started collecting handwritten HTML.

## Making the custom version correct

I then asked whether this way of referencing followed web standards. The simple implementation was valid HTML, but it could communicate more meaning to assistive technology. The improved references received unique IDs and the W3C Digital Publishing ARIA role for note references:

```html
<sup class="post-edit-reference">
  <a
    id="edit-1-ref-a"
    href="#edit-1"
    role="doc-noteref"
    aria-label="Edit note 1"
  >1</a>
</sup>
```

The second occurrence used `edit-1-ref-b`. Both pointed to one endnote item.

The bottom of the post became a semantic endnotes section with a machine-readable date and explicit return links:

```html
<section
  class="post-edits"
  role="doc-endnotes"
  aria-labelledby="edits"
>
  <h2 id="edits">Edits</h2>
  <ol>
    <li id="edit-1">
      <p>
        <strong>
          <time datetime="2026-07-28">July 28, 2026</time>
        </strong>
        While I keep reviewing every line of Java code myself,
        I've had to let go in other languages.
      </p>
      <p>
        I still do rigorous iterations with my agents...
      </p>
      <p class="post-edit-backlinks">
        Back to the
        <a href="#edit-1-ref-a" role="doc-backlink">
          first reference
        </a>
        or
        <a href="#edit-1-ref-b" role="doc-backlink">
          second reference
        </a>.
      </p>
    </li>
  </ol>
</section>
```

This was no longer a casual anchor. It had forward navigation, return navigation, native list structure, explicit note semantics and a date that machines could understand.

It was also a lot of HTML for a footnote.

## The highlight that would not leave

To help the reader see where the jump landed, the edit received a subtle target highlight:

```scss
.post-edits li:target {
  background-color: rgba(255, 235, 59, 0.16);
}
```

That highlight persisted. This was not a browser bug. After following `#edit-1`, the URL still contained that fragment, so the list item continued to match `:target`.

The next implementation made the highlight temporary:

```scss
.post-edits li:target {
  animation: post-edit-target-highlight 1.5s ease-out;
}

@keyframes post-edit-target-highlight {
  from {
    background-color: rgba(255, 235, 59, 0.16);
  }

  to {
    background-color: transparent;
  }
}

@media (prefers-reduced-motion: reduce) {
  .post-edits li:target {
    animation: none;
  }
}
```

This was accessible and behaved better. It also meant that a numbered note now required custom HTML, ARIA roles, fragment naming, return-link wording, Sass, an animation and a reduced-motion rule.

Every individual decision was defensible. Together they were a warning.

## The prompt that changed the direction

The turning point was not another implementation request. It was this:

> I am looking if there is a jekyll and markdown native solution. Something such as: https://github.blog/changelog/2021-09-30-footnotes-now-supported-in-markdown-fields/

That was the right question.

GitHub had added the familiar `[^1]` footnote syntax to its Markdown fields in 2021. More importantly for this site, [Jekyll uses Kramdown as its default Markdown renderer](https://jekyllrb.com/docs/configuration/markdown/), and [Kramdown supports native footnotes](https://kramdown.gettalong.org/syntax.html#footnotes).[^native-footnotes]

The manual implementation could be replaced with this:

```markdown
I still review every line of Java code myself.[^edit-1]

This is no longer entirely true in other domains.[^edit-1]

## Edits

[^edit-1]: **July 28, 2026.** While I keep reviewing every
    line of Java code myself, I've had to let go in other
    languages such as Ruby and PHP.

    I still do rigorous iterations with my agents...
```

The same footnote name can be referenced more than once. Kramdown numbers it once and generates a unique reference ID for every occurrence.

Its rendered HTML includes the semantics we had built manually:

```html
<sup id="fnref:edit-1">
  <a
    href="#fn:edit-1"
    class="footnote"
    rel="footnote"
    role="doc-noteref"
  >1</a>
</sup>

<sup id="fnref:edit-1:1">
  <a
    href="#fn:edit-1"
    class="footnote"
    rel="footnote"
    role="doc-noteref"
  >1</a>
</sup>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li id="fn:edit-1">
      ...
      <a
        href="#fnref:edit-1"
        class="reversefootnote"
        role="doc-backlink"
      >↩</a>
      <a
        href="#fnref:edit-1:1"
        class="reversefootnote"
        role="doc-backlink"
      >↩<sup>2</sup></a>
    </li>
  </ol>
</div>
```

Kramdown already handled the numbering, repeated references, unique fragment IDs, endnotes list and backlinks. The custom HTML and the entire Sass partial could be deleted.

## The multiline footnote trap

Native does not mean impossible to misuse.

I later broke the second paragraph of the footnote with this:

```markdown
[^edit-1]: The first paragraph.
  The second paragraph.
```

Two spaces were not enough to keep that line inside the definition. Kramdown ended the footnote after the first line and rendered the next text as an ordinary paragraph above the endnotes.

A separate paragraph inside the footnote needs a blank line and four spaces of indentation:

```markdown
[^edit-1]: The first paragraph.

    The second paragraph remains inside the footnote.
```

This draft uses that exact multiline form in its own footnote, including a repeated reference.[^native-footnotes]

## Native first

The lesson is not that custom HTML is bad. The standards-focused version was useful because it showed what a complete endnote implementation needs. It also gave us a concrete output against which to test Kramdown.

The mistake was changing layers too early.

Before writing custom code, the better sequence is:

1. Identify the platform and renderer already in use.
2. Check their official documentation for the capability.
3. Test the native syntax against the real edge cases.
4. Inspect the generated output, not only the source syntax.
5. Add custom code only for a requirement the native feature cannot meet.

We added that principle to the repository instructions, and not only for Markdown. Before adding code or a dependency, agents should check the platform, language, framework, theme, existing dependencies and relevant standards first.

Sometimes the best implementation is the one that deletes itself.

[^native-footnotes]: Jekyll 4.4 uses Kramdown's GitHub Flavored Markdown processor by default. Kramdown treats repeated markers with the same name as references to one definition and automatically places referenced definitions at the end of the document.

    Its multiline definitions can contain block-level content, but continuation paragraphs must follow Kramdown's four-space or one-tab indentation rule.
