# Task 003 — Continuous step-to-step 3D + correct layer stacking

> خلاصه فارسی: کاربر دو مشکل در نمای سه‌بعدی گزارش کرده است: (۱) هر مرحله دوباره از کاغذ صاف و همه چین‌ها هم‌زمان تا می‌خورد، در حالی که باید از حالت پایانی مرحله قبل فقط تای جدید زده شود؛ (۲) لایه‌های کاغذ از هم عبور می‌کنند. این برگه یک نمایشگر سه‌بعدی جدید (سینماتیک، با three.js و Rabbit Ear) برای پخش مرحله‌ای می‌سازد. Origami Simulator فقط به‌عنوان «نمای فیزیکی» اختیاری می‌ماند.

**Priority:** run this **before task 002** if 002 has not started. If 002 is already in progress or done, run it right after; 002's guide must then use the new 3D view.
**Work in:** Origami-App. **Report to:** comms repo (`docs/reports/003-continuous-3d-and-layers.md`, STATUS, decisions).

## Diagnosis (from claude.ai)
1. **Restart from flat:** Origami Simulator rebuilds its model from a flat sheet on every `importFold`, then its solver folds all creases at once. That is its design (`sources/ref/origamisimulator-readme.md`); it cannot continue from a previous state.
2. **Layers passing through each other:** Origami Simulator has no collision handling between layers, and fully flat-folded layers (±180°) lie in the same plane, so they interpenetrate and z-fight.

Both are solved by not using the physics simulator for step playback, and instead computing the folded geometry directly from fold angles and layer orders, which Rabbit Ear already provides.

## Rabbit Ear functions to use (verified in `vendor/rabbit-ear/src` at the pinned commit)
- `graph/vertices/folded.js` → `makeVerticesCoords3DFolded(graph, rootFaces)`: 3D vertex positions from `edges_foldAngle` (any angle, not only flat). Root face stays fixed.
- `graph/faces/matrix.js` → `makeFacesMatrix`: per-face 3D transforms from fold angles.
- `layer/layer.js` → `layer(graph, epsilon)`: layer order of a flat-folded state (`faceOrders`).
- `graph/orders.js` → `nudgeFacesWithFaceOrders({ vertices_coords, faces_vertices, faceOrders, faces_normal })`: per-face offset vector + layer index for rendering stacked layers; `makeFacesLayer`, `linearizeFaceOrders`.
Check the exact exported names in the npm build (`ear.graph.*`, `ear.layer`) and record them in decisions.md.

## What to build

### 1. `FoldAnimator3D` (three.js, replaces the iframe for step playback)
- Input: the document's frames (FOLD), current step index.
- Render each face as a mesh: front colour on one side, white/back colour on the other; thin dark edges; crease lines drawn on top. Use `polygonOffset` and the layer nudges (below) so coplanar layers never z-fight.
- Orbit controls, "reset view", and the existing fold-percent slider (now meaning the progress of the current transition, 0–100%).

### 2. Continuous transition from step k to k+1
- Build the transition on **frame k+1's crease pattern**.
- **Start angle** of each edge of frame k+1: if the edge lies on a crease of frame k (collinear and contained, within epsilon), take that crease's angle in frame k; otherwise 0. **End angle:** frame k+1's `edges_foldAngle` (derive ±180 from M/V when missing).
- Animate t: 0→1 over ~1.2 s (ease-in-out) with angles = lerp(start, end, t); compute positions with `makeVerticesCoords3DFolded`.
- **Root face:** choose one face of frame k+1 whose transform is the same at t=0 and t=1 (does not move during this step), preferring the face containing the same reference point as the previous step's root. This keeps the model from jumping.
- **Next** plays the transition k→k+1. **Previous** and jumps (Home/End, sample change) show the target frame's end state immediately, no animation. A "replay step" button replays the current transition.
- Frames that already contain partial angles (the crane sample has some, e.g. step 10: −96°/115°) are keyframes like any other.

### 3. Layer stacking
- For each frame's **end state**, if all angles are 0 or ±180 (flat), compute `faceOrders` with `layer()` on the flat-folded graph, then `nudgeFacesWithFaceOrders` → offset each face along its normal by `layerIndex × ε` (ε ≈ 0.002 × paper size; make it a constant).
- During a transition, interpolate each face's offset between the start state's and end state's offsets (use 0 for states that are not flat).
- If `layer()` finds no valid order (returns undefined/cycle) for a frame, fall back to no offsets for that frame and list it in the report.

### 4. Known limitation (state it in the UI help text and the report)
Interpolating angles moves faces rigidly along a face tree. For non-rigid moves (squash, reverse fold, sink, petal) the in-between shapes are approximate and faces may briefly separate or cross mid-move; start and end states are correct. Real collision handling during motion is out of scope.

### 5. Keep Origami Simulator as an option
A toggle **نمای فیزیکی / Physics view** that shows the current frame in the existing iframe (current behaviour). Useful for single crease patterns (SVG bases) and later for the design tools. Default: the new animator.

## Acceptance criteria
- [ ] Crane: stepping 1→37 with Next never returns to a flat sheet; each transition starts exactly where the previous one ended (side-by-side screenshots: end of step k and start of step k+1, for k = 9, 15, 25).
- [ ] Flat states show no z-fighting or interpenetration: screenshots of steps 11, 20 and 37 from three camera angles, including an edge-on view where the stacked layers are visible.
- [ ] `birdBase.svg` / `kraft-bird-base.fold` display correctly in the new view (single frame: animate 0→100%).
- [ ] Previous/Home/End/sample change jump without animation; "replay step" works.
- [ ] Physics-view toggle still shows the old Origami Simulator view.
- [ ] List of frames where `layer()` failed (if any), and any transition that looks clearly wrong.
- [ ] `npm run build` passes; code pushed; report, STATUS, decisions pushed.

## Out of scope
Physical collision simulation during motion, curved folds, changes to the FOLD sample data.
