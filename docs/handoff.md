# پروتکل کار: پروژه claude.ai ⇄ Claude Code

**تاریخ:** ۲۷ مهر ۱۴۰۵ (۱۸ اکتبر ۲۰۲۶)
**تصمیم‌های کاربر:** اعتبارسنجی منابع، ارجاع‌دهی و مجوزها فعلاً کنار گذاشته می‌شوند؛ اولویت راه افتادن اپ است. کتابخانه فقط از منابع باکیفیت (Komatsu، سپس Origami Essence).

---

## ۱. دو مخزن

| مخزن | نقش | چه چیزی داخلش است |
|---|---|---|
| **Claude-Code-for-origami** (همین مخزن) | **ارتباط** | سند مبنا، نقشه راه، برگه‌های کار، گزارش‌ها، وضعیت، تصمیم‌ها، منابع فنی و داده آزمون |
| **Origami-App** (خصوصی) | **کد اپ** | `CLAUDE.md`، اپ، ابزارها، داده کتابخانه |

**روی کامپیوتر کاربر، هر دو کنار هم clone می‌شوند:**
```
D:\dev\Claude-Code-for-origami\
D:\dev\Origami-App\
```
Claude Code در `Origami-App` باز می‌شود و طبق `CLAUDE.md` آن، مخزن ارتباطی را از `../Claude-Code-for-origami` می‌خواند (یا از مسیر `COMMS_DIR` در `.env`).

---

## ۲. تقسیم کار

| کجا | چه کاری | خروجی |
|---|---|---|
| **پروژه claude.ai** | تصمیم‌گیری، انتخاب مدل‌ها، نوشتن برگه کار، بازبینی گزارش‌ها، به‌روزرسانی نقشه راه | فایل‌های `docs/` در مخزن ارتباطی |
| **Claude Code** | ساختن کد، اجرای خط لوله‌ها روی PDFها، تست | کد در Origami-App + گزارش در مخزن ارتباطی |
| **کاربر** | اجرای Claude Code، تأیید، تا زدن آزمایشی و نظر دادن | — |

جلسه‌های پروژه claude.ai هر دو مخزن را مستقیم از GitHub می‌خوانند؛ کپی دستی لازم نیست.

---

## ۳. چرخه هر کار

1. **claude.ai:** برگه `docs/tasks/NNN-name.md` در مخزن ارتباطی نوشته و push می‌شود.
2. **کاربر:** در هر دو پوشه `git pull`، سپس در Claude Code (داخل Origami-App): «برگه کار NNN را اجرا کن.»
3. **Claude Code:** کد را در Origami-App می‌سازد و push می‌کند؛ `docs/reports/NNN-name.md`، `docs/STATUS.md` و `docs/decisions.md` را در مخزن ارتباطی می‌نویسد و push می‌کند.
4. **claude.ai:** گزارش و کد را بازبینی می‌کند و برگه بعدی را می‌نویسد.

---

## ۴. فازها: ابزار، ورودی، خروجی، پیش‌نیاز

| فاز | کجا اجرا | ورودی | خروجی | منبعی که در شروع همین فاز باید تهیه شود |
|---|---|---|---|---|
| ۰. راه‌اندازی و مدل داده | Claude Code (هر جا) | `docs/`، `sources/` | ساختار Origami-App، `vendor/`، JSON Schema، اسکلت اپ | — |
| ۱. هسته نمایش | Claude Code (هر جا) | `sources/digest-core-libraries.md`، `sources/samples/` | نمایشگر دوبعدی + سه‌بعدی + پخش فریم؛ معیار: درنای ۳۷ مرحله‌ای | — |
| ۲. راهنمای تاهای پایه | claude.ai: فهرست تاها و متن · Claude Code: ساخت | `bases.js` در Rabbit Ear، SVGهای پایه، `sources/origamidraw/`، Doodle | فایل FOLD چندفریمی برای هر تا/پایه + صفحه آموزش | — (OrigamiDraw اکنون در `sources/origamidraw/` است) |
| ۳. کتابخانه مدل‌ها | Claude Code **روی کامپیوتر کاربر** | کتاب Komatsu، سپس Origami Essence | ابزار PDF ← کادر مراحل، صفحه اصلاح کادرها، JSON مدل‌ها | سنجش وضوح فایل اصلی Komatsu (نمونه ارسالی Print-to-PDF بود) |
| ۴. سه‌بعدی همگام | Claude Code + کار دستی | مدل‌های منتخب فاز ۳، cp-editor، ORIPA CLI | فریم‌های FOLD متصل به مراحل | **مقاله Akitaya و همکاران، JSST 2013:** https://www.jsst.jp/e/JSST2013/extended_abstract/pdf/Paper%2037.pdf |
| ۵. تصویر ← پایه درختی | claude.ai: تصمیم الگوریتمی · Claude Code: پیاده‌سازی | `digest-design-engines.md`، BP Studio، skeletonize، TreeMaker | صفحه طراحی: تصویر ← اسکلت ← درخت ← CP ← سه‌بعدی | **روش جداسازی سیلوئت از عکس** (انتخاب و آزمایش یک کتابخانه آماده) |
| ۶. سه‌بعدی ← الگوی چین | مثل فاز ۵ | ORI-REVO، Freeform Origami، مقاله Origamizer | ابتدا اجسام دوار، سپس چندوجهی‌ها | **مقاله‌های Tachi («Origamizing polyhedral surfaces» و «Tucking molecule») + فایل اجرایی Origamizer** از https://origami.c.u-tokyo.ac.jp/~tachi/software/ |

جلسه claude.ai هنگام نوشتن برگه کار هر فاز، منبع ستون آخر را یادآوری می‌کند تا پیش از اجرا تهیه شود.

---

## ۵. کدام Claude Code

- فاز ۰، ۱، ۲، ۵، ۶: هر Claude Code که به GitHub دسترسی دارد.
- فاز ۳ و ۴: **روی کامپیوتر کاربر**، چون کتاب‌ها (۳۰ تا ۵۰ مگابایت) روی درایو D هستند.
