# Task 004 — Compound actions, `repeat`, phased motion, standard arrows

> خلاصه فارسی: افزودن عملیات مرکب (معکوس داخلی/خارجی، له‌کردنی، گلبرگی، گوش خرگوشی، فرو بردن و …) و ماکروی `repeat` به زبان عملیات، با حرکت چندمرحله‌ای واقعی برای هر کدام، و فلش‌ها و نمادهای استاندارد دیاگرام. معیار: درنای سنتی کامل با کمترین تعداد عملیات؛ CP نهایی با `crane-cp.fold` برابر.

**Read first:** `docs/core-design.md` §5.5–5.6, §7, §8; `docs/action-language.md`.
**Work in:** Origami-App. **Report to:** comms repo (`docs/reports/004-compound-actions.md`, STATUS, decisions).
**If task 003 is done:** look at the imported Komatsu and Essence captions and list how often each fold type appears; prioritise accordingly and include the counts in the report.

## Build
1. **Compound actions** (each = one action in a script, expanded internally into atomic folds + `collapse`, with parameters mirroring how diagrams specify them):
   `insideReverse`, `outsideReverse`, `squash`, `petal`, `rabbitEar`, `doubleRabbitEar`, `swivel`, `pleat`, `crimp`, `sinkOpen`, `sinkClosed`, `spreadSquash`.
   Write a short spec for each in `docs/action-language.md` (parameters, defaults, what moves, failure cases). The bird base's petal steps must become single `petal` actions (no raw `assign`).
2. **Macros:** `repeat` (step range, mirror vertical/horizontal, `behind`/`other side`), `group`.
3. **Phased motion per compound action:** e.g. inside reverse = open the layers → push the point in → close; squash = lift → open → flatten; petal = lift the bottom point while the sides fold in. Use the connected bar-and-hinge motion added after task 002 for phases where faces bend together. Paper must never separate or pass through itself at phase boundaries; in-between approximations are acceptable.
4. **`shape`** (partial angles for final shaping) — minimal version.
5. **Diagram symbols** (§8): proper valley/mountain arrows, fold-and-unfold, push (for reverse/sink), turn-over, rotate, repeat (with step range text), x-ray lines for hidden layers where the action affects them. Use `sources/origamidraw/origamidraw.js` and standard conventions as reference; own SVG code.
6. **Packages:**
   - `traditional-crane` (from the square, using compound actions; book-style steps).
   - A "Basics" package set (one short package per compound action) — this becomes the basic-folds guide.
   - Update `bird-base` to use `petal`.

## Acceptance criteria
- [ ] Every compound action has a spec, unit tests (result CP + layer order on a minimal example) and a demo package.
- [ ] `traditional-crane` plays start to finish; final CP equals `sources/samples/crane-cp.fold` up to symmetry and M/V flip (test).
- [ ] Continuity test (t=0 equals previous end, t=1 equals next) and connectivity test (no shared vertex separates) pass for every motion phase of every package.
- [ ] Diagram screenshots for: inside reverse, squash, petal, rabbit ear, open sink, repeat — showing correct symbols (`docs/reports/assets/004/`).
- [ ] `npm test`, `validate:data`, build pass; code and reports pushed.

## Out of scope
Authoring UI and AI proposals (task 005).
