# Task 003 — Book importer (L0) + package review screen

> خلاصه فارسی: ساخت واردکننده خودکار L0: کتاب PDF را می‌گیرد، مدل‌ها را جدا می‌کند، هر مرحله را با شماره و متنش برش می‌دهد و «بسته مدل» می‌سازد. یک صفحه بازبینی در اپ برای اصلاح سریع کادرها. معیار: کل Works of Hideo Komatsu و Origami Essence وارد شوند و هر مدل در پخش‌کننده مرحله‌به‌مرحله با تصویر کتاب دیده شود.

**Read first:** `docs/core-design.md` §3 (package format) and §10 (importer).
**Work in:** Origami-App (runs on the owner's PC — the books are local). **Report to:** comms repo (`docs/reports/003-importer-l0.md`, STATUS, decisions).

## Review of task 002 (from claude.ai)
Accepted. Re-verified in the cloud: `npm test` 41 passed, `validate:data` all valid, build OK. Good decisions (relative layer selection, axiom-based lines, Rabbit Ear only for layer solving). Two notes for later tasks: the petal fold currently needs raw `assign` in `collapse` — task 004 must make such steps one compound action; arrows are placeholders — task 004.

## Inputs
- `$ORIGAMI_LIBRARY_DIR/متن ها و تصاویر/works of hideo komatsu -- hideo komatsu -- 2013 -- 9dcc060f01627818cb63c35e64a2ae66 -- Anna’s Archive.pdf`
- `$ORIGAMI_LIBRARY_DIR/متن ها و تصاویر/Origami Essence -- Roman Diaz -- 54c66ec2a28c3ead460e9bed99afe03b -- Anna’s Archive.pdf`
- Layout observed on sample pages (claude.ai):
  - **Komatsu:** each model starts with a title block (Japanese + English title, "Difficulty" stars ★, "Paper Size", "Created/Revised", "First Published"), a crease pattern and a photo. Steps: large bold numbers; captions Japanese then English; some steps grouped in frames.
  - **Essence:** title in Spanish + English, "Levels: n/n", favourite papers, recommended size, a "ratio" box with a small CP. Steps: small numbers like "5." next to captions; Spanish caption then English in italics. Page numbers at the bottom.

## Where the output goes
Generated book packages are **not committed** (size): write them to `$ORIGAMI_LIBRARY_DIR/library/<book-slug>/<model-id>/` (`model.json`, `images/`). Add `ORIGAMI_LIBRARY_OUT` to `.env.example` (default as above). The app reads both `data/library/` (hand-made packages) and this folder through the dev server. Record the decision.

## Build
1. **Tool:** `tools/import-book/` (Python, venv). Per book a small config file (`tools/import-book/books/<slug>.yaml`): page range, layout hints (step-number style, caption languages to keep = English), title-block markers.
2. **Pipeline:**
   - Render pages at native scan resolution (PyMuPDF).
   - Step numbers: OCR. Evaluate briefly and pick one (record why): Tesseract (needs a system install), RapidOCR (pip, ONNX), EasyOCR; or a vision model for numbers only. Must work on Windows without admin rights if possible.
   - Drawing regions: binarise, remove text boxes, connected components / morphological closing → clusters; assign each cluster to the nearest step number (reading order: rows top→bottom, left→right; Komatsu may use frames).
   - Captions: text lines near each number; keep the English line(s).
   - Model boundaries: detect title blocks; extract title, difficulty (Komatsu stars count; Essence "Levels"), paper size; store the CP/photo crops as package extras (`model.json` → `"extras": [{"kind":"cp"|"photo","file":...}]` — add to the schema).
   - Write one package per model with L0 steps (`label`, `image` with page + bbox, `caption.original`).
3. **Review screen** in the app ("Import review"): page view with detected boxes; actions: move/resize box, split, merge, delete, add, edit label/caption, reorder, mark model start. Saves to `model.json` through a **dev-only** write endpoint in the Vite dev server (local personal app). Keyboard shortcuts for speed.
4. **Player:** library list grouped by book → model (title, difficulty, step count, L0/L1/L2 counts). L0 steps show the book image large with zoom/pan; caption below.
5. **Quality measurement (in the report):**
   - Models detected per book vs the book's own contents list.
   - On 10 random diagram pages per book: steps found / steps actually present, wrong boxes, wrong numbers. View the page images yourself to count.
   - Time needed in the review screen to fix one average model.
   - Resolution of the original PDFs (min/median DPI) — answers the old Komatsu question.

## Acceptance criteria
- [ ] Both books import end to end with one command each; packages validate.
- [ ] Every detected model plays in the player as book images step by step.
- [ ] Step detection: ≥ 90 % of steps correctly boxed and numbered on the sampled pages (report the actual numbers; if lower, say what fails and propose the fix).
- [ ] Review screen can fix any wrong box and saves to disk.
- [ ] 3 sample pages per book with detected boxes drawn, as PNGs in `docs/reports/assets/003/` (< 1 MB each).
- [ ] Code pushed; report, STATUS, decisions pushed.

## Out of scope
Scripting actions (L1), compound actions, in-browser import.
