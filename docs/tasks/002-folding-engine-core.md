# Task 002 — Model Package format + folding engine core

> خلاصه فارسی: پیاده‌سازی هسته طبق `docs/core-design.md`: قالب «بسته مدل»، موتور تا (وضعیت کاغذ، اصول تعریف خط تا، عملیات پایه)، برنامه‌ریز حرکت، پخش‌کننده سه‌بعدی و رسم دیاگرام دوبعدی ساده. رابط فقط انگلیسی؛ فارسی حذف می‌شود. معیار: پایه‌های مربع، بمب آبی، بادبادک و پرنده فقط از روی اسکریپت پخش شوند، بی عبور لایه‌ها.

**Read first:** `docs/core-design.md` (the reference design), then `docs/approach.md`.
**Work in:** Origami-App. **Report to:** comms repo (`docs/reports/002-folding-engine-core.md`, STATUS, decisions).

## Decisions from the owner (apply now)
- **English UI only.** Remove the Persian strings, RTL handling and language toggle (keep code simple; no i18n layer).
- **Visual polish does not matter.** Clarity of the diagram and correctness of the folding do.
- Existing code/papers are hints. The engine is our own code; external libraries only for narrow math after testing (core-design §9).

## Step 0 — Short evaluation (in the report, before coding)
One paragraph and a decision each: Rabbit Ear (`graph/fold/flatFold.js`, `axioms/`, `layer/`), Flat-Folder (Jason Ku) for layer orders, the `origami-diagrams` format, OrigamiBench's action language (arXiv 2603.13856). Record choices in decisions.md.

## Build
1. **Repo layout:** `packages/engine/` (pure TypeScript, no UI, runs in browser and Node) and `app/` (player). Tests with `npm test` (Vitest or similar).
2. **Model Package format** (core-design §3): `data/schema/model-package.schema.json`; extend `npm run validate:data`. Replace the old `example-crane` data with packages in the new format.
3. **PaperState** (§4): CP graph, per-face transforms, layer order, names registry, view state; FOLD export (`states.fold`).
4. **Action language v1, atomic part** (§5.1–5.4): point references, all seven axiom line definitions, layer selection, `valley`, `mountain`, `foldUnfold`, `unfold`, `collapse`, `turnOver`, `rotate`, `zoom`. Write `docs/action-language.md` in the comms repo (English) matching the implementation exactly.
5. **Interpreter** (§6) with readable errors for impossible actions.
6. **Motion planner** (§7): continuous from the previous state; rigid rotation for simple folds; angle interpolation for `collapse`; layer-offset rendering.
7. **Player:** three.js 3D view (front/back colours, edges, creases), Next (animated), Previous/Home/End (jump), replay, progress slider, reset view. Layout per step: book image (if any) | 2D diagram | 3D.
8. **Diagram renderer, first version** (§8): folded silhouette + visible edges + existing creases + the step's fold line (valley dashed / mountain dash-dot) + a simple arrow, as SVG.
9. **Scripts** (as packages without book images): `square-base`, `waterbomb-base`, `kite-base`, `bird-base` (petal folds via atomic actions + `collapse`). Optional: crane as far as atomic actions allow.
10. **Small fix:** `run-dev.bat` at repo root (adds `%LOCALAPPDATA%\Programs\nodejs` to PATH for that window, `npm install` if needed, `npm run dev`, opens the browser; UTF-8 safe).

## Acceptance criteria
- [ ] Step-0 evaluation with decisions; decisions.md updated.
- [ ] `docs/action-language.md` matches the implementation.
- [ ] Four base packages validate and play; every transition starts exactly from the previous end state (screenshots: end of step k vs start of k+1, two per package).
- [ ] No layer interpenetration or z-fighting in flat states (screenshots incl. an edge-on view of the bird base).
- [ ] 2D diagram shows the folded state and the step's fold line + arrow.
- [ ] Test: final CP of `bird-base` equals the bird base CP in `sources/samples/` up to symmetry.
- [ ] Unit tests: each axiom, face splitting, moving-set closure, layer order after valley/mountain, an impossible action is rejected.
- [ ] English-only UI; `run-dev.bat` works; `npm run build` and `npm test` pass; code and reports pushed.

## Out of scope
Compound actions and `repeat` (task 004), importer (003), authoring (005).
