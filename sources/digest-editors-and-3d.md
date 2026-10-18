---
title: خلاصه فنی منابع — ویرایشگرها و ابزارهای سه‌بعدی (ORIPA، cp-editor، ORI-REVO، Pop Up Card، OrigamiDraw، awesome-origami)
generated: 2026-10-18
basis: خواندن مستقیم فایل‌های ریپازیتوری در commitهای ذکرشده. بخش‌های «[تحلیل]» برداشت‌اند، نه فکت.
---

# ویرایشگرها و ابزارهای سه‌بعدی

## 1. ORIPA (oripa/oripa)

- **مخزن:** https://github.com/oripa/oripa — commit `095899f6d8` (2026-10-17)؛ نسخه در `build.gradle.kts`: `1.80`
- **مجوز:** GPL-3.0
- **زبان:** Java (805 فایل)، ساخت با Gradle
- **الگوریتم‌ها:** `vendor/oripa/documents/algorithms.md`

### الگوریتم تا (خلاصه از `documents/algorithms.md`)
1. بررسی تخت‌تاشدنی محلی هر رأس (الگوریتم خطی Demaine و O'Rourke).
2. بریدن کاغذ در امتداد چین‌ها و جابه‌جایی وجه‌ها با ترکیب بازتاب‌ها.
3. تعیین قطعی روابط هم‌پوشانی وجه‌ها با تشخیص نفوذ و تناقض.
4. شمارش همه ماتریس‌های هم‌پوشانی قابل‌تا با backtracking روی «پشته زیروجه‌ها».

### خط فرمان (از README، با jar نسخه 1.70)
```sh
java -jar ./oripa-1.70.jar --convert converted.fold cp.opx     # تبدیل فرمت
java -jar ./oripa-1.70.jar --convert converted.png cp.fold     # FOLD ورودی؛ خروجی تصویر
java -jar ./oripa-1.70.jar --fold folded.fold cp.opx           # تا زدن؛ خروجی FOLD چند-frame
java -jar ./oripa-1.70.jar --image folded.svg -n 0 folded.fold # تصویر حالت تاخورده
```

### ساختار `src/main/java/oripa/`
`domain/paint/` (121)، `gui/presenter/` (108)، `domain/fold/` (62: `Folder.java`، `LayerOrderEnumerator.java`، `DeterministicLayerOrderEstimator.java`، `OverlapRelationFactory.java`، `subface/`، `stackcond/`، `foldability/`)، `domain/cptool/` (42)، `persistence/foldformat/` (12). پوشه `src/oripa/` کد قدیمی است.

### نقش در اپ [تحلیل]
ابزار کمکی خط فرمان برای محاسبه حالت تاخورده و ترتیب لایه‌ها از الگوی چین، خارج از اپ (هنگام آماده‌سازی داده).

---

## 2. Crease Pattern Editor (edemaine/cp-editor)

- **مخزن:** https://github.com/edemaine/cp-editor — commit `8b711099ca` (2023-06-25)
- **مجوز:** MIT
- **زبان:** CoffeeScript؛ یک فایل اصلی `cpedit.coffee` (827 خط)، قالب Pug، استایل Stylus؛ OrigamiSimulator به‌صورت git submodule

### قابلیت‌ها (از README)
گراف صفحه‌ای با تقسیم و ادغام خودکار رأس‌ها؛ رسم چین با دو کلیک یا کشیدن؛ تغییر نوع چین؛ زاویه تا (نمایش با opacity)؛ پاک کردن؛ جابه‌جایی رأس؛ snap به شبکه؛ undo/redo؛ خروجی `.fold`/`.svg` شامل بریدن شکاف‌ها؛ CLI: `node cpedit.js --cleanup --fold --svg filename.cp`. فعلاً برای الگوهای روی شبکه صحیح خوب کار می‌کند.

### نقش در اپ [تحلیل]
الگوی کوچک و خوانا برای ویرایشگر الگوی چین داخل اپ و ساخت دستی فریم‌های FOLD (فاز ۴).

---

## 3. ORI-REVO (jun-mitani/orirevo)

- **مخزن:** https://github.com/jun-mitani/orirevo — commit `e408db4fe7` (2023-06-07)
- **مجوز:** MIT
- **زبان:** JavaScript؛ کل برنامه در `index.html` (2731 خط) + `orirevo_util.js` (216 خط) + three.js
- **مقاله مرتبط:** http://mitani.cs.tsukuba.ac.jp/dl/CAD_2009_3d_origami_based_on_rotational_sweep_mitani.pdf

### توابع کلیدی در `index.html`
- چهار نوع مدل: `buildModel_Cylindrical_Flap`، `buildModel_Cylindrical_Prism`، `buildModel_Disk_Flap`، `buildModel_Disk_Prism`
- `update3DModel`، `morph`، `morphAnimation` (انیمیشن تا)
- خروجی: `exportDXF`، `exportSVG`، `exportOBJ`، `exportOrirevo`
- ورودی کاربر: منحنی پروفیل روی `mainCanvas` با snap به شبکه

### نقش در اپ [تحلیل]
سریع‌ترین مسیر برای «اوریگامی از جسم دلخواه» در اجسام با تقارن چرخشی (فاز ۶).

---

## 4. Pop Up Block Card (jun-mitani/popup_card)

- **مخزن:** https://github.com/jun-mitani/popup_card — commit `2bb05f6748` (2023-02-17)؛ MIT؛ کل برنامه در `index.html` (1444 خط) + three.js
- توابع: مدل وکسلی (`addBlock`، `delBlock`، `resetVoxel`، `getCell`)، `buildCard`، `getPatternEdges`، `getSVG`، `foldAngleChange`.
- **نقش [تحلیل]:** اختیاری.

---

## 5. OrigamiDraw (silverygrey، itch.io)

- **کد اکنون موجود است:** `sources/origamidraw/` (`origamidraw.js` 32 KB، `index.html`، `README.md`) — از `origamidraw_download.zip` کاربر.
- سازنده کارهایش را در مالکیت عمومی اعلام کرده است.
- **قابلیت‌ها:** خطوط تای دره، کوه، چین، اشعه ایکس، لبه کاغذ؛ فلش‌های تای دره و کوه، باز کردن، فشار، تکرار، برگرداندن؛ رنگ دو روی کاغذ؛ برچسب متنی؛ شبکه مربعی یا ایزومتریک؛ خروجی و ورودی SVG.

### نقش در اپ [تحلیل]
مرجع نمادهای دیاگرام استاندارد برای فاز ۲ و نمایشگر مراحل.

---

## 6. awesome-origami (oriedita/awesome-origami)

- **مخزن:** https://github.com/oriedita/awesome-origami — commit `5466e7515a`
- فهرست منابع: Software، Community، Theory، Techniques، Models، Designers، Diagrams. فایل: `vendor/awesome-origami/README.md`.
