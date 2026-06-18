# ADR 0001: Subpath exports + drop UMD untuk `@bank-library/vuejs`

**Status**: Approved (2026-06-18)

## Context

`packages/vuejs` hanya punya satu entry point build (`src/index.ts`) yang menggabungkan UI components, semua function helpers, dan `callApi` (yang men-import `axios`). Consumer yang hanya butuh satu fungsi seperti `formatRupiah` tetap berisiko ikut menarik `axios` + kode UI ke bundle produksi mereka karena tidak ada batas modul tree-shaking yang jelas, dan `package.json` belum mendeklarasikan `sideEffects: false`.

## Decision

1. Pecah build jadi 4 entry: `.` (root, backward-compat — re-export semua), `./functions`, `./ui`, `./api`.
2. Pindahkan `apiHelper.ts` (satu-satunya pemakai `axios`) ke folder `src/api/` terpisah dari `src/functions/`.
3. Tambahkan `"sideEffects": false` di `package.json`.
4. **Drop format UMD**, ganti formats build jadi `['es', 'cjs']` saja.

## Konsekuensi

- ✅ Consumer modern (Vite/Webpack/Rollup) bisa tree-shake otomatis kode yang tidak dipakai dari bundle produksi.
- ✅ Consumer yang explicit import dari `@bank-library/vuejs/functions` dijamin tidak membawa `axios` ke graph dependency build-nya, terlepas dari kemampuan tree-shaking bundler-nya.
- ⚠️ **Breaking change minor**: UMD build (`dist/index.umd.cjs`) dihapus. Field `main` di `package.json` pindah ke output CJS (`dist/index.cjs`). Consumer yang memuat library lewat `<script>` tag tanpa bundler (global `BankLibraryVuejs`) tidak lagi didukung. Dianggap risiko rendah karena package belum dipublikasikan ke npm registry publik (`version: 1.0.0`, belum ada consumer eksternal tercatat) dan ekosistem Vue 3 + TypeScript pada umumnya selalu memakai bundler.
- `axios` tetap tercantum sebagai dependency wajib di `package.json` — tidak ada perubahan pada `npm install` footprint, hanya pada hasil build/bundle aplikasi consumer.

## Alternatif yang dipertimbangkan

- **Hanya tambah `sideEffects: false` tanpa split entry**: ditolak karena tidak membantu consumer yang pakai UMD/CJS langsung tanpa bundler modern, dan tidak memberi jaminan eksplisit/discoverable untuk pemisahan axios.
- **Publish setiap helper sebagai package npm terpisah** (kembali ke pola `format-rupiah-vue-main` / `indonesian-date-vue-main` sebelum di-merge di commit `bec3a28`): ditolak karena menambah overhead maintenance/versioning yang menjadi alasan awal kedua package tersebut digabung ke `packages/vuejs`.
