# Indonesian Date Vue

A Vue 3 helper library to format dates into Indonesian Day/Month/Date structure, mirroring the features of the PHP `indonesian-date` helper.

## Features
- Format dates using custom PHP-style format specifiers (`l`, `D`, `F`, `M`, etc.).
- Export helper functions `indoDate`, `indoMonth`, `indoDay`, and `indoFormat`.
- Vue 3 plugin wrapper to expose global helpers in your components.
- Written in TypeScript with full auto-completion/types support.

---

## Installation

Since this is a private helper library, you can install it via a local path or git URL:

### Local Path
```bash
npm install ../mamorasoft-helpers/indonesian-date-vue
```

### Git Repository (HTTPS)
```bash
npm install github:mamorasoft/indonesian-date-vue
```

---

## Usage

### 1. Register Vue 3 Plugin (Optional)

You can register the plugin globally in your `main.ts` or `main.js`:

```typescript
import { createApp } from 'vue';
import App from './App.vue';
import { IndonesianDatePlugin } from 'indonesian-date-vue';

const app = createApp(App);

app.use(IndonesianDatePlugin);
app.mount('#app');
```

This registers the following global methods accessible in any component template:
- `$indoDate(date, withDay?, shortMonth?)`
- `$indoMonth(date, shortMonth?)`
- `$indoDay(date, shortDay?)`
- `$indoFormat(date, format)`

#### Template Example:
```html
<template>
  <div>
    <!-- Output: Kamis, 4 Juni 2026 -->
    <p>{{ $indoDate('2026-06-04', true) }}</p>

    <!-- Output: Juni -->
    <p>{{ $indoMonth('2026-06-04') }}</p>

    <!-- Output: Kamis -->
    <p>{{ $indoDay('2026-06-04') }}</p>

    <!-- Output: Kamis, 04-06-2026 10:15 -->
    <p>{{ $indoFormat('2026-06-04T10:15:30', 'l, d-m-Y H:i') }}</p>
  </div>
</template>
```

---

### 2. Functional API (Composition API / Script Setup)

You can also import individual helpers directly:

```typescript
import { indoDate, indoMonth, indoDay, indoFormat } from 'indonesian-date-vue';

// 4 Juni 2026
const dateOnly = indoDate('2026-06-04');

// Kamis, 4 Juni 2026
const fullDate = indoDate('2026-06-04', true);

// Juni
const monthName = indoMonth('2026-06-04');

// Kamis
const dayName = indoDay('2026-06-04');

// Custom format (Output: 04 Jun 2026 10:15)
const custom = indoFormat('2026-06-04T10:15:30', 'd M Y H:i');
```

---

## Supported Format Characters

The formatting logic mirrors PHP's `date()` formatting characters:

| Character | Description | Example |
| :--- | :--- | :--- |
| **l** (lowercase 'L') | Full day name in Indonesian | `Minggu` to `Sabtu` |
| **D** | Short day name in Indonesian (3 chars) | `Min` to `Sab` |
| **F** | Full month name in Indonesian | `Januari` to `Desember` |
| **M** | Short month name in Indonesian (3 chars) | `Jan` to `Des` |
| **Y** | Full 4-digit numeric year | `2026` |
| **y** | 2-digit numeric year | `26` |
| **m** | Numeric month with leading zero | `01` to `12` |
| **n** | Numeric month without leading zero | `1` to `12` |
| **d** | Day of the month with leading zero | `01` to `31` |
| **j** | Day of the month without leading zero | `1` to `31` |
| **H** | 24-hour hour with leading zero | `00` to `23` |
| **G** | 24-hour hour without leading zero | `0` to `23` |
| **h** | 12-hour hour with leading zero | `01` to `12` |
| **g** | 12-hour hour without leading zero | `1` to `12` |
| **i** | Minutes with leading zero | `00` to `59` |
| **s** | Seconds with leading zero | `00` to `59` |
| **w** | Numeric day of the week | `0` (Sunday) to `6` (Saturday) |
| **a** | Lowercase AM/PM marker | `am` or `pm` |
| **A** | Uppercase AM/PM marker | `AM` or `PM` |

> **Note:** Use `\` to escape characters (e.g. `\\D\\a\\t\\e` for literal "Date").

---

## Creator

- [alfin-dev](https://github.com/alfin-dev)

