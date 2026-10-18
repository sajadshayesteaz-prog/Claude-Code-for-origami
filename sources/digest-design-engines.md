---
title: خلاصه فنی منابع — موتورهای طراحی (BP Studio، TreeMaker، ReferenceFinder، scikit-image)
generated: 2026-10-18
basis: خواندن مستقیم فایل‌های ریپازیتوری در commitهای ذکرشده. بخش‌های «[تحلیل]» برداشت‌اند، نه فکت.
---

# موتورهای طراحی (فاز ۵: تصویر به پایه درختی)

## 1. Box Pleating Studio (bp-studio/box-pleating-studio)

- **مخزن:** https://github.com/bp-studio/box-pleating-studio — commit `0496ad070b` (2026-10-18)
- **مجوز:** MIT (فایل `LICENSE.md`)
- **زبان:** TypeScript (433 فایل `.ts`)، Vue (80)، C++ (بهینه‌ساز، کامپایل به WebAssembly)
- **مستندات معماری:** در `vendor/box-pleating-studio/`: `src/core/README.md`، `src/core/design/layout/README.md`، `src/client/plugins/optimizer/src/README.md`

### معماری (از `src/core/README.md`)
- **Core** یک Web Worker است که یک پروژه را نگه می‌دارد. دستور از Client می‌گیرد، حالت طرح را تغییر می‌دهد، متغیرهای وابسته را حساب می‌کند و تفاوت (`UpdateModel`) را برمی‌گرداند.
- Core فرض می‌کند دستورها معتبرند؛ اعتبارسنجی با Client است.
- جریان داده: ساختار درخت + طول یال‌ها + موقعیت و اندازه flapها + انتخاب الگوی کششی ← ارتفاع گره‌ها و متعادل‌سازی درخت ← AABB ← junctionها ← stretchها و patternها ← contourها ← گرافیک.

### API هسته (`src/core/routes/routes.ts`)
سه کنترلر: `design: DesignController`، `tree: TreeController`، `layout: LayoutController` (پوشه `src/core/controller/`). Client از طریق proxy نوع‌دار و Promise آن‌ها را صدا می‌زند.

### ساختار `src/core/`
| مسیر | فایل‌ها | محتوا |
|---|---|---|
| `design/layout/` | 49 | چیدمان، `generators/` (شامل `universalGPS.ts`، `deviceGenerator.ts`)، `pattern/`، `trace/`، `junction/`، `stretch.ts` |
| `design/tasks/` | 23 | مراحل محاسبه (مثلاً `traceContour.ts`، 420 خط) |
| `design/cp/` | 3 | تولید الگوی چین: `genericCP.ts` (تابع `getGenericCP(sheet)`)، `axisParallel.ts`، `faces.ts` |
| `math/` | — | `gops.ts`، `kamiya.ts`، `fraction.ts`، `sweepLine/` (39)، `geometry/` (12) |

### افزونه‌های Client (`src/client/plugins/`)
- `cp/fold.ts` — **خروجی FOLD** الگوی چین
- `treeMaker/` — **ورود فایل TreeMaker 5** (`TreeMakerParser`؛ بررسی می‌کند فایل با `tree` و `5.0` شروع شود)
- `optimizer/` — بهینه‌ساز چیدمان. از README آن: نوشته‌شده با C++ و NLopt، اجرا با WebAssembly از طریق Emscripten؛ قبلاً Python/SciPy روی Pyodide بود. سه مرحله: pre-solving (مسئله پیوسته circle-river packing) ← fitting روی شبکه ← tidying.

### نقش در اپ [تحلیل]
موتور اول مرحله D (درخت ← الگوی چین). چون Core جدا از UI و در Worker است، احتمالاً می‌شود آن را جدا استفاده کرد؛ اما وابستگی‌های داخلی (`shared/`، `client/`) بررسی نشده.

---

## 2. TreeMaker 5 (bugfolder/treemaker)

- **مخزن:** https://github.com/bugfolder/treemaker — commit `3b013bff75` (2021-06-28)
- **مجوز:** GNU GPL (به‌جز پوشه `wnlib`)
- **زبان:** C++ با رابط wxWidgets
- همین کد به‌صورت `TreeMaker_src.zip` در پوشه کاربر هم هست. طبق README آن، `Source/tmModel` کل مدل ریاضی را بدون کد GUI دارد و به wxWidgets نیاز ندارد.

