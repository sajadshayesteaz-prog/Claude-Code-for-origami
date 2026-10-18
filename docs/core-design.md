# Core design — Origami diagram engine

**Version:** 1 — 2026-10-18 (۲۷ مهر ۱۴۰۵). This document is the reference for all engine and format work. It supersedes the phase list in `approach.md` where they differ.

---

## خلاصه فارسی

**هدف:** کتاب اوریگامی وارد اپ شود و کاربر دیاگرام کامل و مفهومیِ هر مدل را مرحله‌به‌مرحله ببیند — تصویر کتاب، نمای دوبعدی دیاگرام‌مانند، و انیمیشن سه‌بعدی. رابط فقط انگلیسی است و جزئیات گرافیکی اهمیت ندارد.

**واقعیت فنی:** تبدیل کاملاً خودکار «PDF ← انیمیشن سه‌بعدی درست» امروز قابل‌اعتماد نیست. پژوهش‌های ۲۰۲۶ نشان داده‌اند مدل‌های هوش مصنوعی در تطبیق تصویر دیاگرام با عملیات تا هنوز ضعیف‌اند. پس طراحی دو لایه دارد:

1. **یک قالب ورودی ثابت** («بسته مدل» / Model Package) که همه چیز حول آن ساخته می‌شود. هر مرحله سه سطح دارد:
   - **L0 — تصویر:** برش تصویر مرحله از کتاب + شماره + متن. **کاملاً خودکار** از PDF ساخته می‌شود؛ پس اپ از روز اول می‌تواند کتاب را بگیرد و دیاگرام کامل را مرحله‌به‌مرحله نشان دهد.
   - **L1 — اسکریپت:** عملیات تای آن مرحله به زبان عملیات. موتور از آن نمای دوبعدی تمیز و انیمیشن سه‌بعدی می‌سازد. با پیشنهاد هوش مصنوعی + تأیید انسان ساخته می‌شود.
   - **L2 — تأییدشده:** نتیجه موتور با تصویر کتاب تطبیق داده و تأیید شده است.
2. **موتور تا** که اسکریپت را اجرا، متحرک و به دیاگرام تبدیل می‌کند.

مدلی که فقط L0 دارد هم قابل استفاده است؛ هر مرحله‌ای که L1 بگیرد، سه‌بعدی می‌شود. گسترش کتابخانه یعنی: PDF ← L0 خودکار ← L1 نیمه‌خودکار.

---

## 1. Goals and non-goals

**Goals**
- G1. Import a book PDF and show every model's diagram completely, step by step (L0), with no manual work beyond confirming the auto-detected steps.
- G2. For scripted steps (L1), show a clean conceptual 2D diagram and a 3D animation that continues from the previous step, with correct layer order.
- G3. One stable input format so the library grows by converting PDFs into it quickly.
- G4. The engine is generic enough to later run tessellations and user-designed models.

**Non-goals (now)**
- Persian UI / RTL (dropped). English UI only.
- Visual polish. Clarity of the diagram matters; styling does not.
- Physically exact motion during complex moves (start and end states must be exact; in-between may be approximate).
- Fully automatic PDF → L1. Assisted only.

---

## 2. Architecture

```
            ┌──────────── Importer ────────────┐
 Book PDF ─►│ page render → step detection →   │─► Model Package (L0)
            │ crop + number + caption (OCR)    │
            └──────────────────────────────────┘
                              │
            ┌──────── Authoring (assisted) ────┐
            │ AI proposes actions per step;    │─► Model Package (L1/L2)
            │ engine executes; human compares  │
            │ with book image and fixes        │
            └──────────────────────────────────┘
                              │
            ┌──────────── Engine ──────────────┐
            │ PaperState + Action interpreter  │─► states (FOLD frames, cached)
            │ + Motion planner                 │─► motion per step
            │ + Diagram renderer (2D)          │─► diagram per step
            └──────────────────────────────────┘
                              │
            ┌──────────── Player ──────────────┐
            │ book image | 2D diagram | 3D     │
            └──────────────────────────────────┘
```

