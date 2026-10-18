# منابع فنی — فهرست

**اول این فایل را بخوان**، بعد digest مربوط به فاز کاری را.

## فایل‌ها

| فایل | محتوا |
|---|---|
| `digest-core-libraries.md` | FOLD، Rabbit Ear، Origami Simulator |
| `digest-design-engines.md` | BP Studio، TreeMaker، ReferenceFinder، skeletonize |
| `digest-editors-and-3d.md` | ORIPA، cp-editor، ORI-REVO، Pop Up Card، OrigamiDraw، awesome-origami |
| `ref/fold-spec.md` | مشخصات FOLD 1.2 (کپی بدون تغییر از `fold/doc/spec.md`) |
| `ref/fold-api.md` | API کتابخانه FOLD (کپی از `fold/doc/api.md`) |
| `ref/origamisimulator-readme.md` | README کامل Origami Simulator |
| `origamidraw/` | کد کامل OrigamiDraw (`origamidraw.js`، `index.html`، `README.md`) |
| `samples/` | داده آزمون (جدول پایین) |
| `fetch-sources.sh` | دانلود همه مخزن‌های بیرونی با commit ثابت: `bash sources/fetch-sources.sh <app-repo>/vendor` |

## مستندات دیگر داخل `vendor/` (بعد از اجرای fetch-sources.sh)

| موضوع | مسیر |
|---|---|
| الگوریتم‌های ORIPA | `vendor/oripa/documents/algorithms.md` |
| معماری BP Studio | `vendor/box-pleating-studio/src/core/README.md`، `src/core/design/layout/README.md`، `src/client/plugins/optimizer/src/README.md` |
| کد skeletonize | `vendor/scikit-image/src/_skimage2/morphology/_skeletonize.py` و `_skeletonize_various_cy.pyx` |
| فهرست منابع awesome-origami | `vendor/awesome-origami/README.md` |
| داده آزمون بیشتر | `vendor/rabbit-ear/tests/files/fold/` (93 فایل FOLD)، `vendor/OrigamiSimulator/assets/` |

## جدول مخزن‌ها

| منبع | commit | زبان | فاز اپ |
|---|---|---|---|
| fold (+ npm 0.12.0) | `824f9fa6f9` | CoffeeScript | همه — فرمت داده |
| rabbit-ear (+ npm 0.9.41) | `762f800db1` | JavaScript | ۱، ۲، ۴ — رسم، فلش دیاگرام، پایه‌ها، لایه‌ها |
| OrigamiSimulator | `903ef27afc` | JavaScript/GLSL | ۱، ۴، ۵ — نمایش سه‌بعدی |
| box-pleating-studio | `0496ad070b` | TypeScript/C++ | ۵ — موتور درخت ← الگو |
| treemaker | `3b013bff75` | C++ | ۵ — مرجع الگوریتم درختی |
| reference-finder-cpp | `5c084091cf` | C++ | ۵ — نقاط مرجع |
| scikit-image (skeletonize) | `b700edc800` | Python/Cython | ۵، ۶ — اسکلت‌سازی |
| oripa | `095899f6d8` | Java | ۴، ۵ — محاسبه حالت تاخورده (CLI) |
| cp-editor | `8b711099ca` | CoffeeScript | ۴ — ویرایشگر الگو |
| orirevo | `e408db4fe7` | JavaScript | ۶ — اجسام چرخشی |
| popup_card | `2bb05f6748` | JavaScript | اختیاری |
| awesome-origami | `5466e7515a` | — | فهرست منابع |

## داده نمونه (`samples/`)

| فایل | منبع | محتوا |
|---|---|---|
| `crane-sequence.fold` | rabbit-ear `tests/files/fold/` | **دنباله ۳۷ مرحله‌ای درنا**، یک frame برای هر مرحله |
| `crane-cp.fold`، `crane-step.fold` | rabbit-ear | الگوی چین و یک مرحله درنا |
| `bird-base-3d-cp.fold`، `kraft-bird-base.fold` | rabbit-ear | پایه پرنده |
| `birdBase.svg`، `boatBase.svg`، `frogBase.svg`، `openSinkBase.svg`، `pinwheelBase.svg`، `squareBase.svg`، `waterbombBase.svg` | OrigamiSimulator `assets/Bases/` | الگوی چین پایه‌های کلاسیک |
| `brochurefold.svg`، `mapfold.svg`، `russianTriangle.svg`، `simpleVertex.svg` | OrigamiSimulator `assets/SimpleFolds/` | تاهای ساده |

SVGهای OrigamiSimulator قرارداد رنگ آن برنامه را دارند (کوه/دره/لبه با رنگ stroke، زاویه با opacity).

## یافته‌های مهم

- BP Studio فایل TreeMaker 5 را **می‌خواند** (`src/client/plugins/treeMaker/`) و الگوی چین را به FOLD **صادر می‌کند** (`src/client/plugins/cp/fold.ts`).
- هسته BP Studio یک Web Worker مستقل از UI است با سه کنترلر `design`، `tree`، `layout`.
- ORIPA از خط فرمان الگوی چین را تا می‌زند و خروجی FOLD چند-frame می‌دهد (`--fold`).
- `fold-convert --flat-fold` هم تا زدن تخت را از خط فرمان انجام می‌دهد.
- Rabbit Ear توابع آماده برای پایه‌های کلاسیک و فلش‌های دیاگرام دارد.
- روش Lee در skeletonize برای تصاویر سه‌بعدی هم کار می‌کند (برای فاز ۶).

## منابع روی کامپیوتر کاربر (خارج از git)

`D:\literature\کتاب\Origami\`:
- `متن ها و تصاویر\` — کتاب‌ها و مقاله‌ها. کتاب‌های فاز ۳: **Works of Hideo Komatsu** (اصلی) و **Origami Essence** (دوم).
- `کد ها و برنامه ها\` — `TreeMaker_src.zip`، `FreeformOrigamiX64_1_1.zip` (شامل `model-demo/tessellation.fold` و فایل‌های obj)، `ori-revo-v101-win-64bit.zip` (۱۲ نمونه `.orirevo`)، `ori-ref-v100-win.zip`، `Tess_1.4.exe` + `documentation_1.4.doc`، بسته‌های Mathematica، Doodle، `origamidraw_download.zip`.
- `خارج از موضوع\`، `کتابخانه - کیفیت ناکافی\`، `_to_delete\` — استفاده نشوند.
