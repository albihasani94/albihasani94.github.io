---
name: create-social-preview
description: Create and validate deterministic, branded 1200x630 social-preview images for posts on albinhasani.net. Use when publishing a post, adding or replacing post image metadata, creating a LinkedIn or X link card, or working with the social SVG templates in assets/images/.
---

# Create Social Preview

Create one raster for LinkedIn Open Graph and X `summary_large_image`.

## Standard card

Use `assets/images/post-social-editorial-template.svg`. Work on a copy and
preserve its 1200x630 frame, background, grid, amber rail, circles and footer.

Make only these substitutions:

1. Set the title to the exact front-matter `title`. Fit it in at most two lines
   by reducing font size; never rewrite or shorten it.
2. Set one label below the title to:
   `UPPERCASE(categories[0]) · UPPERCASE(tags[0])`.
3. If either list is absent or empty, use only the available first value. If
   both are absent, omit the label.
4. Leave `<g id="post-visual">` empty.

Do not add a description, metaphor, illustration, icon, photograph or other
post-specific decoration. Do not add, remove or reorder categories or tags to
change the card.

## Export and verify

1. Keep essential content within `x=64..1136` and `y=48..582`.
2. Render the completed SVG and export a 1200x630 PNG to
   `assets/images/<post-slug>-social.png`.
3. Inspect the full-size image and a roughly 360x189 thumbnail for exact text,
   clipping, contrast and safe margins.
4. Keep only the raster export unless editable source was requested.
5. Set structured front matter:

```yaml
image:
  path: /assets/images/<post-slug>-social.png
  width: 1200
  height: 630
  alt: "Text-only social preview for <exact title>, labeled <category> and <tag>."
```

6. Run the production Jekyll build.
7. Verify absolute `og:image` and `twitter:image` URLs, image dimensions and alt
   text, plus `twitter:card=summary_large_image`.

## Explicit variants only

- Add a post-specific visual only when the user explicitly asks for an
  illustration or metaphor. Then read the full post before filling
  `post-visual`; never reuse another post's visual.
- Use `assets/images/post-social-template.svg` only when the user explicitly
  asks for the description-based classic template.
