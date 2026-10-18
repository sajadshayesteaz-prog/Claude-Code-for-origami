# وضعیت پروژه

- **فاز فعلی:** ۰ و ۱ — انجام شد (برگه ۰۰۱؛ گزارش `docs/reports/001-bootstrap-and-viewer.md`؛ Origami-App commit `38d74a3`).
- **آنچه کار می‌کند:**
  - اپ وب (Vite + React + TS) با تغییر زبان فارسی (راست‌به‌چپ) و انگلیسی.
  - نمایشگر FOLD/SVG: الگوی چین دوبعدی (Rabbit Ear) و حالت تاخورده سه‌بعدی (Origami Simulator). پخش مرحله‌به‌مرحله ۳۷ frame درنا جلو و عقب آزموده شد. `birdBase.svg` در سه‌بعدی تا می‌خورد.
  - JSON Schema برای Model، Step و Progress؛ مدل نمونه `example-crane` معتبر است (`npm run validate:data`).
  - `vendor/` با ۱۲ مخزن در commitهای ثابت روی کامپیوتر کاربر دریافت شده است.
- **مشکل باز:** Node (پرتابل، `%LOCALAPPDATA%\Programs\nodejs`) هنوز در PATH ویندوز نیست. PWA و IndexedDB هنوز ساخته نشده‌اند.
- **قدم بعدی:** برگه کار ۰۰۳ (`docs/tasks/003-continuous-3d-and-layers.md`، اولویت بالاتر) و سپس ۰۰۲ (`docs/tasks/002-basic-folds-guide.md`).