### ساختار `Source/tmModel/` (هسته محاسبه، جدا از GUI)
| پوشه | محتوا |
|---|---|
| `tmTreeClasses/` | `tmTree.cpp` (2805 خط)، `tmNode`، `tmEdge`، `tmPath`، `tmPoly` (1497)، `tmCrease`، `tmFacet`، `tmVertex`، و 14 کلاس شرط (`tmConditionNodeSymmetric`، `tmConditionEdgeLengthFixed`، `tmConditionPathAngleQuant`، ...) |
| `tmOptimizers/` | `tmScaleOptimizer`، `tmEdgeOptimizer`، `tmStrainOptimizer`، `tmConstraintFns.cpp` (1672 خط) |
| `tmNLCO/` | حل‌کننده‌های بهینه‌سازی غیرخطی مقید: ALM، CFSQP، RFSQP، wnlib |
| `tmSolvers/` | `tmNewtonRaphson.h`، `tmStubFinder` |

GUI در `Source/tmwxGUI/` است (مثلاً `tmwxDesignCanvas.cpp`، 3017 خط).

### نقش در اپ [تحلیل]
مرجع الگوریتم موتور دوم (circle/river + universal molecule). نیازی به اجرای مستقیم نیست؛ BP Studio فایل TreeMaker 5 را می‌خواند.

---

## 3. ReferenceFinder (MuTsunTsai/reference-finder-cpp)

- **مخزن:** https://github.com/MuTsunTsai/reference-finder-cpp — commit `5c084091cf` (2024-05-28)
- **مجوز:** GNU GPL
- **زبان:** C++ (wxWidgets برای GUI)؛ نسخه وب: https://mutsuntsai.github.io/reference-finder/

### ساختار
- `source/model/ReferenceFinder.cpp` (3901 خط) و `.h` (1112 خط): کلاس‌های `XYPt`، `XYLine`، `Paper`، `RefBase`، `RefMark`، `RefLine`، و یک کلاس برای هر اصل Huzita–Hatori (`RefLine_C2P_C2P` = O1، `RefLine_P2P` = O2، `RefLine_L2L` = O3، ...).
- `source/console/ReferenceFinder_console.cpp` — نسخه خط فرمان.
- `lexer.cpp`، `parser.cpp` — ارزیاب عبارت برای ورودی نمادین.

### نقش در اپ [تحلیل]
پیدا کردن دنباله تا برای رسیدن به نقاط مرجع الگوی طراحی‌شده (مرحله F فاز ۵). نسخه وب نشان می‌دهد هسته به WebAssembly قابل کامپایل است.

---

## 4. scikit-image — skeletonize

- **مخزن:** https://github.com/scikit-image/scikit-image — commit `b700edc800` (2026-10-09)
- **مجوز:** BSD-3-Clause
- `src/skimage/morphology/_skeletonize.py` اکنون فقط wrapper است. **پیاده‌سازی واقعی:** `src/_skimage2/morphology/_skeletonize.py` (656 خط).

### توابع
| تابع | خط | توضیح |
|---|---|---|
| `skeletonize(image, *, method=None)` | 18 | ورودی دودویی؛ روش‌های `zhang` و `lee` |
| `_skeletonize_zhang` | 99 | Zhang–Suen، هسته آن `_fast_skeletonize` در `_skeletonize_various_cy.pyx` |
| `thin` | 257 | نازک‌سازی ریخت‌شناختی |
| `medial_axis` | 361 | محور میانی، با امکان خروجی فاصله |
| `_skeletonize_lee` | 592 | روش Lee (برای سه‌بعدی هم)، هسته در `_skeletonize_lee_cy.pyx.in` |

### نقش در اپ [تحلیل]
مرحله B فاز ۵. برای اجرا در مرورگر: یا بازنویسی Zhang–Suen در TypeScript از روی همین کد، یا Pyodide. `medial_axis` (با فاصله) می‌تواند ضخامت هر شاخه را بدهد که برای تخمین عرض flap مفید است.
