# Action language v1 — atomic part

**Status:** matches the engine in Origami-App `packages/engine` (task 002). Compound actions and macros (`repeat`, `group`) come in task 004.
**Source of truth for the code:** `packages/engine/src/{refs,actions,fold,collapse}.ts`. Schema: `data/schema/model-package.schema.json`.

Every step of a Model Package (`model.json`) has a list of `actions`. The engine runs them in order; each action starts from the exact end state of the previous one.

---

## 1. Coordinates and conventions

- **Crease-pattern (CP) space:** the unfolded square `[0,1]×[0,1]`, y **up**. Corners: `A` = (0,1) top-left, `B` = (1,1) top-right, `C` = (1,0) bottom-right, `D` = (0,0) bottom-left, `O` = (0.5,0.5) centre. The paper's **front** is the side facing the viewer at the start (`paper.colorUp`).
- **View:** what the diagram shows now (after turn over / rotate). All references in actions are resolved **in the current view**, because diagrams describe folds that way. At the start, view = CP space.
- **Valley / mountain** are always **as seen by the viewer**: a valley fold brings the moving part toward the viewer; a mountain fold takes it away. The engine converts this to the crease-pattern assignment (relative to the paper's front) for each layer.
- **FOLD assignments** in the crease pattern: `B` boundary, `V` valley, `M` mountain (both folded flat, ±180°), `F` a crease that exists but is unfolded (e.g. after fold-and-unfold).

---

## 2. Point references

| Form | Meaning |
|---|---|
| `"A"`, `"B"`, `"C"`, `"D"`, `"O"` | Paper corners and centre — points **of the paper**, wherever they now lie. |
| `"p1"` or `{"name": "p1"}` | A named point (see `as`). |
| `{"mid": [P, Q]}` | Midpoint. If P and Q are both paper points (corners, `O`, names, `cp`, or `mid`/`at` of such), this is the paper point halfway between them in CP space — e.g. `{"mid": ["A","B"]}` is the midpoint of **edge AB**, which stays a point of the paper after folding. Otherwise it is the midpoint of their current view positions. |
| `{"at": [P, Q, t]}` | Point at fraction `t` from P to Q; same rule as `mid`. `t` is a number or a string fraction like `"1/3"`. |
| `{"x": [L1, L2]}` | Intersection of two lines (view). |
| `{"cp": [u, v]}` | A paper point given in CP coordinates (authoring UI picks). |

Any `mid`, `at`, `x` or `cp` point may carry `"as": "name"`: the point is stored by name **in CP coordinates** (for `x`, via the topmost layer at that place), so later steps can use it after more folding.

---

## 3. Line references (fold lines)

A line is defined like diagrams define folds — by the Huzita–Hatori axioms:

| Form | Axiom | Meaning |
|---|---|---|
| `{"through": [P, Q]}` | O1 | Line through P and Q. |
| `{"bring": P, "to": Q}` | O2 | Fold that brings P onto Q (perpendicular bisector). |
| `{"edgeTo": [L1, L2]}` | O3 | Fold that brings line L1 onto line L2 (two angle bisectors; the midline if parallel). |
| `{"perpendicularTo": L, "through": P}` | O4 | Through P, perpendicular to L. |
| `{"bring": P, "onto": L, "through": Q}` | O5 | Through Q, bringing P onto L (0–2 solutions). |
| `{"bring": [P1, P2], "onto": [L1, L2]}` | O6 | Brings P1 onto L1 and P2 onto L2 at once (0–3 solutions, roots of a cubic). |
| `{"bring": P, "onto": L1, "perpendicularTo": L2}` | O7 | Perpendicular to L2, bringing P onto L1. |
| `{"name": "k1"}` | — | A line named earlier with `as` on a fold action. |

`L`, `L1`, `L2` are line references themselves (usually `{"through": [..]}`).
**`pick`** chooses among several solutions: `"pick": 1` (index, in the engine's stable order) or `"pick": {"near": P}` (the solution passing closest to P). Without `pick`, the first solution is used. No solution → error.

---

## 4. Layer selection (`layers`)

Used by `valley`, `mountain`, `foldUnfold` (and per crease in `collapse`, where only `"all"`, `top` and `bottom` apply). `unfold` chooses its flap differently (see below).

| Form | Meaning |
|---|---|
| `"all"` (default) | Every layer that reaches the moving side of the line. |
| `{"top": n}` | The top *n* layers **at each place** on the moving side, as the viewer sees them: a layer is selected if fewer than *n* selected-side layers overlap it from above. |
| `{"bottom": n}` | Same from the back. |
| `{"flap": P}` | The topmost layer at point P (then grown by closure, below). |
| `{"faces": [i, ...]}` | Explicit face indices (authoring fallback; indices change as faces split). |

**Closure:** layers joined to a moving layer by paper that is not on the fold line must move too. If this pulls in layers that were not selected, the action still runs and reports a **warning** ("the moving flap pulled in an unselected layer") — this is how the diagram's implicit "fold all layers of this flap" is detected. If an attached layer lies entirely on the fixed side, the action fails (the paper would tear).

---

## 5. Atomic actions

Every action may have `"text"` (an English instruction; the step's caption is shown otherwise).

### `valley`, `mountain`
```json
{ "op": "valley", "line": LINE, "layers": LAYERS, "move": POINT, "as": "k1" }
```
Folds the selected layers 180° about the line. `move` is a point on the side that moves. **Default moving side:** the side with less paper (the flap); on a tie, the side **not** containing corner D (then A, B, C if D is on the line). `as` names the fold line.
Errors: line misses the paper; the fold would tear; **blocked** — a fixed layer lies on the swing side of a moving layer (e.g. folding a lower layer up through the layers above it); the whole paper would move.

### `foldUnfold`
```json
{ "op": "foldUnfold", "line": LINE, "type": "V" | "M", "layers": LAYERS, "move": POINT, "as": "k1" }
```
Fold (valley by default, mountain with `"type": "M"`) and return. Leaves `F` creases; the paper ends where it started.

### `unfold`
```json
{ "op": "unfold", "line": LINE, "move": POINT }
```
Opens an existing fold along the line. The flap is the topmost layer at `move` (default: the topmost layer along a folded crease on the line), grown through all paper except the line. It swings back the way it can open (up if it lies on top). Error if there is no folded crease on the line, or if the line would cut a layer.

### `collapse`
```json
{ "op": "collapse",
  "creases": [ { "segment": [P, Q] | "line": LINE, "layers": "all" | {"top": n} | {"bottom": n},
                 "type": "V" | "M" | "F"  |  "assign": "V" | "M" | "F" } ],
  "root": POINT, "solution": 0 }
```
Sets the listed creases and folds them all at once — used for the square and waterbomb bases and for petal folds.
- Each entry selects existing creases lying on a **segment** between two points (or anywhere on a **line**), in the current view, optionally only on the top/bottom n layers along it.
- `type` is the type **as seen** on the upper of the crease's two faces. `assign` is the raw crease-pattern assignment (relative to the paper's front); use it for creases between layers where "as seen" is ambiguous.
- Creases not listed keep their assignment.
- The engine computes every face's position from the crease assignment, keeping `root`'s face fixed (default: the largest face away from the changed creases), checks that every crease closes up (else "not flat-foldable as assigned"), and solves the layer order with a layer solver. Pairs of faces that did not move keep their previous order where the solver allows it (if those constraints conflict, it solves without them). If several orders exist, `solution` picks one (default 0) and a warning reports the count.

### `turnOver`
```json
{ "op": "turnOver", "axis": "vertical" | "horizontal" }
```
View action (default vertical axis: left and right swap). Geometry is unchanged; valley/mountain and top/bottom now refer to the other side.

### `rotate`
```json
{ "op": "rotate", "degrees": 90 }
```
View action: rotates the view in the plane (positive = counter-clockwise).

### `zoom`
```json
{ "op": "zoom", "region": [x, y, w, h] | null }
```
Diagram region of interest in view coordinates (`null` = whole model). No geometry change.

---

## 6. Example (square base)

```json
[
  { "op": "foldUnfold", "line": { "through": ["A", "C"] } },
  { "op": "foldUnfold", "line": { "through": ["B", "D"] } },
  { "op": "turnOver" },
  { "op": "foldUnfold", "line": { "through": [{ "mid": ["A", "B"] }, { "mid": ["D", "C"] }] } },
  { "op": "foldUnfold", "line": { "through": [{ "mid": ["A", "D"] }, { "mid": ["B", "C"] }] } },
  { "op": "turnOver" },
  { "op": "collapse", "creases": [
      { "segment": ["O", "A"], "type": "V" }, { "segment": ["O", "C"], "type": "V" },
      { "line": { "through": [{ "mid": ["A", "B"] }, { "mid": ["D", "C"] }] }, "type": "M" },
      { "line": { "through": [{ "mid": ["A", "D"] }, { "mid": ["B", "C"] }] }, "type": "M" } ] },
  { "op": "rotate", "degrees": -135 }
]
```

Petal fold (bird base), on the square base with corner B's flap in front:
```json
[
  { "op": "foldUnfold", "line": { "edgeTo": [{ "through": ["B", { "mid": ["B", "C"] }] }, { "through": ["B", "O"] }], "pick": { "near": { "mid": ["B", "C"] } } },
    "move": { "mid": ["B", "C"] }, "layers": { "top": 1 }, "as": "k1" },
  { "op": "foldUnfold", "line": { "edgeTo": [{ "through": ["B", { "mid": ["B", "A"] }] }, { "through": ["B", "O"] }], "pick": { "near": { "mid": ["B", "A"] } } },
    "move": { "mid": ["B", "A"] }, "layers": { "top": 1 }, "as": "k2" },
  { "op": "foldUnfold", "line": { "through": [
      { "x": [{ "name": "k1" }, { "through": ["O", { "mid": ["B", "C"] }] }], "as": "p1" },
      { "x": [{ "name": "k2" }, { "through": ["O", { "mid": ["B", "A"] }] }], "as": "p2" } ] }, "move": "O" },
  { "op": "collapse", "creases": [
      { "segment": ["B", { "name": "p1" }], "assign": "M" }, { "segment": ["B", { "name": "p2" }], "assign": "M" },
      { "segment": [{ "mid": ["B", "C"] }, { "name": "p1" }], "layers": { "top": 1 }, "assign": "V" },
      { "segment": [{ "mid": ["B", "A"] }, { "name": "p2" }], "layers": { "top": 1 }, "assign": "V" } ] }
]
```
