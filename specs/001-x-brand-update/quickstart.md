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
   - Edit `_includes/social.html` to swap the legacy Twitter entry for X using the new SVG and label.
   - Update `_config.yml` social metadata to surface `x_username` (and remove any remaining references to the legacy key).

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
   - After deploying to staging/production, click the X link and allow analytics to record the visit.
   - In your analytics tool (e.g., Plausible, GA4), filter the referral report for domains `x.com` or `t.co`.
   - Confirm the session attributes to X (not `twitter.com`) and capture a screenshot for the release notes.

7. **Document changes**:
   - Capture before/after screenshots of the social area.
   - Note the official asset source URL in PR description for audit.
