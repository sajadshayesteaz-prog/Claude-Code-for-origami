# Task 002 — Basic folds guide (Phase 2) + small fixes + Komatsu check

> خلاصه فارسی: ساخت بخش «راهنمای تاهای پایه» (نمادها، تاهای پایه، پایه‌های کلاسیک) روی همان نمایشگر کار ۰۰۱، چند اصلاح کوچک، و سنجش کیفیت فایل اصلی کتاب Komatsu برای فاز ۳. محتوای آموزشی (فهرست و متن‌های فارسی/انگلیسی) در همین برگه آمده است.

**Work in:** Origami-App. **Report to:** comms repo (`docs/reports/002-basic-folds-guide.md`, STATUS, decisions). **Runs on:** the owner's PC (part C needs the book PDF).

## Review of task 001 (from claude.ai)
Accepted. Build and `validate:data` were re-run independently in the cloud; a headless browser stepped the crane 1→10→37 in Persian mode and both views updated. Answers to your open questions:
- **Animation between frames:** not needed now. Decide in Phase 4.
- **PWA / IndexedDB:** not yet. IndexedDB comes with the library (Phase 3).
- **`npm audit` on `@xmldom/xmldom`:** ignore for now.

---

## Part A — Small fixes
1. Add `run-dev.bat` at the repo root that prepends `%LOCALAPPDATA%\Programs\nodejs` to PATH for that window, runs `npm install` if `node_modules` is missing, then `npm run dev` and opens http://localhost:5173. UTF-8 safe (`chcp 65001`).
2. The fold-percent slider: in RTL the thumb sits on the left at 100%, which reads as 0%. Force `dir="ltr"` on the range input (keep the label RTL).
3. Default language: Persian on first visit (keep the stored choice afterwards). Confirm current behaviour and make it explicit.

## Part B — Basic folds guide (main work)

### B1. App structure
Add simple navigation with three entries: **راهنمای تاها / Folds guide** (this task), **نمایشگر / Viewer** (task 001, keep as-is), **کتابخانه / Library** (placeholder page "به‌زودی / Coming soon").

Guide page layout: a list of lessons grouped into three sections (B2–B4). Selecting a lesson shows: title, short text (fa/en), and the existing viewer (2D + 3D + step controls) loaded with that lesson's FOLD file. Each step may have its own one-line caption (`frame_title` in FOLD, fa/en — store as `frame_title` = English and a custom `frame_fa_title` = Persian, or another convention you record in decisions.md).

Lesson data lives in `data/guide/`: one `guide.json` (ordered list of lessons with id, section, titles, texts, FOLD path) + one `.fold` per lesson. Add a JSON Schema for `guide.json` and include it in `npm run validate:data`.

### B2. Section 1 — Diagram symbols (static, no 3D)
Render each symbol as SVG (use `sources/origamidraw/origamidraw.js` and/or Rabbit Ear `diagrams/` arrows as drawing references). One lesson containing all symbols as a table is fine.

| id | fa | en | Text fa | Text en |
|---|---|---|---|---|
| sym-valley | خط تای دره | Valley-fold line | کاغذ را به سمت خودت تا کن تا یک «دره» درست شود. با خط‌چین نشان داده می‌شود. | Fold the paper towards you, forming a valley. Drawn as a dashed line. |
| sym-mountain | خط تای کوه | Mountain-fold line | کاغذ را به پشت تا کن تا یک «کوه» درست شود. با خط‌چین‌نقطه نشان داده می‌شود. | Fold the paper away from you, forming a ridge. Drawn as a dash-dot line. |
| sym-crease | چین موجود | Existing crease | چینی که قبلاً زده شده و الان باز است. با خط نازک پیوسته نشان داده می‌شود. | A crease made earlier and now unfolded. Drawn as a thin solid line. |
| sym-xray | خط پنهان | X-ray line | لبه یا چینی که پشت لایه‌های جلویی است. با خط‌چین ریز نشان داده می‌شود. | An edge or crease hidden behind front layers. Drawn as a fine dotted line. |
| sym-fold-arrow | فلش تا | Fold arrow | جهت حرکت کاغذ. سر توپر: تای دره؛ سر توخالی: تای کوه. | Direction the paper moves. Solid head: valley fold; hollow head: mountain fold. |
| sym-unfold | تا کن و باز کن | Fold and unfold | فلش دوطرفه: تا بزن، چین را محکم کن، و دوباره باز کن. | Double-headed arrow: fold, crease firmly, unfold. |
| sym-turn-over | برگرداندن | Turn over | مدل را پشت‌ورو کن. | Turn the model over. |
| sym-rotate | چرخاندن | Rotate | مدل را در همان صفحه به اندازه زاویه نشان‌داده‌شده بچرخان. | Rotate the model in the plane by the angle shown. |
| sym-push | فشار / فرو بردن | Push / sink | اینجا را فشار بده یا به داخل فرو ببر. | Push here or sink inwards. |
| sym-repeat | تکرار | Repeat | همین مراحل را در طرف دیگر یا پشت تکرار کن. | Repeat the steps on the other side or behind. |
| sym-zoom | بزرگ‌نمایی | Enlarged view | مرحله بعد بزرگ‌تر کشیده شده است. | The next drawing is shown larger. |

