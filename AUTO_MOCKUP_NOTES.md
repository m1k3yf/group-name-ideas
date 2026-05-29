# Auto-Mockup Feature — Implementation Notes

Build target: ship in the morning session.

## Goal
Right now the **Mockups** tab hardcodes DRAGHÌ and GOOD GUAI across four templates (marquee, EP, tour flyer, Spotify header). We want any keeper from the picks strip to render through those same templates, so all 5 finalists get the same visual gut-check.

## What to build

1. **Dropdown selector** at the top of the Mockups tab (`#panel-mockups`):
   - Populated dynamically from `getCurrentPicksRaw()` (the same source the picks strip uses).
   - Two slots: "Mockup A" (left) and "Mockup B" (right) — preserves the side-by-side comparison the current mockups already use.
   - Default Mockup A = current #1 pick, Mockup B = current #2 pick.
   - Persist selection in `localStorage` under `mockupSelection` so reloads keep the last view.

2. **Templatize the existing mockup HTML.**
   Find every hardcoded `DRAGHÌ`, `GOOD GUAI`, `MARVENTO`, `DUSK` inside `.mk-grid-3x2` and `.mk-section` blocks. Replace with `<span data-mockup-slot="a-name">` / `data-mockup-slot="b-name"` placeholders. On dropdown change, JS rewrites all `[data-mockup-slot="a-name"]` to the chosen name (uppercase).

3. **Edge case:** if a chosen name has > ~10 chars, scale font-size down so it still fits the marquee width. CSS: `font-size: clamp(28px, 8vw, 64px)` on `.mk-lbl` and `.mk-title`.

4. **"Lock in" button (stretch):** below the mockup, a button "These look right" that bumps the chosen name's `mockupCount` field in Firebase under `reviews/{nameId}/mockupCount`. Use this later for a "names we've actually visualized" badge.

## Files to touch
- `index.html` only.
- New CSS block under the existing `.mk-grid-3x2` styles.
- New JS function `renderMockups()` called on tab switch + on dropdown change.

## Where to plug in
- HTML insertion point: just under `<div class="today-header">Top picks · brand stress tests</div>` (currently around line 814).
- Tab switch handler: search for `data-tab="mockups"` activation — wire `renderMockups()` there.

## Don't break
- The existing DRAGHÌ / GOOD GUAI layouts. Add the dropdown above them; templatize them in place.
- Mobile responsive behavior of `.mk-grid-3x2`.

## Acceptance
- Open Mockups tab → see dropdowns prefilled with #1 and #2 from picks strip.
- Change Mockup A from GOOD GUAI to Marvento → marquee, EP, and tour flyer all instantly show MARVENTO.
- Reload → selections persist.
- No Firebase rule changes needed for the core feature (selection is local-only).
