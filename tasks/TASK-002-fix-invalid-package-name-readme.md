# TASK-002: Fix nama package root yang invalid dan perbaiki dokumentasi git-install vuejs

<!-- Tracker ID: TODO -->
<!-- Tracker URL: TODO -->

## Priority
**Low**

## Status
🧪 **COMPLETED** - June 19, 2026

## Business Problem
User mencoba `npm install git+https://github.com/mamorasoft/bank-library.git#path:packages/vuejs`
sesuai contoh di README, tapi gagal dengan error:

```
npm error code EINVALIDPACKAGENAME
npm error Invalid package name "@bank-library-mamorasoft" ... name can only contain URL-friendly characters.
```

Root cause (dikonfirmasi via baca source `npm-package-arg/lib/npa.js` di npm 10.9.8):
1. **Syntax `#path:<subdir>` TIDAK didukung oleh npm.** npm git-dependency selalu clone seluruh
   repo dan baca `package.json` di **root**, apapun fragment setelah `#` (selain commit-ish/branch/tag).
   README sebelumnya salah menyarankan syntax ini sebagai cara install hanya `packages/vuejs`.
2. **Nama `package.json` root invalid**: `"@bank-library-mamorasoft"` diawali `@` (scoped) tapi tanpa
   `/nama-package` setelahnya — melanggar aturan penamaan npm untuk scoped package, sehingga npm
   gagal lebih awal lagi begitu mencoba install root package via git.

## Description
- Perbaiki `name` di root `package.json` agar valid (scoped dengan format `@scope/name` atau
  unscoped tanpa `@`), tanpa mengubah `workspaces` config yang sudah benar.
- Hapus/luruskan instruksi `#path:packages/vuejs` di `README.md` (root) yang menyarankan fitur
  yang tidak ada di npm. Ganti dengan penjelasan limitasi: git-install dari npm akan selalu
  menginstall seluruh monorepo via root `package.json`, sehingga untuk konsumsi `@bank-library/vuejs`
  saja, cara yang didukung adalah install dari registry (`npm install @bank-library/vuejs`).
- Tidak ada perubahan ke distribusi (tidak publish ke registry, tidak split repo) — sesuai keputusan
  user, scope task ini murni perbaikan dokumentasi + penamaan.

---

## Affected Files (Wajib)

### Backend
- Tidak ada.

### Frontend
- Tidak ada.

### Configuration / Infrastructure
- `package.json` (root) — perbaiki field `name` agar valid menurut aturan npm.
- `README.md` (root) — hapus contoh `#path:packages/vuejs` yang salah, jelaskan limitasi git-install
  dan arahkan ke instalasi via registry.

### Files Diketahui TIDAK Terpengaruh (Dikonfirmasi)
- `packages/vuejs/package.json` — nama `@bank-library/vuejs` sudah valid (format scoped benar).
- `packages/vuejs/README.md` — tidak menyebutkan syntax `#path:`, hanya root `README.md` yang salah.
- `packages/laravel/`, `packages/flutter/` — tidak terkait masalah ini.

---

## User Scenarios

> Format: **Given** [kondisi] **When** [aksi] **Then** [hasil]

### ✅ Happy Path (Positive Flow)
- [x] **Scenario 1**: Given root `package.json` sudah diperbaiki When developer menjalankan
  `node -e "require('./package.json')"` atau validasi nama via `npm-package-arg` Then nama package
  tidak lagi memicu `EINVALIDPACKAGENAME`. (Diverifikasi: `npm install --workspaces=false` sukses)
- [x] **Scenario 2**: Given `README.md` sudah diperbaiki When pembaca mengikuti instruksi instalasi
  vuejs Then instruksi yang diberikan (install dari registry) benar-benar berhasil tanpa error npm.

### 🔍 Not Found & Edge Cases
- [x] **Scenario**: Given dokumentasi lama masih menyebut `#path:` di tempat lain (subpath README
  vuejs, dsb) When dicek ulang Then dikonfirmasi tidak ada referensi tersisa. (`grep -rn "path:"`
  pada `README.md` dan `packages/vuejs/README.md` — 0 hasil)

---

## Acceptance Criteria

- [x] `package.json` root punya `name` yang valid (lolos validasi `npm-package-arg`, tidak ada
  `@scope` tanpa `/name`) — diubah ke `@mamorasoft/bank-library`
- [x] `README.md` tidak lagi menyarankan syntax `#path:` untuk git install
- [x] `README.md` menjelaskan dengan jelas limitasi git-install monorepo dan mengarahkan ke instalasi
  via registry sebagai cara yang didukung
- [x] Tidak ada perubahan pada `packages/vuejs/package.json`, `vite.config.ts`, atau kode `apiHelper.ts`
  (di luar scope task ini)

### Quality Gates (Before Marking COMPLETED)
- [x] `npm install` di root tidak error karena nama package
- [x] Review manual: README dibaca ulang, tidak ada instruksi yang salah/menyesatkan

---

## Dependencies
Tidak ada dependency.

### Related Tasks
- **Related TASK-001**: TASK-001 (fix tree-shaking vuejs) menambahkan subpath exports; saran
  `#path:` yang salah ditambahkan setelah TASK-001 saat mendokumentasikan cara install vuejs saja
  (di luar task file, langsung lewat percakapan) — TASK-002 ini memperbaiki kesalahan tersebut.
- **Bug Description**: Saran instalasi git `#path:packages/vuejs` tidak valid di npm + nama root
  package.json invalid.
- **Impact**: Minor — hanya memengaruhi dokumentasi/DX instalasi, tidak ada kode produksi yang salah.
- **Fix Scope**: `package.json` root + `README.md` root.

---

## Timeline
- **Created**: June 19, 2026
- **Started**: June 19, 2026
- **Completed**: June 19, 2026

---

## Notes
Root cause dikonfirmasi dengan membaca langsung source `npm-package-arg` (dependency internal npm
CLI) — tidak ada handling untuk fragment `path:` pada git URL. Ini bukan fitur npm yang pernah ada;
klaim sebelumnya di README adalah kesalahan dokumentasi.
