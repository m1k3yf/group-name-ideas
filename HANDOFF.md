# Group Name Ideas — Project Handoff

Pick up here on the new computer. The GitHub repo is the source of truth — when in doubt, pull latest from `main`.

## What this is
A single-page web app for collecting, reviewing, and tournament-ranking group/band name ideas (an Italian-American "troublemaker" branding project). Real-time synced across devices via Firebase.

## Where everything lives
- **Code (source of truth):** GitHub — `github.com/m1k3yf/group-name-ideas`, branch `main`
- **Production site:** https://group-name-ideas.vercel.app
- **Hosting:** Vercel — auto-deploys on every push to `main` (~1 min)
- **Backend:** Firebase Realtime Database (project `group-name-ideas`), Google sign-in
- **The whole app is ONE file:** `index.html` (HTML + CSS + JS, Firebase loaded via CDN). Plus `database.rules.json` (security rules) and a couple of `.md` notes.

## Getting set up on the new computer
1. Install git and a code editor. (Node is optional — only used to syntax-check `index.html`.)
2. Clone fresh — **do not copy the old machine's local folder** (its local git hit a stale lock / index corruption):
   ```
   git clone https://github.com/m1k3yf/group-name-ideas.git
   ```
   Sign in with your own GitHub account when prompted.
3. Edit `index.html` directly. Easiest way to test a change is to push and check the live site (Firebase auth is tied to the deployed domain).
4. Ship a change:
   ```
   git add index.html
   git commit -m "..."
   git push
   ```
   Vercel redeploys automatically.

## How the data model works
- `BATCHES` array in `index.html` = the baked-in name lists (Batch 1 … **Batch 67**). Each entry is `{id, date, label, names:[{id, name, vibe}]}`.
- The **Custom** batch (`id:"custom"`) must stay **LAST** in the array — the app appends manually-added names there.
- Live state (review status, pick order, notes, custom names, tournaments) lives in the **Firebase DB**, keyed by each name's `id`. Initial values are seeded from `BAKED_STATE` / `NOTES_DEFAULTS` in `index.html`.
- **To add a new batch:** insert a `{id:"bNN", date:"…", label:"…", names:[…]}` object right **before** the Custom batch. Use unique lowercase `id`s — a collision with an existing id silently merges their review status, so **grep the file for each name first**.

## Direction Notes (the naming "spec")
- `NOTES_DEFAULTS` in `index.html` holds the five Direction Notes fields: `clicking` / `avoid` / `explore` / `refs` / `general`. This is the guidance used to generate names.
- **Gotcha:** the live app reads notes from the **DB**, which **override** `NOTES_DEFAULTS`. Editing the code defaults won't change what the app shows if notes are already saved. To change what's live, edit in the app's Direction Notes panel (it syncs to everyone), or clear the saved `notes` node.

## What was done in the last session
- **Security rules:** rewrote `database.rules.json` — root read is OFF; every path locked to `mikefiume13@gmail.com` and `anthonyfiume09@gmail.com` (verified email required). Refactored the app from one root listener to per-path listeners so it still works without root read.
- **Firebase Auth (Console):** added the Vercel domain to Authorized domains and enabled the Google sign-in provider.
- **Showdown upgrade:** added a "Pool" toggle (Keepers vs App-made names) and "Kill the losers" controls (per-name reject + reject bottom half) on the results screen.
- **Direction Notes:** added an artist-name market cross-check (in `refs`) and four new Explore lanes (dialect-slang coin, cinematic character name, 1-syllable punch, signature respell), grounded in the Estate 2026 playlist's ARTIST names only.
- **New names:** added **Batch 66** and **Batch 67** (30 artist-grounded names total) — currently unreviewed, ready to star.
- **Analysis doc:** `2026-summer-market-reality-check.md` in the repo.

## OUTSTANDING — do these next
1. **⚠️ DEPLOY THE FIREBASE RULES.** Pushing to GitHub does **not** update Firebase. Until `database.rules.json` is published to Firebase, the old insecure root-read rules are still live and the daily "insecure rules" emails keep coming. Publish via the Firebase CLI (`firebase deploy --only database`) or paste the file into Firebase Console → Realtime Database → Rules → Publish.
2. **Review Batches 66 & 67** in the app (star / maybe / reject), then run a Showdown.
3. *(Optional)* Push the updated Direction Notes into the live DB (edit in the panel) so the new defaults actually show in the app.

## Quick context on the names
- Starred top tier: **DRAGHÌ**, **Dragon River**, **GOOD GUAI**.
- Strongest from the new batches to watch: **PARANZA**, **WISEGUAI**, **SGARRO**, **OMERTÀ**, **AVERNO**.
- The naming north star: a single charged Italian/dialect word or a bilingual/dialect coin that sounds native — "Camorra grandmother, not Tuscan tourism." Full rules are in the Direction Notes panel and `NOTES_DEFAULTS`.

---
Handoff written June 15, 2026.
