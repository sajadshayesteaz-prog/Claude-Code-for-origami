# Task 002 — Folding engine core (Phase 1)

> خلاصه فارسی: ساخت هسته «موتور تا»: وضعیت کاغذ با ترتیب لایه‌ها، زبان عملیات تا (عملیات پایه)، انیمیشن پیوسته هر مرحله از وضعیت قبلی، و رسم درست لایه‌ها در سه‌بعدی و دوبعدی. معیار: پایه‌های مربع، بمب آبی، بادبادک و پرنده فقط از روی اسکریپت عملیات ساخته و پخش شوند. اول `docs/approach.md` را بخوان.

**Read first:** `docs/approach.md` (new approach — this replaces the old tasks 002/003, now in `docs/tasks/superseded/`).
**Work in:** Origami-App. **Report to:** comms repo (`docs/reports/002-folding-engine-core.md`, STATUS, decisions).

## Principle
Existing code and papers are **hints, not components**. The engine is this project's own code. You may use an external library for a narrow mathematical job (geometry, layer-order solving) only after testing it and recording why. Prefer the simplest modern approach.

## Step 0 — Short evaluation (write it into the report before coding)
Look at these and decide what, if anything, to reuse. One paragraph each, with a decision:
1. **Rabbit Ear** (npm `rabbit-ear@0.9.41`, `vendor/rabbit-ear`): `graph/fold/flatFold.js`, `axioms/`, `layer/`, `graph/vertices/folded.js`, `graph/orders.js` (`nudgeFacesWithFaceOrders`).
2. **Flat-Folder** by Jason Ku (layer-order solver for flat folds; used by OrigamiBench). Find the repo, check it runs in the browser, test on a bird base.
3. **`origami-diagrams`** (npm, MIT): a FOLD-based diagram format (`file_frames` + `re:diagrams` with crease lines, arrows, multilingual instructions, step labels). Decide whether our step data should follow it.
4. **OrigamiBench** (arXiv 2603.13856): its origami action language (atomic folds = fold line + M/V + indexed layers; combine; library primitives; turn). Use it as a design reference for our action language.
5. The current task-001 viewer (Origami Simulator iframe): keep only as an optional "physics view", not for step playback.

## What to build

### 1. Paper state
- Crease pattern (FOLD: vertices, edges with assignment, faces) + per-face folded transform + **layer order** (which face is above which, wherever they overlap).
- Starts as an unfolded square (also support rectangles; the side length is a parameter).
- Must be serialisable to FOLD (one frame per step) so the existing 2D view and data model keep working.

### 2. Action language v1 (JSON, documented in `docs/action-language.md` in this repo — write it in English with a short Persian intro)
Each step is a list of actions. Points are named so a human (or Claude reading a diagram) can write them:
- **Point references:** paper corners (`A B C D` = top-left, top-right, bottom-right, bottom-left of the starting square), edge midpoints, the centre, crease intersections, and named points created by earlier steps; also raw coordinates as a fallback.
- **Fold-line definitions:** through two points; perpendicular bisector (bring point P onto point Q); bring an edge onto another edge (angle bisector); bring point P onto line L through point Q (Huzita–Hatori style). Use these because diagrams describe folds this way.
- **Atomic actions:**
  - `valley` / `mountain` along a line, applied to: `all` layers, the `top` n layers, or a named flap (a set of faces selected by a point on it).
  - `foldUnfold` (pre-crease: fold, then return, leaving a crease).
  - `turnOver` (horizontal or vertical axis), `rotate` (in-plane, degrees).
  - `collapse`: assign M/V to several existing creases and fold them simultaneously (needed for square/waterbomb base).
- Each action has optional `text: {fa, en}`.

### 3. Engine
- Applies an action to a state → new state (split faces along the fold line where needed, move the selected side, update layer order).
- Rejects impossible actions with a clear error (e.g. layers would pass through each other, line misses the paper).
- **Motion plan per action:** for `valley`/`mountain` the moving faces rotate rigidly about the fold line from 0 to ±180° starting from the previous state; `turnOver`/`rotate` animate the whole model; `collapse` interpolates crease angles (approximate in-between shapes are acceptable; start and end must be exact).

### 4. Rendering
- **3D (three.js, our own component):** faces with front/back colours, edges and creases drawn; while animating, layers keep their order; in flat states, layers are offset by a tiny ε by layer index so they never z-fight or cross.
- **2D diagram view:** the current folded state seen from above (flat), outlines of all layers, existing creases faint, plus — for the *next* action — the fold line (valley dashed / mountain dash-dot) and a simple arrow. This is the first version of drawing book-style diagrams.
- Controls: Next (animates), Previous/Home/End (jump), replay step, transition progress slider, reset view.

### 5. Scripts to prove it works (in `data/scripts/`)
Write action scripts and play them in the app:
- `square-base.json`, `waterbomb-base.json`, `kite-base.json`, `bird-base.json` (from square base, two petal folds expressed with atomic actions + `collapse` if needed).
- `crane.json` if time allows (bird base → narrow → reverse folds may need Phase 2 — partial is fine).
- **Check:** the final crease pattern of `bird-base.json` must match the bird base CP in `sources/samples/` (`kraft-bird-base.fold` or `birdBase.svg`), up to symmetry. Write a small test for this.

### 6. Small fixes from the review of task 001
- `run-dev.bat` at repo root: adds `%LOCALAPPDATA%\Programs\nodejs` to PATH for that window, runs `npm install` if needed, then `npm run dev`, opens the browser. UTF-8 safe.
- Persian is the default language on first visit.

## Acceptance criteria
- [ ] Step-0 evaluation in the report with a decision per item; decisions recorded.
- [ ] `docs/action-language.md` exists and matches the implementation.
- [ ] The four base scripts play step by step; every transition starts exactly from the previous step's end state (screenshots: end of step k vs start of step k+1 for two transitions per script).
- [ ] No layer interpenetration or z-fighting in flat states (screenshots incl. an edge-on view of the bird base).
- [ ] 2D diagram view shows the folded state and the next fold line/arrow.
- [ ] Bird-base CP test passes.
- [ ] Unit tests for the engine (fold-line definitions, face splitting, layer order after a fold) run with `npm test`.
- [ ] `run-dev.bat` works from Explorer; `npm run build` passes; code pushed; report, STATUS, decisions pushed.

## Out of scope
Compound actions (reverse, squash, petal as single actions, sink, crimp…) — Phase 2. PDF import and authoring tool — Phase 3. Library, PWA, IndexedDB.
