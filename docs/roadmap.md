# نقشه راه ساخت اپ اوریگامی — بازبینی بر اساس فایل‌های پوشه

**تاریخ:** ۲۷ مهر ۱۴۰۵ (۱۸ اکتبر ۲۰۲۶)
**پایه:** `origami-app-project-brief.md` (نسخه ۵)، `origami-app-sources.xlsx`، پوشه `sources/` پروژه، و بررسی مستقیم فایل‌های `D:\literature\کتاب\Origami`.
**شماره مراجع:** [1] تا [65] همان شماره‌های سند مبناست. مراجع جدید از [66] شروع می‌شوند (بخش ۷).

> **راهنمای خواندن:** «**[تحلیل]**» یعنی برداشت و پیشنهاد، نه فکت. هر جا فایل را باز نکرده‌ام، صریحاً نوشته‌ام.

---

## به‌روزرسانی ۱ (۲۷ مهر ۱۴۰۵) — این بخش بر بقیه سند مقدم است

**تصمیم‌های کاربر:**
- اعتبارسنجی منابع، ارجاع‌دهی و مجوزها فعلاً کنار گذاشته می‌شود؛ اولویت راه افتادن اپ است. (مراجع بخش ۷ برای سابقه می‌مانند ولی دیگر به‌روز نمی‌شوند.)
- کتابخانه فقط از منابع باکیفیت ساخته می‌شود؛ منبع جدید کتابخانه فعلاً تهیه نمی‌شود.
- کار ساخت به Claude Code سپرده می‌شود؛ پروتکل در `claude/claude-code-handoff.md`.

**ارزیابی نمونه‌های ارسالی برای کتابخانه** (هر سه با «Microsoft Print To PDF» ساخته شده‌اند؛ وضوح فایل اصلی ممکن است بیشتر باشد):

| کتاب | نمونه | وضوح نمونه | ویژگی‌های دیده‌شده | نتیجه |
|---|---|---|---|---|
| **Works of Hideo Komatsu** | ۱ صفحه (اسب) | ۱۳۷ ppi | ستاره دشواری برای هر مدل (★★★★)، اندازه کاغذ، الگوی چین با برچسب زائده‌ها، شماره مراحل درشت، متن انگلیسی + ژاپنی | **کتاب اصلی کتابخانه** — سطح هر مدل از خود کتاب درمی‌آید |
| Origami Essence (Díaz) | ۱ صفحه (قورباغه) | ۲۱۳ ppi | بهترین وضوح، متن اسپانیایی + انگلیسی، «Levels»، نسبت اندازه، الگوی چین | **کتاب دوم** |
| Works of Satoshi Kamiya 1995–2003 | ۷ صفحه (اژدهای باستانی) | ۱۵۰ ppi، فشرده‌سازی JPEG دیده می‌شود | خوانا، ژاپنی + انگلیسی، بسیار پیچیده | بعداً، برای سطح فوق‌پیچیده |

دو فایل Kamiya ارسالی یکسان بودند (هش یکسان).

**ترتیب جدید فاز ۳:** Komatsu ← Origami Essence. کتاب Kirschenbaum فقط اگر برای آزمودن خط لوله برداری لازم شد. بقیه کتاب‌ها فعلاً کنار گذاشته شده‌اند.