Each block has a clean interface and can be tested alone. The engine is a pure TypeScript library (`packages/engine`) with no UI dependency, usable in the browser and in Node (for batch checks and tests).

---

## 3. Model Package format (the contract)

A package is a folder (or `.zip` with the same layout):

```
<model-id>/
  model.json          # metadata + steps (the source of truth)
  images/             # step crops from the book (PNG/WebP), L0
  states.fold         # derived: FOLD with one file_frame per step (regenerable cache)
```

### 3.1 `model.json`

```json
{
  "format": "origami-model-package/1",
  "id": "komatsu-horse",
  "title": "Horse",
  "designer": "Hideo Komatsu",
  "source": { "book": "Works of Hideo Komatsu", "pages": [78, 85] },
  "difficulty": { "scale": "book-stars-4", "value": 4 },
  "paper": { "shape": "square", "size": "24x24cm", "colorUp": "white" },
  "category": "mammals",
  "steps": [
    {
      "id": "s1",
      "label": "1",
      "image": { "file": "images/001.png", "page": 78, "bbox": [x, y, w, h] },
      "caption": { "original": "Fold and unfold.", "lang": "en" },
      "level": "L1",
      "actions": [ { "op": "foldUnfold", "line": { "through": ["A", "C"] } } ],
      "notes": ""
    }
  ]
}
```

Rules:
- `label` keeps the book's numbering (`"12"`, `"12a"`). Order in `steps` is playback order.
- `level` ∈ `L0 | L1 | L2`. L0 steps have no `actions`.
- `image` is always present for book models (the user can always see the original).
- Macros (repeat steps, mirror) are actions too (§5.6), so "Repeat steps 12–20 on the right" is one step with one action.
- JSON Schema in `data/schema/model-package.schema.json`; `npm run validate:data` checks every package.

### 3.2 `states.fold`
FOLD 1.2, `file_classes: ["diagrams"]`, one frame per step after the step's actions, plus the engine's layer order (`faceOrders`). Always regenerable from `model.json`; never edited by hand. Compatible with other FOLD tools for checking.

---

## 4. Engine — PaperState

- **Crease pattern:** planar graph on the unfolded paper (FOLD `vertices_coords`, `edges_vertices`, `edges_assignment` ∈ B/M/V/F(lat, unfolded crease)/U, `faces_vertices`).
- **Placement:** one rigid 3D transform per face (crease-pattern coordinates → model space). In flat states all transforms map to the plane z = 0.
- **Layer order:** for every pair of faces that overlap in a flat state, which one is above (`faceOrders` as in FOLD). Stored per overlap cluster.
- **Names:** a registry of named points/lines created by actions (e.g. `"p1"` = intersection made at step 4), resolved in crease-pattern space so they stay valid after later folds.
- **View:** current orientation (turned over? rotated by θ?) kept separate from the paper so view actions do not change geometry.

Invariant after every action: valid planar CP; transforms consistent across every unfolded or flat-folded crease; layer order acyclic and consistent with the folded geometry. Violations make the action fail with a readable error.

---

## 5. Action language v1

Coordinates: the starting square is `[0,1]×[0,1]` in the diagram's view; `A` top-left, `B` top-right, `C` bottom-right, `D` bottom-left (as first drawn in the book). All geometric references are resolved **in the current folded view**, because that is how diagrams describe them.

### 5.1 Point references
- Paper corners `A B C D`; edge midpoints `mid(A,B)`; centre `O`.
- Intersections of creases/edges: `x(lineRef, lineRef)`.
- Fractions along a segment: `at(A, B, 1/3)`.
- Named points: `{"name": "p1"}` created with `"as": "p1"` on any action.
- Picked points (from the authoring UI): `{"cp": [u, v]}` in crease-pattern coordinates (stable), never raw screen coordinates.

