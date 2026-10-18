---
title: خلاصه فنی منابع — کتابخانه‌های هسته (FOLD، Rabbit Ear، OrigamiSimulator)
generated: 2026-10-18
basis: خواندن مستقیم فایل‌های ریپازیتوری در commitهای ذکرشده. بخش‌های «[تحلیل]» برداشت‌اند، نه فکت.
---

# کتابخانه‌های هسته

## 1. FOLD (edemaine/fold)

- **مخزن:** https://github.com/edemaine/fold — commit `824f9fa6f9` (2023-10-23)
- **npm:** `fold@0.12.0`، ورودی `lib/index.js`
- **مجوز:** MIT
- **زبان:** CoffeeScript (`src/`)، خروجی مرورگر `dist/fold.js`
- **مستندات کامل:** `sources/ref/fold-spec.md` (مشخصات نسخه 1.2) و `sources/ref/fold-api.md`

### ماژول‌ها (از `doc/api.md`)
| ماژول | کار |
|---|---|
| `FOLD.viewer` | نمایش FOLD در مرورگر به صورت SVG |
| `FOLD.filter` | افزودن رأس/یال با تقسیم یال‌های متقاطع، `splitCuts`، `transform` |
| `FOLD.convert` | ساخت فیلدهای مشتق (vertices_vertices، faces_vertices و ...)، `flatFoldedGeometry` |
| `FOLD.file` | خواندن/نوشتن فایل (فقط Node) |
| `FOLD.geom` | ابزار هندسه پایه |

### فایل‌های کلیدی
| فایل | خط |
|---|---|
| `src/geom.coffee` | 497 |
| `src/filter.coffee` | 450 |
| `src/convert.coffee` | 375 — شامل `convert.flatFoldedGeometry` (خط 255) که `vertices_flatFoldCoords` و `faces_flatFoldTransform` را می‌سازد |
| `src/viewer.coffee` | 303 |
| `src/oripa.coffee` | 214 — تبدیل فرمت ORIPA (`.opx`) |

### ابزار خط فرمان (از README)
- `fold-convert -o .fold *.opx` — تبدیل `.opx` به `.fold`
- `fold-convert --flat-fold -o B.fold A.fold` — تا زدن تخت الگوی A و ساخت هندسه تاخورده B

### نمونه‌ها
`examples/`: `simple.fold`، `box.fold`، `squaretwist.fold`، `diagonal-cp.fold`، `diagonal-folded.fold`

### نقش در اپ [تحلیل]
فرمت داده داخلی همه بخش‌ها. هر مرحله آموزشی = یک frame در `file_frames`.

---

## 2. Rabbit Ear (rabbit-ear/rabbit-ear)

- **مخزن:** https://github.com/rabbit-ear/rabbit-ear — commit `762f800db1` (2026-10-16)
- **npm:** `rabbit-ear@0.9.41` (README: «0.9.41 alpha, released 2026.10.16»)
- **مجوز:** GPLv3 (فایل `license`)
- **زبان:** JavaScript (ES6 module + UMD bundle)
- **داده داخلی:** FOLD

### پوشه‌های `src/`
| پوشه | محتوا (از نام فایل‌ها) |
|---|---|
| `graph/` (91 فایل) | عملیات روی گراف FOLD: `fold/flatFold.js` (893 خط)، `split/splitFace.js`، `overlap.js`، `planarize/`، `faces/`، `trees.js`، `flaps.js`، `pleat.js`، `symmetry.js`، `triangulate.js` |
| `axioms/` | اصول Huzita–Hatori (`axioms.js`: توابع `axiom` و `normalAxiom`)، `validate.js` |
| `diagrams/` | فلش‌های دیاگرام: `arrowFromSegment`، `foldLineArrow`، `foldLineArrowInPolygon`، `axiomArrows.js`، `svgArrows.js` |
| `fold/bases.js` | ساخت پایه‌های کلاسیک: `blintz`، `waterbomb`، `kite`، `fish`، `bird`، `frog`، `windmill`، `squareFish` |
| `fold/spec.js` | 611 خط — تعریف‌های FOLD |
| `layer/` (19 فایل) | حل ترتیب لایه‌ها: `solver.js`، `constraintsFlat.js`، `constraints3D*.js`، `tacosTortillas.js`، `transitivity.js` |
| `singleVertex/` | `kawasaki.js`، `maekawa.js`، `flatFoldable.js`، `degree4.js` |
| `svg/` (65)، `webgl/` (45) | رندر SVG و WebGL |
| `convert/` (19) | تبدیل فرمت‌ها |
| `math/` (23) | کتابخانه ریاضی |

