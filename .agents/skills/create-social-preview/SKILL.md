---
name: create-social-preview
description: Create and validate branded 1200x630 social-preview images for new posts on albinhasani.net. Use when publishing a post, adding or replacing post front-matter image metadata, designing a LinkedIn or X link card, or working with the post social SVG templates in assets/images/.
---

# Create Social Preview

Create a recognizable editorial card with deterministic typography and one
post-specific visual idea. Use the same raster for LinkedIn Open Graph and X's
`summary_large_image` card.

## Choose the template

- Default to `assets/images/post-social-editorial-template.svg` for new posts.
- The editorial template intentionally contains an empty `post-visual` group.
  Fill it only after completing the content analysis below.
- Use `assets/images/post-social-template.svg` only when the user asks for the
  conservative text-first design or the post has no honest visual metaphor.
- Treat the selected template as the source of truth. Work on a copy; do not
  overwrite either template while producing a post image.
- Use `assets/images/fable-5-handover-social-editorial.svg` only as an example
  of the visual language. Its hands, code baton and agent belong exclusively to
  that post; never reuse or lightly reskin its metaphor for another post.

## Preserve the brand

Keep these invariants unchanged:

- 1200x630 canvas and generous crop-safe margins.
- Dark navy background, subtle square grid, amber rail, off-white title and
  muted periwinkle secondary elements.
- `ALBINHASANI.NET` and `Java · JVM · Cloud · AI` footer.
- Bold system-sans typography and restrained geometric line-art character.

Allow variation only in:

- `{{POST_TITLE}}`, matching the published post title exactly.
- `{{POST_LABEL}}`, a one-to-three-word uppercase editorial label.
- The contents of `<g id="post-visual">`, authored from an empty group as one
  illustration that communicates the post's central idea.

Do not add a paragraph description to the editorial card. The platforms render
the post description alongside the image already.

## Analyze before drawing

1. Read the full post, not only its title, description or tags.
2. Write down its thesis and central action, transformation or tension.
3. Generate two or three concrete visual metaphors from that analysis.
4. Reject any metaphor that could illustrate almost any software post, repeats
   a previous post's subject, or comes from the template/example rather than
   the content.
5. Choose the clearest remaining metaphor. If none is honest and specific, use
   the conservative text-first template instead of forcing an illustration.

Do not draw hands, agents, batons, relays or transfers unless the post itself is
meaningfully about a handoff, transfer of responsibility or related idea.

## Design the post visual

1. Start with the editorial template's empty `post-visual` group.
2. Express the chosen metaphor as one restrained geometric line illustration.
   Prefer
   diagrams, objects, motion, transformations, connections or code-adjacent
   metaphors over generic technology icons.
3. Reuse the template's line weights, amber glow and periwinkle strokes. Use at
   most one small coral accent when it adds meaning.
4. Keep the illustration subordinate to the title and legible at thumbnail
   size. Avoid mascots, stock icon collections, glossy 3D, photorealism and
   decorative complexity.

Author all final text and simple line art directly in SVG. If an image model is
useful for ideation, use its result only as a reference or isolated motif;
rebuild the final typography and geometric illustration in SVG so spelling,
layout and brand details remain deterministic.

## Fit and export

1. Keep essential content within `x=64..1136` and `y=48..582`.
2. Fit the exact title in at most two SVG `<tspan>` lines. Reduce its font size
   before moving other fixed elements; never shorten or silently rewrite it.
3. Keep the editorial label short enough for its chip. Shorten the label rather
   than shrinking it below comfortable thumbnail readability.
4. Render the SVG in a browser and export a 1200x630 PNG to
   `assets/images/<post-slug>-social.png`.
5. Inspect the full-size export and a roughly 360x189 thumbnail. Check spelling,
   contrast, clipping, visual hierarchy and harmless edge cropping.
6. Commit only the raster export unless the user requests the post-specific
   editable SVG.

## Wire the post

Set structured front matter:

```yaml
image:
  path: /assets/images/<post-slug>-social.png
  width: 1200
  height: 630
  alt: "<concise description of the card's meaningful visual content>"
```

Run the production Jekyll build. Inspect the rendered post for absolute
`og:image` and `twitter:image` URLs, `og:image:width`, `og:image:height`,
`og:image:alt`, `twitter:image:alt` and
`twitter:card=summary_large_image`. Confirm the raster is a publicly suitable
PNG or JPEG and stays well below the platforms' file-size limit.
