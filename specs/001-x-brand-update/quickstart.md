# Quickstart: Update Social Branding to X

1. **Install dependencies** (first run only):
   ```bash
   bundle install --path vendor/bundle
   ```

2. **Fetch the official X logo**:
   - Download the authorized SVG from the X brand resources site.
   - Optimize with `svgo --multipass` (or equivalent) to keep the file ≤ 10 KB.
   - Save as `assets/custom_icons/x.svg`.

3. **Update site templates**:
   - Edit `_includes/social.html` to swap the Twitter entry for X using the new SVG and label.
   - Update `_config.yml` social metadata (`twitter_username` → `x_username` if needed) and any other global references.

4. **Preview locally**:
   ```bash
   bundle exec jekyll serve --drafts
   ```
   - Navigate to `http://127.0.0.1:4000` and confirm the X icon renders correctly, opens `https://x.com/albihasani94` in a new tab, and screen readers announce it as “X”.

5. **Verify build & accessibility**:
   ```bash
   bundle exec jekyll build
   ```
   - Ensure zero warnings.
   - Run Lighthouse (Chrome DevTools) and confirm accessibility score remains ≥ 90.

6. **Analytics smoke test**:
   - Trigger a click using the local preview and confirm analytics tools classify the referrer as X after deployment (proxy via staging if available).

7. **Document changes**:
   - Capture before/after screenshots of the social area.
   - Note the official asset source URL in PR description for audit.