### داده نمونه در `tests/files/`
93 فایل `.fold`، 18 `.svg`، 6 `.opx`، 3 `.cp`. مهم‌ترین برای اپ:
- `crane-sequence.fold` — **37 frame**، `file_classes: ["diagrams"]`، نویسنده Kraft. هر frame: `vertices_coords`، `edges_vertices`، `edges_assignment`، `edges_foldAngle`، `faces_vertices`. کپی در `sources/samples/`.
- `crane-cp.fold`، `crane-step.fold`، `bird-base-3d-cp.fold`، `kraft-bird-base.fold` — کپی در `sources/samples/`.

### نقش در اپ [تحلیل]
- فاز ۱ و ۲: رسم الگو و فلش‌های دیاگرام، تولید تاهای پایه با `bases.js`، اعتبارسنجی با Kawasaki/Maekawa.
- فاز ۴: `crane-sequence.fold` نمونه واقعی همان ساختار «یک frame برای هر مرحله» است.

---

## 3. Origami Simulator (amandaghassaei/OrigamiSimulator)

- **مخزن:** https://github.com/amandaghassaei/OrigamiSimulator — commit `903ef27afc` (2026-10-13)
- **مجوز:** MIT
- **زبان:** JavaScript + GLSL (شبیه‌سازی روی GPU در fragment shader)
- **README کامل:** `sources/ref/origamisimulator-readme.md`

### روش (از README)
همه چین‌ها هم‌زمان تا می‌شوند؛ جابه‌جایی‌های کوچک هندسه به‌صورت تکراری از نیروهای چین‌ها حل می‌شود. پایه علمی: Schenk & Guest و Tachi (Freeform Variations). برای چین‌های منحنی از روش Ruling-aware Triangulation استفاده می‌کند. داده داخلی FOLD است.

### فایل‌های کلیدی `js/`
| فایل | خط | کار |
|---|---|---|
| `curvedFolding.js` | 2895 | چین منحنی |
| `pattern.js` | 1290 | ورود SVG/FOLD: `parseSVG`، `processFold`، `splitCuts`، `triangulatePolys`، `findIntersections`، `removeRedundantVertices`، `setFoldData` |
| `dynamic/dynamicSolver.js` | 666 | حل‌کننده دینامیک (GPU) |
| `dynamic/GPUMath.js` | 180 | ریاضی GPU |
| `staticSolver.js` | 285 | حل‌کننده استاتیک |
| `rigidSolver.js` | 225 | حل‌کننده صلب |
| `model.js` | 430 | مدل سه‌بعدی و متریال |
| `importer.js` | 266 | `openFile`، `importDemoFile` |
| `saveFOLD.js`، `saveSTL.js` | 64، 179 | خروجی |
| `videoAnimator.js` | 174 | خروجی GIF/WebM |

### قرارداد رنگ SVG ورودی
در `pattern.js`: فیلترهای `borderFilter`، `mountainFilter`، `valleyFilter`، `cutFilter`، `triangulationFilter`، `hingeFilter` بر اساس رنگ stroke؛ زاویه تا از opacity (`opacityForAngle`).

### داده نمونه در `assets/`
`Bases/` (7: bird، boat، frog، openSink، pinwheel، square، waterbomb)، `SimpleFolds/` (4)، `Origami/` (13، از جمله `traditionalCrane.svg`، `langCardinal.svg`، `langKnlDragon.svg`)، `Tessellations/` (19)، `Curved/` (18). پایه‌ها و تاهای ساده در `sources/samples/` کپی شده‌اند.

### نقش در اپ [تحلیل]
نمایشگر سه‌بعدی همه فازها. کد به سبک قدیمی (توابع global، jQuery، three.js) است؛ برای اپ احتمالاً باید `dynamicSolver` + `pattern.js` را جدا و ماژولار کرد. این بررسی نشده.