**تغییرات پوشه `D:\literature\کتاب\Origami`:**
- `_to_delete\` (برای حذف دستی شما؛ ابزار من اجازه پاک کردن نداشت): فایل خراب fantastic-creatures، نسخه تکراری Animal Origami، نسخه تکراری پوستر Akitaya، فایل mobi کتاب Lang، و `doodle-2.1-win32.zip` (نسخه بازشده‌اش در پوشه هست).
- `خارج از موضوع\`: ۶ مقاله ریاضی تای نوار/نقشه، Folding π، 3D Printing Bistable، مقاله Miura، OMTO، jorigami.
- `کتابخانه - کیفیت ناکافی\`: Insects (عکس گوشی)، Genuine Origami (۷۲ dpi)، Animal Origami for the Enthusiast (۷۵ dpi).
- جابه‌جا نشد: «OMBINATORICS AND ALGEBRA OF n1 CYCLIC STAMP FOLDING.pdf» — نام فایل کاراکتر پنهان دارد و ابزار من آن را پیدا نکرد؛ دستی به `خارج از موضوع` ببرید.

---

## ۱. هدف پروژه (از توضیح پروژه)

اپی که (۱) اوریگامی را از پایه آموزش دهد، (۲) اجرای مدل‌ها را از ساده تا بسیار پیچیده مرحله‌به‌مرحله نشان دهد، و (۳) به کاربر امکان دهد از اجسام دلخواهش اوریگامی طراحی کند. سند مبنا این را به سه بخش تبدیل کرده: کتابخانه مدل‌ها و اجرای مرحله‌ای، راهنمای تاهای پایه، و ابزار طراحی (اولویت ۱: تصویر ← پایه درختی؛ اولویت ۲: مدل سه‌بعدی ← الگوی چین). پروژه شخصی و منتشرنشدنی است.

---

## ۲. روش بررسی و محدودیت آن

- فهرست کامل پوشه و سه زیرپوشه آن خوانده شد.
- فایل‌ها به محیط ابری منتقل و با `pdfinfo`، `pdfimages`، `pdffonts`، `pdftotext`، `unzip` بررسی شدند. از چند کتاب صفحه نمونه رندر و دیده شد.
- **محدودیت:** انتقال فایل‌های بزرگ‌تر از حدود ۲۰ مگابایت با خطای مهلت زمانی متوقف شد. فایل‌هایی که در جدول‌ها «باز نشد» دارند، فقط از روی نام و حجم شناسایی شده‌اند.

---

## ۳. فهرست فایل‌های پوشه

### ۳-۱. کتاب‌های آموزش مدل (دیاگرام)

| فایل (خلاصه نام) | نوع / حجم | چیست | وضعیت فنی PDF (بررسی مستقیم) | مرجع |
|---|---|---|---|---|
| Prehistoric Origami 2021 | PDF / ۲٫۴ MB | M. Kirschenbaum، Fit To Print Publishing، ۲۰۲۱؛ طبق مقدمه کتاب ۱۲ مدل، «تقریباً به ترتیب دشواری» | **برداری**: ۲۹۸ صفحه، فقط ۱۳ تصویر رستری در کل فایل، فونت‌های جاسازی‌شده، متن قابل استخراج. هر صفحه ۱–۲ مرحله | [66] — **در سند مبنا نبود** |
| Prehistoric origami (Montroll) | PDF / ۹ MB | J. Montroll، Dover | اسکن Internet Archive، ۱۲۴ صفحه، لایه خطی JBIG2 با ۳۰۰ dpi، **لایه متن OCR دارد** | [51] |
| complete book of origami (pdf) | PDF / ۱۰٫۸ MB | R. J. Lang، Dover | اسکن Internet Archive، ۱۶۱ صفحه، خاکستری ۱۲۴۰×۱۷۱۳ پیکسل، **لایه متن OCR خوب** (توضیح مراحل خوانا استخراج شد) | [54] |
| The complete book of origami (.mobi) | MOBI / ۲٫۴ MB | همان کتاب Lang | تبدیل خودکار Internet Archive؛ متن خود فایل می‌گوید OCR و ترتیب خواندن ممکن است خطا داشته باشد. ۳۸۰ تصویر کوچک (رایج‌ترین ابعاد ۳۰۹×۴۲۷) | [54] — نسخه تکراری کم‌ارزش‌تر |
| African Animals in Origami | PDF / ۱۵٫۵ MB | J. Montroll، Dover | اسکن تصویری، ۱۱۰ صفحه، خاکستری ۲۰۰ dpi، **بدون لایه متن** | [52] |
| Animal origami for the enthusiast (۲ فایل) | PDF / ۶٫۲ MB ×۲ | J. Montroll، Dover | **دو نسخه یکسان** (حجم و شناسه یکسان در نام). اسکن رنگی ۷۵ dpi، ۱۲۳ صفحه، بدون متن. خوانا ولی کم‌وضوح | [49] |
| ine origami - 43 mathematically-based models | PDF / ۹٫۳ MB | J. Maekawa، *Genuine Origami* | اسکن ۷۲ dpi، ۱۶۰ صفحه، بدون متن. حدود ۲۰ مرحله در صفحه‌ای ۳۷۳ پیکسلی؛ **برای بزرگ‌نمایی مرحله کافی نیست**. سرصفحه‌ها سطح مدل را دارند (مثلاً «Intermediate Models») | [57] |
| Origami Insects and Their Kin | PDF / ۳ MB | R. J. Lang، Dover | ۷۹ صفحه، **عکس گوشی از صفحات باز کتاب**، کج و کم‌وضوح، OCR بی‌معنی. برای برش مرحله قابل استفاده نیست | [55] |
| origami-fantastic-creatures_compress.pdf | ۱۴۸۰ بایت | **فایل خراب**: محتوا صفحه خطای PHP یک سایت دانلود است، نه PDF | — | احتمالاً قرار بوده [53] باشد (حدس از نام؛ تأیید نشده) |
| Origami from Angelfish to Zen | PDF / ۲۵٫۷ MB | P. Engel، Dover | باز نشد | [56] |
| Origami Essence | PDF / ۳۵٫۲ MB | R. Díaz | باز نشد | [59] |
| works of hideo komatsu | PDF / ۳۸٫۲ MB | H. Komatsu | باز نشد. نام فایل سال ۲۰۱۳ دارد؛ سند مبنا ۲۰۱۲ | [60] |
| Works of Satoshi Kamiya 1995-2003 | PDF / ۲۸٫۵ MB | S. Kamiya | باز نشد | [4] |
| Works of Satoshi Kamiya 2 | PDF / ۵۱٫۵ MB | S. Kamiya | باز نشد. فراداده نام فایل (سال ۲۰۰۵، شابک 9780000041944) با سند مبنا (۲۰۱۲) نمی‌خواند؛ احتمالاً فراداده سایت دانلود غلط است | [5] |
| Challenge Origami Paper by Kamiya Rank… | PDF / ۳۶٫۷ MB | شابک نام فایل (9784883377107) با شابک [62] یکسان است ← همان *World of Super-Complex Origami* | باز نشد | [62] |
| Tomoko Fuse's Origami Art | EPUB / ۵۶ MB | T. Fuse، D. Brill، R. Lang؛ Tuttle، ۲۰۲۰ (طبق نام فایل) | باز نشد. موضوع: آثار هندسی و ماژولار، نه حیوانی | [88] — جدید |

**کتاب‌های سند مبنا که در پوشه نیستند:** Origami Sculptures [50]، Dragons and Other Fantastic Creatures [53] (فایلش خراب است)، Origami for Interpreters [58]، Origami Works of Satoshi Kamiya 3 [61].

### ۳-۲. کتاب‌های نظری و طراحی

| فایل | حجم | چیست | مرجع |
|---|---|---|---|
| Origami Design Secrets (2nd ed.) | ۱۱٫۳ MB | Lang — مرجع اصلی روش درختی و box pleating | [1] |
| Tilings, and Tessellations (Lang) | ۴۲۶ MB | *Twists, Tilings, and Tessellations*. شابک نام فایل (9781138563063) با شابک سند مبنا (978-1-56881-232-8) فرق دارد؛ احتمالاً نسخه دیگری از همان کتاب | [2] |
| igami Tessellations (Gjerde) | ۲۰٫۶ MB | *Origami Tessellations*. نام فایل سال ۲۰۰۸ و شابک دیگری دارد | [3] |
| Geometric Folding Algorithms | ۱۱٫۳ MB | Demaine و O'Rourke | [6] |
| rigametry (Hull) | ۱۲٫۴ MB | *Origametry* | [7] |
| 5 - Fifth International Meeting… | ۱۷٫۸ MB | مجموعه مقالات *Origami⁵*؛ مقاله‌های [13] و [44] داخل همین کتاب‌اند | [13], [44] |
| 3D origami art (Mitani) | ۳۶ MB | J. Mitani، CRC — طراحی سه‌بعدی (ORI-REVO و مشابه) | [67] — جدید |
| Curved-Folding Origami Design (Mitani) | ۳۱٫۴ MB | J. Mitani، CRC، ۲۰۱۹. شابک نام فایل (9780071363662) با شابک منتشرشده (978-0-367-18025-6) نمی‌خواند | [68] — جدید |

همه این کتاب‌ها **باز نشد** (حجم زیاد).

### ۳-۳. مقاله‌ها (باز شد مگر ذکر شده باشد)

| فایل | نویسنده و محل انتشار (از خود PDF) | ربط به اپ [تحلیل] | مرجع |
|---|---|---|---|
| A computational algorithm for origami design | Lang، SoCG 1996 | موتور درختی | [9] (باز نشد) |
| 5.0 The Tree Method of Origami Design | ۳۷ صفحه، متن Lang درباره روش درختی و TreeMaker؛ فراداده: «TreeMkrJP.docx». منبع انتشار را پیدا نکردم | موتور درختی | — |
| TreeMkr40.pdf | راهنمای TreeMaker 4.0 | موتور درختی | [39] (باز نشد) |
| Lang_s Universal Molecule Algorithm | Bowers و Streinu | موتور درختی | [45] (باز نشد) |
| Circle Packing for Origami Design Is Hard | Demaine، Fekete، Lang | موتور درختی | [44] (باز نشد) |
| Box Pleating is Hard | Akitaya و همکاران | اعتبارسنجی | [46] (باز نشد) |
| Constituting Origami Models from sketches | Shimanuki و همکاران؛ PDF اسکن بدون متن | تصویر ← درخت | [34] |
| Constituting Feasible Folding Operation… | Shimanuki، Kato، Watanabe؛ MVA2002 | استخراج مراحل از کتاب | [63] |
| Generating Folding Sequences… (۲ فایل) | Akitaya، Mitani، Kanamori، Fukui. **دو فایل از یک پوستر**؛ بایت‌ها متفاوت، عنوان و نویسندگان یکسان | توالی تا | [20] |
| Computer Model and Mouse Interface… | مقاله ژاپنی IPSJ، جلد ۴۸، شماره ۱۲، ۲۰۰۷ | ویرایشگر تای تعاملی | [65] |
| Fast, Interactive Origami Simulation using GPU | Ghassaei و همکاران | نمایش سه‌بعدی | [14] (باز نشد) |
| SimulationOfRigidOrigami / TachiFreeformOrigami2010 / Freeform Variations | Tachi | شبیه‌سازی | [11], [12] (باز نشد) |
| Origamizer… | Demaine و Tachi | سه‌بعدی ← CP | [33] (باز نشد) |
| Method of Packaging… Large Membranes | Miura | مهندسی | [8] (باز نشد) |
| **Folding π** | **Michael Assis**؛ arXiv:2403.09277v3 (۲۰۲۵) | ساخت تقریبی و دقیق عدد π با تا. **ربطی به سه‌بعدی ← CP ندارد** | [30] ← اصلاح لازم، [69] |
| 平織りのホール問題… | R. Nakazato، Y. Yamamoto، J. Mitani؛ IPSJ Journal، ۶۴(۲)، ۶۰۳–۶۱۳، ۲۰۲۳ — حل «مسئله حفره» در تسلیشن | تسلیشن | [70] |
| Computational design methods for… waterbomb tessellations | Y. Zhao و همکاران؛ CAGD ۹۱، ۲۰۲۱ | تسلیشن | [71] |
| Constructing foldable cylindrical surfaces… | Y. Zhao و همکاران؛ JCDE ۹، ۲۰۲۲ | تسلیشن | [72] |
| Interactive Curved Fold Modeling using a Handle Curve | J. Mitani، K. Ohashi؛ CAD&A ۲۰(۲)، ۲۰۲۳ | تای منحنی | [73] |
| Fitting Single Crease Curved-Fold Model… | Y. Watanabe، J. Mitani؛ CAD&A ۱۹(۲)، ۲۰۲۲ | تای منحنی | [74] |
| Geometric Design Tool for One-Fold… | A. Safary، H. Shafieasl، J. Mitani؛ JGG ۲۸(۱)، ۲۰۲۴ | تای منحنی | [75] |
| Parameterized Folded State… Huffman's Ellipse | همان نویسندگان؛ JGG ۲۸(۲)، ۲۰۲۴ | تای منحنی | [76] |
| 3D Printing of Flat-Folded Bistable… | P. Higa، Y. Jia، J. Mitani؛ JGG ۲۸(۱)، ۲۰۲۴ | مهندسی | [77] |
| Logical Matrix Representations in Map Folding | Y. Jia، J. Mitani، R. Uehara؛ IEICE ۲۰۲۲ | ریاضی محض | [78] |
| CATEGORY OF STRIP FOLDING… / MAKING STRIP FOLDING A MONOIDAL CATEGORY / ORDER THEORY IN STRIP FOLDING / HEYTING ALGEBRA IN FLAT ORIGAMI / VALIDITY OF BOUNDARY ORDERS… | همه از Y. Jia و J. Mitani (۲۰۲۲–۲۰۲۵) | ریاضی محض | [79]–[83] |
| OMBINATORICS AND ALGEBRA OF n1 CYCLIC STAMP FOLDING | فایل در فهرست هست اما انتقالش با خطای «وجود ندارد» متوقف شد؛ احتمالاً کاراکتر پنهان در نام. **باز نشد** | ریاضی محض | — |

### ۳-۴. کدها و برنامه‌ها

| فایل | چیست (بررسی مستقیم) | مجوز / اجرا | ربط به اپ [تحلیل] |
|---|---|---|---|
| TreeMaker_src.zip | کد منبع TreeMaker 5 (۶۵۱ فایل). طبق README، پوشه `Source/tmModel` کل مدل ریاضی را **بدون کد رابط کاربری** دارد و به wxWidgets نیاز ندارد | GPL v2 (جز پوشه wnlib) | موتور درختی دوم؛ قابل کامپایل جداگانه |
| TreeMaker5Linux.sh_.zip | نصب‌کننده باینری لینوکس TreeMaker 5 (۲۰۰۶) | GPL | آزمودن خروجی‌ها |
| FreeformOrigamiX64_1_1.zip | Freeform Origami (Tachi) ویندوز ۶۴ بیتی + راهنمای PDF + ۱۹ مدل نمونه (obj، dxf، 3dm، و یک `tessellation.fold`) | اجرایی | داده آزمون برای نمایشگر سه‌بعدی و ورود FOLD |
| ori-ref-v100-win.zip | **ORI-REF**: «ابزار طراحی اوریگامی منحنی بر پایه بازتاب»، J. Mitani، ۲۰۱۱؛ ۱۰ فایل obj نمونه | فقط استفاده شخصی | تای منحنی؛ اختیاری |
| ori-revo-v101-win-64bit.zip | ORI-REVO 1.01 (جاوا) + ۱۲ نمونه `.orirevo` | اجرایی | سه‌بعدی ← CP برای اجسام دوار [48] |
| origami_optimizer-1.0.0.zip | OMTO: بهینه‌ساز توپولوژی سازوکار اوریگامی، MATLAB، K. Fuchi و همکاران، AFRL، ۲۰۱۵ | نیاز به MATLAB Optimization Toolbox | مهندسی؛ خارج از دامنه |
| jorigami-foldcut-diskpacking-1.0beta.zip | برنامه جاوا برای «تا و برش» با بسته‌بندی دیسک (`br.usp.ime.origami.foldcut`) + ۴ نمونه | جاوا | خارج از دامنه |
| doodle-2.1-win32 (zip و پوشه) | Doodle 2.1: زبان توصیف دیاگرام اوریگامی؛ خروجی PostScript؛ J. Gout | خط فرمان | مرجع نمادها و ساختار داده مرحله [27] |
| Tess_1.4.exe + documentation_1.4.doc | Tess، A. Bateman (۲۰۰۷): طراحی تسلیشن با الگوریتم Barreto–Palmer و دو پارامتر «زاویه» و «نسبت» پلیت | اجرایی + مستند | ماژول تسلیشن [85] |
| Origamica-15.0.nb_.zip / Tessellatica-14.2.nb_.zip | بسته‌های Mathematica از R. J. Lang (هر کدام ~۱۶ MB)؛ متن داخل فایل مجوز Creative Commons را ذکر می‌کند | Mathematica | مرجع الگوریتم تسلیشن و هندسه [86] |
| ۳ فایل Demonstration-…nb | Wolfram Demonstrations: «Interactive Rings Tessellation» و «Origami Flanged Pots» (هر دو از R. J. Lang)، و «Origami Bases» (نویسنده را استخراج نکردم) | Mathematica | مرجع |
| WolframPlayer_15_WIN_DLM.exe | نصب‌کننده Wolfram Player | — | اینکه Player بتواند بسته‌های Origamica/Tessellatica را اجرا کند، **اطلاعات موثق ندارم** |
| OriDID_V1.0.zip | ۸۸٫۸ MB؛ **باز نشد**. با جست‌وجوی وب هم هویتش را پیدا نکردم | — | نامعلوم |

### ۳-۵. خروجی‌های هوش مصنوعی

پوشه «بخش ابتدایی…»: `origami-app-project-brief.md`، `origami-app-sources.xlsx`، `origami-app-licensing-notes.md`، `origami-app-licensing-sources.xlsx`، `origami_links.html`. تاریخ این فایل‌ها قدیمی‌تر از نسخه ۵ سند در پروژه است؛ آن‌ها را با نسخه پروژه مقایسه نکردم.

---

## ۴. یافته‌هایی که برنامه را تغییر می‌دهند

1. **کیفیت PDFها یکسان نیست و این تعیین‌کننده است.** سه دسته دیده شد:
   - **برداری با متن** (Kirschenbaum [66]): هر مرحله را می‌توان خودکار به SVG تمیز تبدیل کرد و متن توضیح را مستقیم استخراج کرد.
   - **اسکن خوب با لایه OCR** (Montroll [51]، Lang [54])، و **اسکن خوب بدون متن** (Montroll [52]): برش تصویری با کیفیت قابل قبول؛ شماره مرحله‌ها در دو مورد اول از متن OCR قابل یافتن است.
   - **کم‌وضوح یا عکس** (Maekawa [57] با ۷۲ dpi، Montroll [49] با ۷۵ dpi، Lang [55] عکس گوشی): برای نمایشگر مرحله با بزرگ‌نمایی مناسب نیستند.
2. **فایل خراب و تکراری:** فایل fantastic-creatures خراب است؛ Animal Origami و پوستر Akitaya دو نسخه دارند؛ mobi کتاب Lang نسبت به PDF ارزش افزوده ندارد.
3. **اصلاح سند مبنا:** مرجع [30] (Folding π) نویسنده دارد (Michael Assis) و موضوعش اعداد قابل‌ساخت با تاست، نه «سه‌بعدی به CP / سطوح دوار». باید از آن دسته خارج شود.
4. **منابع تسلیشن قابل‌توجه‌اند:** Tess، Tessellatica، کتاب‌های [2] و [3]، دمو Rings، و مقاله‌های [70]–[72]. **[تحلیل]** این برای یک ماژول اختیاری «تسلیشن» کافی است؛ سند مبنا تسلیشن را در دامنه آورده ولی ماژولی برایش تعریف نکرده بود.
5. **TreeMaker قابل جداسازی است:** هسته ریاضی آن بدون GUI است (طبق README خود کد). **[تحلیل]** کامپایل آن به WebAssembly (مثلاً با Emscripten) راهی برای استفاده در اپ وب است؛ این را آزمایش نکرده‌ام.
6. **داده آزمون آماده وجود دارد:** دنباله ۳۷ مرحله‌ای درنا (`crane-sequence.fold`)، پایه‌های کلاسیک در SVG (پوشه `sources/samples` پروژه)، `tessellation.fold` در Freeform Origami، و نمونه‌های ORI-REVO.

---

## ۵. ترتیب بازبینی‌شده ساخت **[تحلیل]**

ترتیب پیشنهادی جلسه قبل در کل حفظ شد، با چهار تغییر: (الف) فاز صفر برای مدل داده و پاک‌سازی محتوا؛ (ب) کتابخانه مدل‌ها با یک کتاب برداری به‌عنوان آزمایش شروع شود؛ (ج) داده سه‌بعدی فقط برای مدل‌های همان کتاب‌های آزمایشی؛ (د) ماژول تسلیشن به‌عنوان فاز اختیاری آخر.

**دلیل اینکه ابزار طراحی بعد از کتابخانه می‌آید با اینکه اولویت ۱ طراحی است:** خروجی ابزار طراحی الگوی چین است و برای دیده شدن به همان نمایشگر FOLD و سه‌بعدی فاز ۱ نیاز دارد. فاز ۵ فقط به فاز ۱ وابسته است؛ اگر طراحی برایتان فوری‌تر است، می‌توانید آن را بلافاصله بعد از فاز ۱ شروع کنید. این تصمیم با شماست.

```
فاز ۰ ← فاز ۱ ← فاز ۲ ← فاز ۳ ← فاز ۴
               └──────────→ فاز ۵ ← فاز ۶      (فاز ۷ اختیاری)
