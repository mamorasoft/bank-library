# TASK-001 — Fix Tree-Shaking Paket @bank-library/vuejs

**Status**: ✅ COMPLETED
**Type**: Bug Fix
**Created**: 2026-06-18
**Related Tasks**: -
**Related Docs**: [CONTEXT.md](../CONTEXT.md), [ADR-0001](../docs/adr/0001-vuejs-subpath-exports.md)

## Deskripsi

Paket `@bank-library/vuejs` hanya punya satu entry point build (`src/index.ts`) yang menggabungkan UI components, semua function helpers, dan `callApi` (yang mengimpor `axios`). Consumer yang hanya butuh satu fungsi seperti `formatRupiah` berisiko ikut menarik `axios` + kode UI lain ke bundle produksi mereka, karena tidak ada batas modul yang jelas untuk tree-shaking dan `package.json` belum mendeklarasikan `sideEffects: false`.

## Root Cause

`src/functions/index.ts` me-re-export `apiHelper.ts` (consumer `axios`) dalam barrel yang sama dengan fungsi murni (validator, formatter, date). Hanya ada satu entry Vite (`src/index.ts`), jadi bundler consumer tidak punya sinyal/batas modul yang aman untuk membuang kode yang tidak dipakai.

## Solusi

Pecah build `packages/vuejs` jadi 4 entry point: `.` (root, backward-compat), `./functions` (tanpa axios), `./ui`, `./api` (isolasi `callApi`/axios). Tambah `sideEffects: false`. Drop format UMD, ganti ke `['es', 'cjs']`.

## Implementation Steps

1. Pindahkan `src/functions/apiHelper.ts` → `src/api/apiHelper.ts`, buat `src/api/index.ts`.
2. Hapus re-export `apiHelper` dari `src/functions/index.ts`.
3. Tambah `export * from './api'` di `src/index.ts` (root) untuk backward compatibility.
4. Update `tests/apiHelper.test.ts` import path.
5. Restructure `vite.config.ts` — multi-entry (`index`, `functions`, `ui`, `api`), formats `['es', 'cjs']`, external `['vue', 'axios']`.
6. Update `package.json` — `sideEffects: false`, `exports` map per subpath, `main`/`module`/`types` ke output baru.
7. Update `README.md` paket vuejs — contoh import granular per subpath.
8. Verifikasi `npm run build` & `npm test`.

## User Scenarios

### Happy Path
- Sebagai developer Vue, saya import `import { formatRupiah } from '@bank-library/vuejs/functions'` dan setelah build aplikasi saya, `axios` tidak muncul di bundle produksi.
- Sebagai developer existing, saya tetap `import { callApi, formatRupiah, BankAccountInput } from '@bank-library/vuejs'` (root) tanpa perubahan apapun — semua tetap berfungsi seperti sebelumnya.

### Validasi / Regresi
- Semua test existing (`accountValidator`, `currencyConverter`, `rupiahFormatter`, `IndonesianDate`, `apiHelper`, directive) tetap lulus setelah path file dipindah.
- `npm run build` menghasilkan `dist/index.{js,cjs,d.ts}`, `dist/functions.{js,cjs,d.ts}`, `dist/ui.{js,cjs,d.ts}`, `dist/api.{js,cjs,d.ts}` tanpa error.

### Edge Case
- Consumer yang sebelumnya memuat lib via `<script>` tag (UMD/global `BankLibraryVuejs`) — **tidak didukung lagi** (breaking change minor, didokumentasikan di ADR-0001). Risiko dinilai rendah karena package belum dipublikasikan ke npm registry publik.

## Testing Plan

- Unit test: `npm test` di `packages/vuejs` (vitest, termasuk `apiHelper.test.ts` dengan path baru).
- Build verification: `npm run build`, inspeksi manual isi `dist/` per entry.

## Acceptance Criteria

- [x] `src/api/` berisi `apiHelper.ts` + `index.ts`; `src/functions/index.ts` tidak lagi re-export apiHelper.
- [x] Root `src/index.ts` tetap re-export semua (termasuk `./api`) — no breaking change untuk consumer existing.
- [x] `vite.config.ts` build 4 entry sukses, format `['es','cjs']`, UMD dihapus.
- [x] `package.json` punya `sideEffects: false` + `exports` map 4 subpath + `main`/`module`/`types` terupdate.
- [x] Semua test vitest lulus (23/23).
- [x] README diupdate dengan contoh subpath import.

## Hasil Build (Verifikasi)

```
dist/index.js       1.82 kB  (root, semua fitur)
dist/functions.js    0.54 kB  (tanpa axios, tanpa UI)
dist/ui.js            0.17 kB
dist/api.js           0.08 kB  (callApi saja)
```
`.d.ts` ter-generate mirroring struktur source: `dist/functions/index.d.ts`, `dist/ui/index.d.ts`, `dist/api/index.d.ts`, `dist/index.d.ts`.

**Manual test**: dikonfirmasi user — aman.
