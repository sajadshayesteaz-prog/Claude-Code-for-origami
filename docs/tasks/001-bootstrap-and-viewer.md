# Task 001 — Bootstrap Origami-App + core viewer (Phases 0 and 1)

> خلاصه فارسی: راه‌اندازی مخزن Origami-App، دریافت منابع بیرونی، مدل داده، و ساخت هسته نمایش (الگوی چین دوبعدی + سه‌بعدی + پخش مرحله‌به‌مرحله). معیار اصلی: دنباله ۳۷ مرحله‌ای درنا کامل پخش شود.

**Work in:** Origami-App (code). **Report to:** Claude-Code-for-origami (`docs/reports/001-bootstrap-and-viewer.md`, `docs/STATUS.md`, `docs/decisions.md`).

## Goal
A running web app that loads a FOLD file and shows (a) the crease pattern / current frame in 2D, (b) the folded 3D state, with Previous/Next to step through `file_frames`.

## Inputs (in the comms repo, `$COMMS_DIR`)
- `docs/handoff.md`, `docs/brief.md`, `docs/roadmap.md` (phases 0–1)
- `sources/00-index.md`, `sources/digest-core-libraries.md`, `sources/ref/fold-spec.md`, `sources/ref/fold-api.md`, `sources/ref/origamisimulator-readme.md`
- `sources/samples/` (especially `crane-sequence.fold`, `crane-cp.fold`, `birdBase.svg`)
- `sources/fetch-sources.sh`

## Steps
1. Repo setup in Origami-App: `.gitignore` (vendor/, .env, node_modules, venv, *.pdf), `.env.example`, `README.md`.
2. Run `bash "$COMMS_DIR/sources/fetch-sources.sh" vendor` (Git Bash on Windows is fine). Record any repo that fails.
3. Copy `$COMMS_DIR/sources/samples/` into `app/public/samples/` (or reference them at build time — your choice, record it).
4. Data model: JSON Schemas in `data/schema/` for **Model** (id, names fa/en, category, difficulty 1–5, designer, book + page, paper size/shape, step count, has3D), **Step** (index, image path, text fa/en, notes, optional FOLD frame index), **Progress** (model id, last step). Add one example `model.json` that validates.
5. App scaffold (Vite + React + TS), fa/en toggle with RTL for fa.
6. Viewer:
   - Load a `.fold` file (file picker + bundled samples).
   - 2D view of the current frame (Rabbit Ear SVG or FOLD viewer) with mountain/valley styling.
   - 3D view of the current frame by adapting Origami Simulator's pattern import + solver.
   - Prev/Next, frame counter, keyboard arrows.
   - Also accept Origami Simulator–style SVG crease patterns (e.g. `birdBase.svg`).

## Acceptance criteria
- [ ] `npm install && npm run dev` starts the app with no errors.
- [ ] `crane-sequence.fold` loads; all 37 frames step forward and back; 2D and 3D both update per frame.
- [ ] `birdBase.svg` loads and folds in 3D.
- [ ] Example `model.json` validates against the schema (script or test output in the report).
- [ ] UI switches fa↔en; fa is RTL.
- [ ] Code pushed to Origami-App; report, STATUS and decisions pushed to the comms repo.

## Out of scope
Library pipeline, basic-folds content, design tools, mobile packaging, styling polish.

## You may decide (record in decisions.md)
- Embed Origami Simulator via a wrapped module vs. reimplement its solver calls on three.js.
- Rabbit Ear vs FOLD viewer for 2D rendering.