```

### فاز ۰: مدل داده و آماده‌سازی محتوا

| | |
|---|---|
| **کار** | تعریف قالب داده؛ فهرست کتاب‌ها با «رده کیفیت»؛ جایگزینی فایل‌های خراب و کم‌کیفیت |
| **داده** | ساختار Model / Step / Progress از بخش ۷-۵ سند مبنا؛ هر Step یک فریم FOLD اختیاری دارد [16], [17] |
| **منبع** | مشخصات FOLD 1.2 (`sources/ref-fold-spec.md`)؛ جدول ۳-۱ همین سند |
| **روش** | ۱) یک فایل JSON Schema برای Model و Step. ۲) جدول کتاب‌ها با ستون «رده کیفیت»: الف = برداری، ب = اسکن ≥۲۰۰ dpi، ج = کم‌وضوح. ۳) دانلود دوباره Dragons [53] و تهیه نسخه بهتر از [49]، [55]، [57] در صورت امکان. ۴) حذف نسخه‌های تکراری از فهرست کار |

### فاز ۱: هسته نمایش

| | |
|---|---|
| **کار** | خواندن FOLD، رسم الگوی چین، نمایش سه‌بعدی، پخش فریم‌به‌فریم |
| **داده** | `crane-sequence.fold`، `crane-cp.fold`، SVGهای پایه‌ها (پوشه `sources/samples`)، `tessellation.fold` از Freeform Origami |
| **منبع** | کتابخانه FOLD [17]، Rabbit Ear [18]، Origami Simulator [15]؛ خلاصه فنی در `sources/digest-core-libraries.md` |
| **روش** | اپ وب با TypeScript. ۱) بارگذاری FOLD با کتابخانه FOLD. ۲) رسم دوبعدی CP و فریم‌ها با Rabbit Ear. ۳) پنل سه‌بعدی بر پایه کد Origami Simulator. ۴) دکمه قبلی/بعدی روی `file_frames`. **معیار پایان:** درنای ۳۷ مرحله‌ای کامل پخش شود. نکته: Origami Simulator همه چین‌ها را هم‌زمان تا می‌زند [15]؛ برای نمایش مرحله‌ای هر فریم باید جدا بارگذاری شود |

### فاز ۲: راهنمای تاهای پایه

| | |
|---|---|
| **کار** | آموزش نمادهای دیاگرام، تاهای پایه (دره، کوه، معکوس، squash، petal، rabbit ear، sink) و پایه‌های کلاسیک |
| **داده** | پایه‌های آماده Rabbit Ear (`bird`، `frog`، `fish`، `waterbomb`، `kite`، `blintz`، `windmill`، `squareFish`)؛ SVGهای Origami Simulator؛ فصل‌های مقدماتی نمادها در کتاب‌های [54] و [51] (متن OCR دارند) |
| **منبع** | [18], [15]؛ Doodle [27] و OrigamiDraw [28] برای واژگان نمادها |
| **روش** | هر تا یا پایه = یک فایل FOLD چندفریمی که در فاز ۱ پخش می‌شود + توضیح دوزبانه. فریم‌ها با ویرایشگر CP [47] یا ORIPA [31] ساخته و با `fold-convert --flat-fold` یا خط فرمان ORIPA بررسی می‌شوند (`sources/digest-editors-and-3d.md`) |

### فاز ۳: کتابخانه مدل‌ها و اجرای مرحله‌ای (نسخه تصویری)

| | |
|---|---|
| **کار** | تبدیل صفحات کتاب به مراحل، فراداده مدل، مسیر «دسته ← سطح ← مدل» |
| **ترتیب کتاب‌ها** | ۳-الف: Kirschenbaum [66] (برداری، ۱۲ مدل، به ترتیب دشواری) ← ۳-ب: Montroll Prehistoric [51] و Lang Complete [54] (OCR دارند) ← ۳-ج: African Animals [52] ← ۳-د: کتاب‌های بازنشده پس از بررسی کیفیت ← رده ج فقط در صورت نبود جایگزین |
| **منبع** | بخش ۷ سند مبنا؛ پشتوانه پژوهشی خودکارسازی [63], [34] |
| **روش برای رده الف** | استخراج هر صفحه به SVG (مثلاً `pdftocairo -svg` یا PyMuPDF)؛ یافتن شماره مرحله‌ها از متن («8.»، «9.») و برش کادر هر مرحله؛ متن کنار شماره = توضیح انگلیسی مرحله |
| **روش برای رده ب** | استخراج تصویر صفحه با وضوح اصلی (`pdfimages`)؛ پیشنهاد خودکار کادرها با OpenCV (اجزای متصل)؛ برچسب‌گذاری کادرها با شماره مرحله از متن OCR؛ اصلاح دستی در ابزار کادرکشی |
| **فراداده** | سطح هر مدل را خودتان تعیین می‌کنید (بخش ۷-۲ سند مبنا). کمک موجود: ترتیب دشواری در Kirschenbaum (طبق مقدمه کتاب) و سرصفحه سطح در Maekawa |
| **ترجمه** | توضیح فارسی دستی یا با کمک هوش مصنوعی و بازبینی شما |

### فاز ۴: مدل سه‌بعدی همگام برای مدل‌های منتخب

| | |
|---|---|
| **کار** | ساخت دنباله فریم FOLD برای مدل‌های ساده‌تر کتاب‌های فاز ۳-الف و ۳-ب |
| **داده** | دیاگرام همان مدل‌ها + الگوی چین نهایی (اگر کتاب داده باشد) |
| **منبع** | ساختار داده دنباله الگو [64]؛ ویرایشگر تعاملی [65]؛ توالی تا [20]؛ نمونه `crane-sequence.fold` |
| **روش** | ۱) ساخت CP هر مرحله در ویرایشگر CP. ۲) محاسبه حالت تاخورده با ORIPA یا `fold-convert`. ۳) ذخیره به‌عنوان فریم‌های یک فایل FOLD. ۴) اتصال فریم k به Step k در کتابخانه. از مدل‌هایی با مراحل کم شروع کنید؛ برای مدل‌های پیچیده بسیار زمان‌بر است |

### فاز ۵: ابزار طراحی ۱ — تصویر ← پایه درختی

| | |
|---|---|
| **کار** | خط لوله A تا F بخش ۳-۲ سند مبنا |
| **داده** | سیلوئت سوژه؛ مدل‌های کتاب‌ها به‌عنوان نمونه آزمون؛ فایل‌های TreeMaker |
| **منبع** | اسکلت‌سازی [42], [43] (`sources/ref-skeletonize-zhang-suen.md`)؛ [34]؛ موتور ۱: BP Studio [40] (MIT، هسته Web Worker، فایل TreeMaker 5 را می‌خواند و FOLD صادر می‌کند — `sources/digest-design-engines.md`)؛ موتور ۲: `tmModel` از TreeMaker_src.zip [38]؛ نظریه: [1], [9], [39], [44], [45] و متن «5.0 The Tree Method» |
| **روش** | ۱) سیلوئت با کمک کاربر. ۲) skeletonize و تبدیل به گراف؛ حذف شاخه‌های زائد. ۳) ویرایش درخت و طول شاخه‌ها توسط کاربر. ۴) ارسال درخت به هسته BP Studio و دریافت CP. ۵) نمایش در فاز ۱ و بررسی تخت‌تاشدنی. موتور TreeMaker فقط اگر box pleating کافی نبود |
| **محدودیت** | خروجی «پایه» است نه مدل نهایی (بخش ۳-۴ سند مبنا) |

### فاز ۶: ابزار طراحی ۲ — مدل سه‌بعدی ← الگوی چین

| | |
|---|---|
| **کار** | سه زیرمسیر به ترتیب سادگی |
| **۶-الف: اجسام دوار** | ORI-REVO (مخزن JS با مجوز MIT در `sources/manifest.json` + نسخه جاوا و ۱۲ نمونه در پوشه) [48]؛ کتاب Mitani [67] به‌عنوان پشتوانه نظری (کتاب را باز نکرده‌ام) |
| **۶-ب: اسکلت سه‌بعدی ← درخت** | راه ۴-ب سند مبنا؛ روش Lee در skeletonize تصویر سه‌بعدی را هم می‌پذیرد (`sources/00-index.md`). برای این ترکیب منبع منتشرشده پیدا نکردم |
| **۶-ج: چندوجهی عمومی** | Origamizer [33], [36], [37]؛ Freeform Origami برای مقایسه و نمونه‌ها [35] |
| **اختیاری** | تای منحنی: ORI-REF، کتاب [68] و مقاله‌های [73]–[76] |

### فاز ۷ (اختیاری): ماژول تسلیشن

منابع: Tess [85] (الگوریتم زاویه/نسبت پلیت)، Tessellatica [86]، کتاب‌های [2] و [3]، مقاله‌های [70]–[72]. **[تحلیل]** پیاده‌سازی الگوریتم Tess ساده‌ترین شروع است، چون دو پارامتر دارد و مستندش در پوشه هست.

### خارج از دامنه فعلی

OMTO و jorigami، مقاله‌های ریاضی محض [78]–[83]، و [8], [77] (مهندسی). نگه داشتنشان در پوشه ضرری ندارد ولی در ساخت اپ نقشی ندارند.

---

## ۶. اقدام‌های فوری **[تحلیل]**

1. دانلود دوباره کتاب Dragons [53] و بررسی کتاب‌های غایب [50], [58], [61].
2. اصلاح ردیف [30] در فایل اکسل.
3. شروع فاز ۰ و ۱ در جلسه ابری (به GitHub و npm دسترسی مستقیم دارد).
4. برای ارزیابی کتاب‌های بزرگ بازنشده (Engel، Díaz، Komatsu، Kamiya): یا چند صفحه نمونه از هر کدام به‌صورت فایل جدا پیوست کنید، یا در جلسه‌ای که پوسته کامپیوتر شما فعال است بررسی شوند.

---

## ۷. مراجع جدید (IEEE)

[66] M. Kirschenbaum, *Prehistoric Origami*. Fit To Print Publishing, 2021. [Online]. Available: https://giladorigami.com/origami-database-book/3957/Prehistoric-Origami-by-Marc-Kirschenbaum

[67] J. Mitani, *3D Origami Art*. Boca Raton, FL, USA: CRC Press, ISBN 978-1-4987-6534-3. (سال: نام فایل ۲۰۱۶؛ کاتالوگ کتابخانه بریتانیا ۲۰۱۷.) [Online]. Available: https://mitani.cs.tsukuba.ac.jp/book/3d_origami_art

[68] J. Mitani, *Curved-Folding Origami Design*. Boca Raton, FL, USA: CRC Press, 2019, ISBN 978-0-367-18025-6. [Online]. Available: https://eld.bl.uk/catalog/019327345

[69] M. Assis, "Folding π," arXiv:2403.09277v3, May 2025. [Online]. Available: https://arxiv.org/abs/2403.09277

[70] R. Nakazato, Y. Yamamoto, and J. Mitani, "Method for generating crease patterns satisfying the local flat-foldability conditions to solve origami tessellation hole problem," *IPSJ Journal*, vol. 64, no. 2, pp. 603–613, Feb. 2023 (in Japanese). لینک تأییدشده ندارم.

[71] Y. Zhao *et al.*, "Computational design methods for cylindrical and axisymmetric waterbomb tessellations," *Computer Aided Geometric Design*, vol. 91, Art. no. 102037, 2021, doi: 10.1016/j.cagd.2021.102037. [Online]. Available: https://doi.org/10.1016/j.cagd.2021.102037

[72] Y. Zhao *et al.*, "Constructing foldable cylindrical surfaces via unfolded waterbomb origami units," *J. Computational Design and Engineering*, vol. 9, pp. 1498–1510, 2022, doi: 10.1093/jcde/qwac062. [Online]. Available: https://doi.org/10.1093/jcde/qwac062

[73] J. Mitani and K. Ohashi, "Interactive curved fold modeling using a handle curve," *Computer-Aided Design & Applications*, vol. 20, no. 2, pp. 275–289, 2023, doi: 10.14733/cadaps.2023.275-289. [Online]. Available: https://doi.org/10.14733/cadaps.2023.275-289

[74] Y. Watanabe and J. Mitani, "Fitting single crease curved-fold model to the user specified points," *Computer-Aided Design & Applications*, vol. 19, no. 2, pp. 387–404, 2022, doi: 10.14733/cadaps.2022.387-404. [Online]. Available: https://doi.org/10.14733/cadaps.2022.387-404

[75] A. Safary, H. Shafieasl, and J. Mitani, "Geometric design tool for One-Fold, a curved origami with a single fold," *J. Geometry and Graphics*, vol. 28, no. 1, pp. 89–101, 2024. لینک تأییدشده ندارم.

[76] A. Safary, H. Shafieasl, and J. Mitani, "Parameterized folded state shape modeling of David Huffman's ellipse," *J. Geometry and Graphics*, vol. 28, no. 2, pp. 199–212, 2024. لینک تأییدشده ندارم.

[77] P. Higa, Y. Jia, and J. Mitani, "3D printing of flat-folded bistable origami-like structures," *J. Geometry and Graphics*, vol. 28, no. 1, pp. 103–116, 2024. لینک تأییدشده ندارم.

[78] Y. Jia, J. Mitani, and R. Uehara, "Logical matrix representations in map folding," *IEICE Trans. Fundamentals*, vol. E105-A, no. 10, pp. 1401–, Oct. 2022 (صفحه پایان را استخراج نکردم). لینک تأییدشده ندارم.

[79] Y. Jia and J. Mitani, "Category of strip folding in terms of a boolean matrix representation," *JP J. Algebra, Number Theory and Applications*, vol. 58, pp. 19–36, 2022, doi: 10.17654/0972555522032. [Online]. Available: http://dx.doi.org/10.17654/0972555522032

[80] Y. Jia and J. Mitani, "Making strip folding a monoidal category," *JP J. Algebra, Number Theory and Applications*, vol. 61, no. 1, pp. 1–18, 2023, doi: 10.17654/0972555523008. [Online]. Available: http://dx.doi.org/10.17654/0972555523008

[81] Y. Jia and J. Mitani, "Order theory in strip folding," *JP J. Algebra, Number Theory and Applications*, vol. 62, no. 1, pp. 13–34, 2023, doi: 10.17654/0972555523019. [Online]. Available: http://dx.doi.org/10.17654/0972555523019

[82] Y. Jia and J. Mitani, "Heyting algebra in flat origami," *JP J. Algebra, Number Theory and Applications*, vol. 63, no. 5, pp. 383–396, 2024, doi: 10.17654/0972555524023. [Online]. Available: https://doi.org/10.17654/0972555524023

[83] Y. Jia and J. Mitani, "Validity of boundary orders in flat-folding 1-diagonal grid patterns," *Advances and Applications in Discrete Mathematics*, vol. 42, no. 7, pp. 621–642, 2025, doi: 10.17654/0974165825040. [Online]. Available: https://doi.org/10.17654/0974165825040

[84] K. Fuchi *et al.*, *Guide to the Origami Mechanism Topology Optimizer v1.0*. Wright-Patterson AFB, OH, USA: Air Force Research Labs, 2015 (راهنمای داخل origami_optimizer-1.0.0.zip). لینک تأییدشده ندارم.

[85] A. Bateman, *The Tess Program: Documentation*, ver. 1.4, 2007 (documentation_1.4.doc). [Online]. Available: https://origamitessellations.com/2007/01/new-version-of-tess-alex-batemans-origami-tessellation-software

[86] R. J. Lang, "Tessellatica," langorigami.com. [Online]. Available: https://langorigami.com/article/tessellatica/

[87] J. Mitani, *ORI-REF: A Design Tool for Curved Origami based on Reflection*, ver. 1.00, 2011 (readme داخل ori-ref-v100-win.zip). لینک تأییدشده ندارم.

[88] T. Fuse, D. Brill, and R. J. Lang, *Tomoko Fuse's Origami Art: Works by a Modern Master*, 2nd ed. Tuttle Publishing, 2020 (اطلاعات از نام فایل؛ تأیید نشده). لینک تأییدشده ندارم.
