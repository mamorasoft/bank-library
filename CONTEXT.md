# Context & Domain Decisions

## Terminologi

- **Tree-shaking**: proses bundler (Vite/Webpack/Rollup) di sisi *consumer* membuang kode yang tidak dipakai dari bundle produksi akhir. Ini terjadi saat *build* aplikasi consumer, bukan saat `npm install`.
- **Subpath export**: entry point tambahan pada `package.json` `exports` map selain `"."`, misal `@bank-library/vuejs/functions`, yang memetakan ke file build terpisah sehingga consumer bisa import langsung dari domain yang lebih spesifik.
- **`sideEffects: false`**: flag di `package.json` yang memberi sinyal ke bundler bahwa modul aman untuk di-tree-shake (tidak ada efek samping saat modul di-import tapi exportnya tidak dipakai).

## Keputusan (2026-06-18)

**Decision**: Paket `packages/vuejs` (`@bank-library/vuejs`) dipecah menjadi 4 entry point build: root `.` (backward-compat, semua fitur), `./functions` (validator, currency, rupiah, indonesian-date — tanpa axios), `./api` (`callApi`, satu-satunya consumer dari axios), `./ui` (komponen Vue). Root `.` tetap re-export semuanya untuk backward compatibility.

**Why**: User melaporkan bahwa install `@bank-library/vuejs` untuk satu fungsi (misal `formatRupiah`) tetap menarik dependency `axios` (dipakai oleh `callApi`) dan kode UI lain ke dalam bundle produksi aplikasi mereka. Root cause: `functions/index.ts` me-re-export `apiHelper.ts` (yang import axios) dalam satu barrel yang sama dengan fungsi-fungsi murni, dan hanya ada satu entry point Vite (`src/index.ts`) sehingga tidak ada batas modul yang jelas untuk tree-shaking.

**How to apply**: Lihat [[adr-0001-vuejs-subpath-exports]] untuk detail teknis & tradeoff (UMD format di-drop, diganti ES+CJS).

**Catatan penting**: subpath export memperbaiki *bundle size* di aplikasi consumer (hasil build mereka), BUKAN *install size* — `axios` tetap tercatat sebagai dependency di `package.json` dan tetap terdownload ke `node_modules` consumer saat `npm install`, terlepas dari subpath mana yang dipakai. npm tidak punya mekanisme "install dependency hanya jika subpath X diimport".