### B3. Section 2 — Basic folds (multi-frame FOLD, with 3D)
Build each as a FOLD file with `file_frames` (one frame per step). Use Rabbit Ear (`graph/fold/flatFold.js`, `simpleFold.js`, `reverseFold.js`, `squashFold.js`, `pleat.js`) and `fold/bases.js`; check folded states with `fold-convert --flat-fold` or ORIPA CLI where helpful. Start from a square unless noted. Where generating a fold programmatically is not feasible (sinks are the likely case), ship the start and end crease patterns as 2 frames, and say so in the report.

| id | fa | en | Text fa | Text en |
|---|---|---|---|---|
| fold-valley | تای دره | Valley fold | یک لبه را روی لبه مقابل بیاور و چین را صاف کن. | Bring one edge onto the opposite edge and flatten the crease. |
| fold-mountain | تای کوه | Mountain fold | مثل تای دره، ولی کاغذ به پشت تا می‌شود. | Like a valley fold, but the paper folds behind. |
| fold-preCrease | پیش‌چین (تا و باز) | Pre-crease | تا بزن، محکم کن و باز کن تا یک خط راهنما بماند. | Fold, crease firmly and unfold, leaving a guide line. |
| fold-insideReverse | تای معکوس داخلی | Inside reverse fold | لبه‌ها را باز کن و نوک را در امتداد چین به داخل بین لایه‌ها ببر. | Open the layers and push the point inside along the crease. |
| fold-outsideReverse | تای معکوس خارجی | Outside reverse fold | لایه‌ها را باز کن و نوک را از بیرون دور لایه‌ها برگردان. | Open the layers and wrap the point around the outside. |
| fold-squash | تای له‌کردنی | Squash fold | یک زائده را بلند کن، بازش کن و به‌طور متقارن صاف کن. | Lift a flap, open it and flatten it symmetrically. |
| fold-petal | تای گلبرگی | Petal fold | دو لبه را به خط وسط بیاور، بالا را باز کن و لایه زیرین را به بالا بکش تا یک زائده بلند ساخته شود. | Bring two edges to the centre, then lift the bottom layer up so the sides fold in, forming a long flap. |
| fold-rabbitEar | گوش خرگوشی | Rabbit-ear fold | دو لبه یک مثلث را هم‌زمان روی نیمساز تا کن تا یک زائده کوچک بیرون بزند. | Fold two edges of a triangle to the bisector at once, so a small flap stands out. |
| fold-swivel | تای چرخشی | Swivel fold | یک تای دره که بخشی از کاغذ را حول یک نقطه می‌چرخاند. | A valley fold that swings part of the paper around a point. |
| fold-pleat | تای پلیسه | Pleat | یک تای دره و یک تای کوه موازی پشت هم. | A valley fold and a mountain fold side by side. |
| fold-crimp | تای کریمپ | Crimp | پلیسه‌ای که از دو لایه هم‌زمان رد می‌شود؛ برای خم کردن یک زائده. | A pleat through both layers at once; used to bend a flap. |
| fold-openSink | فرو بردن باز | Open sink | نوک را باز کن و به داخل فرو ببر، سپس دوباره صاف کن. | Open the point, push it inside, then flatten again. |

