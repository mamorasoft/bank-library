# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Bank Library is a monorepo providing the same banking utilities (account/IBAN validation, currency formatting/conversion) plus UI components across three independent platform packages:

- `packages/laravel` — PHP package (Composer), registered via `BankServiceProvider`
- `packages/vuejs` — Vue 3 + TypeScript package (npm/Vite), built as a Vue plugin
- `packages/flutter` — Dart/Flutter package (pub)

These packages are **not built from shared source** — each implements equivalent logic independently in its own language/idiom. When fixing a bug or adding a feature that conceptually applies to all platforms (e.g. account validation rules), check whether the same fix is needed in the other two packages.

Root `package.json` only orchestrates the JS/TS workspace (`packages/vuejs`); Laravel and Flutter are managed independently with their own toolchains.

## Commands

### Vue.js package (`packages/vuejs`)
```bash
npm install                # from repo root or packages/vuejs
npm run build               # vite build -> dist/
npm run dev                 # vite build --watch
npm test                    # vitest run (all tests, packages/vuejs/tests)
npm run test:watch          # vitest (watch mode)
npx vitest run tests/format.test.ts   # run a single test file
npm run lint                 # eslint src --ext .js,.vue,.ts
```
Can also be run from repo root via `npm run build|test|lint` (uses npm workspaces, `--workspaces`).

### Laravel package (`packages/laravel`)
```bash
composer install                       # from packages/laravel
composer test                          # if defined, otherwise:
vendor/bin/phpunit                     # run full test suite
vendor/bin/phpunit --filter testName   # run a single test
```
Requires PHP ^8.1, Illuminate ^10|^11. Service provider auto-registers via Laravel package discovery (`extra.laravel.providers` in `composer.json`). Config can be published with `php artisan vendor:publish --tag=bank-config`.

### Flutter package (`packages/flutter`)
```bash
flutter pub get
flutter test                           # full test suite
flutter test test/some_test.dart       # single test file
flutter analyze                        # lints (flutter_lints)
```

## Architecture

### Vue.js package (`packages/vuejs/src`)
- `index.ts` — plugin entry point. `install()` globally registers all components from `./ui`, registers the `v-rupiah` directive (merging global install options with per-binding options), and exposes global helpers (`$formatRupiah`, `$parseRupiah`, `$indoDate`, `$indoMonth`, `$indoDay`, `$indoFormat`) on `app.config.globalProperties`. Also augments `ComponentCustomProperties` for TS support.
- `ui/` — Vue SFC components (`BankAccountInput.vue`, `CurrencyInput.vue`, `RupiahInput.vue`), re-exported via `ui/index.ts`.
- `functions/` — framework-agnostic utilities, re-exported via `functions/index.ts`:
  - `accountValidator.ts`, `currencyConverter.ts` — core banking logic
  - `rupiahFormatter.ts` / `rupiahComposable.ts` / `rupiahDirective.ts` — three different ways to consume Rupiah formatting (plain function, composable, `v-rupiah` directive)
  - `indonesianDate.ts` — Indonesian-locale date formatting (`IndonesianDate.date/month/day/format`)
  - `apiHelper.ts` — `callApi(method, url, data, params)`: Axios wrapper that auto-injects a Bearer token from `localStorage.getItem('token')` when present, and auto-converts payloads containing `File`/`Blob` values into `FormData` for multipart upload.
- Library builds dual ESM/UMD output via Vite (`vite.config.ts`) with bundled `.d.ts` (vite-plugin-dts); `vue` is an external peer dependency.
- Tests live in `packages/vuejs/tests/`, run with Vitest in a `jsdom` environment.

### Laravel package (`packages/laravel/src`)
- `BankServiceProvider.php` — registers/merges `config/bank.php` and exposes the package's config for publishing.
- `Function/AccountValidator.php`, `Function/CurrencyConverter.php` — static utility classes for account/IBAN validation and currency formatting/conversion (mirrors the Vue.js `functions/` logic).

### Flutter package (`packages/flutter/lib`)
- `bank_library.dart` — package entry barrel file.
- `functions/` — `account_validator.dart`, `currency_converter.dart` (mirrors Laravel/Vue logic), barrel-exported via `functions.dart`.
- `ui/` — `bank_account_input.dart`, `currency_input.dart` widgets, barrel-exported via `ui.dart`.

## Cross-platform consistency

The three packages intentionally expose parallel APIs (e.g. `AccountValidator::validateAccountNumber` in Laravel, `validateAccountNumber` in Vue/Flutter functions, `CurrencyConverter::formatCurrency`/`formatCurrency`). See `docs/usage.md` for the canonical usage examples per platform and `docs/API.md`/`docs/EXAMPLES.md` for further reference — when changing validation/formatting behavior, keep these docs and the parallel implementations in sync.
