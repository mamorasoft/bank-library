# Context & Domain Decisions

## Terminologi

- **Tree-shaking**: proses bundler (Vite/Webpack/Rollup) di sisi *consumer* membuang kode yang tidak dipakai dari bundle produksi akhir. Ini terjadi saat *build* aplikasi consumer, bukan saat `npm install`.
- **Subpath export**: entry point tambahan pada `package.json` `exports` map selain `"."`, misal `@bank-library/vuejs/functions`, yang memetakan ke file build terpisah sehingga consumer bisa import langsung dari domain yang lebih spesifik.
- **`sideEffects: false`**: flag di `package.json` yang memberi sinyal ke bundler bahwa modul aman untuk di-tree-shake (tidak ada efek samping saat modul di-import tapi exportnya tidak dipakai).
- **`responsiveColsTailwind(defaultCol, step, max)`**: utilitas di `packages/vuejs` yang menghasilkan string class Tailwind responsive untuk `col-span-{N}`. Iterasi dari `defaultCol` (kolom di mobile / tanpa prefix) naik dengan kenaikan `step` per breakpoint Tailwind (`sm`, `md`, `lg`, `xl`, `2xl`) sampai berhenti di `max` (nilai terakhir kali di mana iterasi tidak akan melebihi `max` — yaitu `col-span-{max}` pada breakpoint tertinggi).
- **`getDefaultCol()`**: getter untuk nilai `defaultCol` yang dikonfigurasi secara global saat `app.use(BankLibrary, { defaultCol: N })`. Return `undefined` (atau `null`) bila belum ada konfigurasi global.
- **`GridColOptions`**: opsi global untuk `app.use()`, berisi `defaultCol?: number`.
- **Global install pattern**: `app.use(BankLibrary, options)` menyimpan opsi ke `app.provide(BANK_LIB_KEY, options)` agar fungsi Vue bisa resolve via `inject(BANK_LIB_KEY)` — lihat [[bank-lib-install-options]].

## Keputusan (2026-06-18)

**Decision**: Paket `packages/vuejs` (`@bank-library/vuejs`) dipecah menjadi 4 entry point build: root `.` (backward-compat, semua fitur), `./functions` (validator, currency, rupiah, indonesian-date — tanpa axios), `./api` (`callApi`, satu-satunya consumer dari axios), `./ui` (komponen Vue). Root `.` tetap re-export semuanya untuk backward compatibility.

**Why**: User melaporkan bahwa install `@bank-library/vuejs` untuk satu fungsi (misal `formatRupiah`) tetap menarik dependency `axios` (dipakai oleh `callApi`) dan kode UI lain ke dalam bundle produksi aplikasi mereka. Root cause: `functions/index.ts` me-re-export `apiHelper.ts` (yang import axios) dalam satu barrel yang sama dengan fungsi-fungsi murni, dan hanya ada satu entry point Vite (`src/index.ts`) sehingga tidak ada batas modul yang jelas untuk tree-shaking.

**How to apply**: Lihat [[adr-0001-vuejs-subpath-exports]] untuk detail teknis & tradeoff (UMD format di-drop, diganti ES+CJS).

**Catatan penting**: subpath export memperbaiki *bundle size* di aplikasi consumer (hasil build mereka), BUKAN *install size* — `axios` tetap tercatat sebagai dependency di `package.json` dan tetap terdownload ke `node_modules` consumer saat `npm install`, terlepas dari subpath mana yang dipakai. npm tidak punya mekanisme "install dependency hanya jika subpath X diimport".

## Desain Teknis (2026-06-25)

**Decision**: Install options disimpan via `app.config.globalProperties` pattern yang sudah ada di codebase. Nilai `defaultCol` disimpan di key global `__bank_lib_options` dan dibaca fungsi `responsiveColsTailwind`/`getDefaultCol` via getter sederhana (bukan Vue `inject`, karena fungsi ini pure JS yang bisa dipakai di luar komponen).

**How to apply**: Lihat [[plan-responsive-cols-tailwind]] untuk detail implementasi.