### 5.2 Fold-line definitions (Huzita–Hatori axioms, because diagrams describe folds this way)
- `through: [P, Q]` (O1) · `bring: P, to: Q` (O2, perpendicular bisector) · `edgeTo: [L1, L2]` (O3, angle bisector) · `perpendicularTo: L, through: P` (O4) · `bring: P, onto: L, through: Q` (O5) · `bring: [P1,P2], onto: [L1,L2]` (O6) · `bring: P, onto: L1, perpendicularTo: L2` (O7). Where several solutions exist, `pick` chooses by index or by a hint point.

### 5.3 Layer selection
- `"layers": "all"` (default) · `{"top": n}` · `{"bottom": n}` · `{"flap": P}` = the connected flap containing point P · `{"faces": [...]}` (authoring fallback).

### 5.4 Atomic actions
| op | meaning |
|---|---|
| `valley`, `mountain` | fold selected layers along the line; the side containing `move: P` (default: the side not containing the paper's anchor) moves |
| `foldUnfold` | valley (or mountain with `"type":"M"`) and return; leaves a crease |
| `unfold` | open a fold back (by crease or flap reference) |
| `collapse` | set M/V on listed existing creases (by reference) and fold them simultaneously; used for square/waterbomb base and any "collapse along existing creases" step |
| `turnOver` | `axis: "vertical" | "horizontal"` (view action) |
| `rotate` | degrees in plane (view action) |
| `zoom` | region of interest for the diagram (view action, no geometry) |
| `shape` | non-flat shaping: set partial fold angles on listed creases (approximate 3D; for final steps) |

### 5.5 Compound actions (Phase 2; each defined as an expansion into atomic actions + `collapse`)
`insideReverse`, `outsideReverse`, `squash`, `petal`, `rabbitEar`, `swivel`, `pleat`, `crimp`, `sinkOpen`, `sinkClosed`, `spreadSquash`, `doubleRabbitEar`. Each has a minimal parameter set mirroring how diagrams specify it (e.g. `insideReverse: {flap: P, line: ...}`).

### 5.6 Macros
- `repeat: {steps: ["s12","s20"], mirror: "vertical" | "horizontal", side: "behind" | "other"}` — re-applies a step range mirrored. Books say "repeat on the other side/behind" constantly; this saves most of the scripting work.
- `group: [actions]` — several actions shown as one book step (e.g. "3, 4" combined).

Every action may carry `"text"` (English instruction, defaults to the book caption) and `"as"` (name results).

---

## 6. Engine — action interpreter (algorithm outline)

For `valley`/`mountain` on a flat state:
1. Resolve the fold line in the current view; map it into each selected face's CP coordinates via the inverse face transform.
2. Split every selected face crossed by the line (CP-space split); new edges get assignment `V`/`M` (from the face's orientation: a valley in view may be a mountain on a back-facing face).
3. Moving set: faces of the selected layers on the moving side, closed under "must move together" (faces joined by uncreased edges or by layers that would otherwise tear). If the closure pulls in unselected layers, report it — this is how a diagram's implicit "fold all layers of this flap" is detected.
4. New transforms: reflect moving faces across the line (flat result).
5. Layer order: moving faces flip their internal order and are placed on top (valley) / behind (mountain) of the stationary faces they now overlap.
6. Validate: local flat-foldability (Kawasaki, Maekawa) at new vertices; global layer order acyclic (use a layer solver to check, see §9).

`collapse` and compound actions: assign creases, then **solve** the flat-folded state (face transforms from the CP + assignment; layer order from the solver). The solver is the one external dependency worth taking (see §9).

---

## 7. Engine — motion planner

Every action produces a **motion**: a function `t ∈ [0,1] → face transforms`, starting exactly at the previous state's end and ending exactly at the new state.
- `valley`/`mountain`: rigid rotation of the moving set about the fold line from 0 to ±180°; layers stay separated by construction (the moving stack rotates as one block).
- `turnOver`/`rotate`: whole-model rotation.
- `collapse` / compound: fold-angle interpolation along a face spanning tree rooted at a stationary face, optionally in phases defined per compound op (e.g. reverse fold: open → push → close). In-between shapes may be approximate.
- Rendering separation: flat stacked layers are offset along the normal by `layerIndex × ε` (ε ≈ 0.002 × paper size) and the offset is interpolated during motion, so coplanar layers never z-fight.

---

## 8. Diagram renderer (2D, book-style)

For each step, draw from the state before the step:
- Folded silhouette with all visible edges; hidden edges as x-ray lines when relevant; existing creases thin.
- The step's fold lines: valley dashed, mountain dash-dot; standard arrows (valley/mountain arrow, fold-and-unfold, push, turn over, rotate, repeat) — symbol vocabulary from OrigamiDraw/Doodle and Lang's conventions.
- Automatic orientation and scaling to match the book view; `zoom` actions crop.
- Output SVG. Also used in authoring to compare with the book crop (silhouette overlap score, §10).

The player shows, per step: **book image | engine diagram | 3D**. For L0 steps only the book image.

---

## 9. External pieces — evaluate, then decide (hints, not components)

| Need | Candidates | Note |
|---|---|---|
| Layer-order solving for flat states | Flat-Folder (Jason Ku), Rabbit Ear `layer/` | Both used by OrigamiBench (2026). Test on bird base and on a Komatsu-level CP; pick one or port the algorithm |
| Geometry (splits, intersections, axioms) | Rabbit Ear `graph/`, `axioms/`; own code | Prefer small own code where the library API is awkward |
| Diagram format conventions | `origami-diagrams` (Rabbit Ear, FOLD `re:diagrams`) | Align our `states.fold` annotations if it costs little |
| PDF rendering in browser | pdf.js | For in-app import |
| Step detection | OpenCV (Python) / OpenCV.js; OCR: Tesseract or a vision model | Komatsu pages: boxed steps with large numbers |
| AI proposal of actions | Claude (vision) with prompt = book crop + caption + engine diagram of current state + action-language spec | Offline (Claude Code) first; in-app API later |

---

## 10. Importer and authoring

**Importer (L0, automatic):**
1. Render each page (300 dpi target; keep native resolution for scans).
2. Detect step numbers (OCR on large digits) and drawing clusters (connected components after removing text); assign each cluster to the nearest step number; captions = text blocks near the cluster.
3. Detect model boundaries (title blocks, "Difficulty", new crease pattern) → one package per model.
4. Write packages with L0 steps; a review screen lets the user fix a wrong box or merge/split steps.
Runs offline (Python tool) first; the same logic in the browser (pdf.js + OpenCV.js) is the "app takes the book itself" path.

**Authoring (L0 → L1/L2):**
1. For each step in order, show: book crop, engine diagram of the current state, editable actions.
2. "Propose" asks Claude for the actions (prompt includes the action-language spec and the previous steps' actions).
3. Engine runs the proposal; the engine diagram after the step is overlaid on the next book crop; a silhouette-overlap score flags mismatches.
4. Human edits (pick points on the diagram, change op/layers) until it matches → L2.
Macros (`repeat`) and compound ops keep the human work per step small.

---

## 11. Build order (tasks)

| Task | Content | Done when |
|---|---|---|
| 002 | Package format + schema; engine core (PaperState, axioms, valley/mountain/foldUnfold/unfold/turnOver/rotate/collapse); motion planner; 3D player; minimal diagram renderer; English-only UI | Square, waterbomb, kite and bird bases play from scripts; bird-base CP matches the sample; no layer crossing |
| 003 | Importer L0 (Python) on Komatsu + Essence; package review screen; player shows L0 books | A whole book imports; each model plays as book images step by step |
| 004 | Compound actions + `repeat` macro; layer solver decision | Traditional crane fully scripted with compound ops |
| 005 | Authoring tool + Claude-assisted proposals + overlap score | One Díaz model (Little Frog) to L2 |
| 006 | Pilot library: 3–5 models to L2 incl. 1–2 Komatsu | Playable end to end |
| later | In-app PDF import, library UX, tessellations, design engine | — |