### B4. Section 3 — Classic bases (multi-frame FOLD from a square, with 3D)
Each base as a full folding sequence from the square. `sources/samples/` has final crease patterns for bird, frog, square, waterbomb (SVG) and `kraft-bird-base.fold`; Rabbit Ear `bases.js` has `kite`, `fish`, `bird`, `frog`, `waterbomb`, `blintz`, `windmill`, `squareFish`.

| id | fa | en | Text fa | Text en |
|---|---|---|---|---|
| base-kite | پایه بادبادک | Kite base | دو لبه را روی قطر تا کن. ساده‌ترین پایه. | Fold two edges to the diagonal. The simplest base. |
| base-fish | پایه ماهی | Fish base | از پایه بادبادک، دو گوش خرگوشی؛ چهار زائده دارد. | From the kite base, two rabbit ears; it has four flaps. |
| base-square | پایه مربع (مقدماتی) | Square (preliminary) base | قطرها کوه، میانه‌ها دره؛ کاغذ را جمع کن تا مربعی کوچک و چندلایه شود. | Diagonals mountain, midlines valley; collapse into a small layered square. |
| base-waterbomb | پایه بمب آبی | Waterbomb base | برعکس پایه مربع: قطرها دره، میانه‌ها کوه؛ مثلثی چندلایه. | Opposite of the square base: diagonals valley, midlines mountain; a layered triangle. |
| base-bird | پایه پرنده | Bird base | از پایه مربع، روی هر دو طرف تای گلبرگی. پایه درنا. | From the square base, petal-fold both sides. The base of the crane. |
| base-frog | پایه قورباغه | Frog base | از پایه مربع، چهار تای له‌کردنی و چهار تای گلبرگی. | From the square base, four squash folds and four petal folds. |
| base-blintz | تای بلینتز | Blintz | هر چهار گوشه را به مرکز تا کن. | Fold all four corners to the centre. |
| base-windmill | پایه آسیاب بادی | Windmill base | از دو لبه به وسط تا کن، سپس گوشه‌ها را بیرون بکش و صاف کن. | Fold edges to the centre, then pull the corners out and flatten. |

### B5. 2D folded view (diagram style)
The 2D panel currently shows each frame's crease pattern (unfolded). For teaching, add a toggle **الگوی چین / Crease pattern ↔ حالت تاخورده / Folded** that draws the frame's flat-folded form (use Rabbit Ear's folded-vertices function in `graph/vertices/folded.js`, and its layer solver if needed for correct overlap; front face coloured, back face white). If layer ordering is not reliable for some frames, show the folded outline without layers and note it.

## Part C — Komatsu resolution check (prerequisite for Phase 3)
Book: `$ORIGAMI_LIBRARY_DIR/متن ها و تصاویر/works of hideo komatsu -- hideo komatsu -- 2013 -- 9dcc060f01627818cb63c35e64a2ae66 -- Anna’s Archive.pdf`. Do the same for Origami Essence (`Origami Essence -- Roman Diaz -- ...pdf`).

Write `tools/pdf-inspect.py` (PyMuPDF) that reports: page count, page size, for each page the embedded image size and effective DPI, whether there is a text layer. Summarise (min/median/max DPI, colour/grey). Render 3 diagram pages at native resolution to `$COMMS_DIR/docs/reports/assets/002/` (PNG, keep under ~1 MB each) so claude.ai can judge legibility. Put the summary table in the report.

## Acceptance criteria
- [ ] `run-dev.bat` starts the app from a fresh Explorer double-click.
- [ ] Slider fix and default-language behaviour verified in fa and en.
- [ ] Navigation with three entries; Library is a placeholder.
- [ ] Symbols lesson shows all 11 symbols with fa/en text.
- [ ] All 12 basic folds and 8 bases load; each step updates 2D and 3D; per-step captions show in the current language. List any lesson that had to fall back to start/end frames only.
- [ ] 2D toggle CP ↔ folded works on the crane sample and on at least the bird base.
- [ ] `npm run validate:data` covers `guide.json` and passes.
- [ ] Komatsu and Essence inspection tables + 3 sample PNGs each in the report.
- [ ] Code pushed to Origami-App; report, STATUS and decisions pushed to the comms repo.

## Out of scope
Library pipeline (Phase 3), PWA, IndexedDB, mobile packaging, design polish beyond legibility.
