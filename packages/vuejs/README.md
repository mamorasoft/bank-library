# Bank Library - Vue.js Package

A comprehensive banking utilities package for Vue.js 3 applications, including Indonesian Rupiah formatting and currency conversion utilities.

## Installation

```bash
npm install @bank-library/vuejs
# or
yarn add @bank-library/vuejs
# or
pnpm add @bank-library/vuejs
```

## Usage

### Global Registration

```javascript
import { createApp } from 'vue';
import BankLibrary from '@bank-library/vuejs';
import App from './App.vue';

const app = createApp(App);

// You can pass default Rupiah format options globally
app.use(BankLibrary, {
  prefix: 'Rp. ',         // default: 'Rp. '
  decimalPlaces: 0,       // default: 0
  thousandSeparator: '.', // default: '.'
  decimalSeparator: ','   // default: ','
});

app.mount('#app');
```

This will:
- Register all components globally
- Register the `v-rupiah` directive globally
- Provide global helpers `$formatRupiah`, `$parseRupiah`, `$indoDate`, `$indoMonth`, `$indoDay`, `$indoFormat`, `$getDefaultCol`, and `$responsiveColsTailwind`

### Component Registration

```vue
<script setup>
import { BankAccountInput, CurrencyInput, RupiahInput } from '@bank-library/vuejs';
</script>

<template>
  <BankAccountInput
    v-model="accountNumber"
    label="Account Number"
    :show-validation="true"
  />
  
  <CurrencyInput
    v-model="amount"
    label="Amount"
    currency="USD"
    :show-converted="true"
    converted-currency="EUR"
    :conversion-rate="0.85"
  />

  <RupiahInput
    v-model="nominal"
    label="Nominal (Rupiah)"
    placeholder="Rp. 0"
  />
</template>
```

## Components

### BankAccountInput

A validated input component for bank account numbers.

**Props:**
- `modelValue`: The account number value
- `label`: Input label
- `placeholder`: Placeholder text
- `disabled`: Disable the input
- `required`: Mark as required
- `showValidation`: Show validation icon
- `errorMessage`: Custom error message
- `bankCode`: Bank code for validation

### CurrencyInput

A formatted input component for currency amounts.

**Props:**
- `modelValue`: The numeric amount
- `label`: Input label
- `placeholder`: Placeholder text
- `disabled`: Disable the input
- `required`: Mark as required
- `currency`: Currency code (e.g., 'USD')
- `locale`: Locale string (e.g., 'en-US')
- `showConverted`: Show converted amount
- `convertedCurrency`: Target currency for conversion
- `conversionRate`: Exchange rate

### RupiahInput

A specialized input component for Indonesian Rupiah with automatic formatting.

**Props:**
- `modelValue`: The formatted string value
- `label`: Input label
- `placeholder`: Placeholder text (default: 'Rp. 0')
- `disabled`: Disable the input
- `required`: Mark as required
- `error`: Error message to display
- `prefix`: Currency prefix (default: 'Rp. ')
- `decimalPlaces`: Number of decimal places (default: 0)
- `thousandSeparator`: Thousand separator (default: '.')
- `decimalSeparator`: Decimal separator (default: ',')

**Events:**
- `update:modelValue`: Emits the formatted string
- `update:numericValue`: Emits the numeric value

**Example:**
```vue
<script setup>
import { ref } from 'vue';
import { RupiahInput } from '@bank-library/vuejs';
import { parseRupiah } from '@bank-library/vuejs';

const nominal = ref('');

const handleSubmit = () => {
  const numericValue = parseRupiah(nominal.value);
  console.log('Submitted Value:', numericValue);
};
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <RupiahInput 
      v-model="nominal" 
      label="Nominal"
      :decimal-places="0"
    />
    <button type="submit">Submit</button>
  </form>
</template>
```

## Directives

### v-rupiah

A custom directive that automatically formats input values as Indonesian Rupiah while maintaining cursor position.

**Basic Usage:**
```vue
<script setup>
import { ref } from 'vue';
import { parseRupiah } from '@bank-library/vuejs';

const nominal = ref('');

const handleSubmit = () => {
  const numericValue = parseRupiah(nominal.value);
  console.log('Submitted Value:', numericValue); // output: numeric value
};
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <input v-model="nominal" v-rupiah placeholder="Rp. 0" />
    <button type="submit">Submit</button>
  </form>
</template>
```

**Custom Options:**
```vue
<template>
  <input 
    v-model="nominal" 
    v-rupiah="{ prefix: 'IDR ', decimalPlaces: 2 }" 
  />
</template>
```

## Functions

### Account Validation

```javascript
import { validateAccountNumber, validateIBAN, formatAccountNumber } from '@bank-library/vuejs';

// Validate account number
const isValid = validateAccountNumber('1234567890');

// Validate IBAN
const isValidIBAN = validateIBAN('GB82WEST12345698765432');

// Format account number
const formatted = formatAccountNumber('1234567890'); // "1234 5678 90"
```

### Currency Functions

```javascript
import { formatCurrency, convertCurrency, parseCurrency } from '@bank-library/vuejs';

// Format currency
const formatted = formatCurrency(1234.56, 'USD', 'en-US'); // "$1,234.56"

// Convert currency
const rates = { USD: 1, EUR: 0.85, IDR: 15000 };
const converted = convertCurrency(100, 'USD', 'EUR', rates); // 85

// Parse currency string
const amount = parseCurrency('$1,234.56'); // 1234.56
```

### Indonesian Rupiah Functions

```javascript
import { formatRupiah, parseRupiah } from '@bank-library/vuejs';

// Format to Rupiah
console.log(formatRupiah(100000)); // "Rp. 100.000"
console.log(formatRupiah(250000.5, { decimalPlaces: 2 })); // "Rp. 250.000,50"
console.log(formatRupiah(75000, { prefix: 'Rp ' })); // "Rp 75.000"

// Parse from Rupiah
console.log(parseRupiah('Rp. 100.000')); // 100000
console.log(parseRupiah('Rp. 250.000,50')); // 250000.5
console.log(parseRupiah('100.000')); // 100000
```

### API Helper Functions

```javascript
import { callApi } from '@bank-library/vuejs';

// GET request with query params (method default = 'GET')
const users = await callApi({ url: '/api/users', params: { page: 1 } });

// POST JSON payload
const resJson = await callApi({ method: 'POST', url: '/api/users', data: { name: 'John Doe' } });

// POST with File/Blob (auto-converts to FormData)
const resUpload = await callApi({
  method: 'POST',
  url: '/api/upload',
  data: {
    name: 'image.png',
    file: imageFile // File or Blob object
  }
});

// Membatalkan request yang sedang berjalan
const request = callApi({ url: '/api/users' });
request.abort();

// Atau pakai AbortSignal sendiri (misal AbortSignal.timeout)
await callApi({ url: '/api/users', signal: AbortSignal.timeout(5000) });
```

`callApi` dibangun di atas `fetch` bawaan browser (tidak ada dependency eksternal). Promise yang
dikembalikan punya tambahan method `abort()` untuk membatalkan request.

### Composition API - useRupiah

For a more reactive approach, use the `useRupiah` composable:

```vue
<script setup>
import { useRupiah } from '@bank-library/vuejs';

// Initialize with a default value
const { value, formatted } = useRupiah(100000, { decimalPlaces: 0 });

const addBonus = () => {
  value.value += 50000;
};
</script>

<template>
  <div>
    <!-- Changing this input automatically updates 'value' as a clean number -->
    <input v-model="formatted" />

    <p>Raw Value: {{ value }} (Type: {{ typeof value }})</p>
    <p>Formatted: {{ formatted }}</p>

    <button @click="addBonus">Add Rp. 50.000</button>
  </div>
</template>
```

### Responsive Tailwind Columns

```javascript
import { responsiveColsTailwind, getDefaultCol } from '@bank-library/vuejs';

// Build a responsive col-span class string for Tailwind grids.
// Starts at `defaultCol` for the base viewport, adds `step` columns at each
// Tailwind breakpoint (sm, md, lg, xl, 2xl), capped at `max`.
console.log(responsiveColsTailwind(1, 2, 8));
// => "col-span-1 sm:col-span-3 md:col-span-5 lg:col-span-7 xl:col-span-8"

console.log(responsiveColsTailwind(2, 1, 6));
// => "col-span-2 sm:col-span-3 md:col-span-4 lg:col-span-5 xl:col-span-6"

// getDefaultCol() returns the value configured via app.use(BankLibrary, { defaultCol: N })
console.log(getDefaultCol()); // undefined until app.use() is called with defaultCol
```

When registered via the Vue plugin, two helpers are exposed on every component instance:

```vue
<script setup>
// component-internal: no import needed
</script>

<template>
  <div :class="['grid grid-cols-12', $responsiveColsTailwind($getDefaultCol() ?? 1, 2, 12)]">
    <!-- ... -->
  </div>
</template>
```

To set the default, pass it to `app.use()`:

```javascript
app.use(BankLibrary, { defaultCol: 2 });
```

Throws `RangeError` if `defaultCol < 1` or `max < defaultCol`. Non-positive `step` is treated as `1`.

### SweetAlert Dialogs

SweetAlert2-based helpers for common confirmation and notification flows. All helpers
are SSR-safe — they no-op (or return a resolved dismissal result) when `window` is undefined,
so they can be imported in Nuxt/SSR code without crashing.

```javascript
import {
  confirmDelete,
  confirmGenerate,
  messageSuccess,
  messageError,
  dialogError
} from '@bank-library/vuejs';
```

#### `confirmDelete(title, text, icon?)`

Shows a destructive-action confirmation dialog. Returns a `Promise<SweetAlertResult>`;
check `result.isConfirmed` to proceed with the delete.

```javascript
const result = await confirmDelete(
  'Hapus data ini?',
  'Data yang dihapus tidak dapat dikembalikan.'
);
if (result.isConfirmed) {
  await api.deleteRecord(id);
}
```

| Param  | Type             | Default     | Description                |
| :----- | :--------------- | :---------- | :------------------------- |
| title  | `string`         | required    | Dialog title.              |
| text   | `string`         | required    | Dialog body text.          |
| icon   | `SweetAlertIcon` | `'warning'` | SweetAlert icon name.      |

Confirm button is red (`#d33`) with text `"Ya, hapus!"`, cancel button is blue (`#3085d6`)
with text `"Batal"`.

#### `confirmGenerate(title, text, icon?)`

Shows a confirmation dialog for generate/regenerate actions. Same return shape as
`confirmDelete`.

```javascript
const result = await confirmGenerate(
  'Generate laporan baru?',
  'Proses ini akan menimpa laporan yang ada.'
);
if (result.isConfirmed) {
  await api.regenerateReport();
}
```

| Param  | Type             | Default      | Description                |
| :----- | :--------------- | :----------- | :------------------------- |
| title  | `string`         | required     | Dialog title.              |
| text   | `string`         | required     | Dialog body text.          |
| icon   | `SweetAlertIcon` | `'question'` | SweetAlert icon name.      |

Confirm button is blue (`#3085d6`) with text `"Ya, generate!"`, cancel button is red (`#d33`)
with text `"Batal"`.

#### `messageSuccess(icon?, message)`

Shows a transient auto-closing dialog (no confirm button, 1.5s timer). Use for
success notifications.

```javascript
await messageSuccess('success', 'Data berhasil disimpan.');
```

| Param    | Type             | Default     | Description            |
| :------- | :--------------- | :---------- | :--------------------- |
| icon     | `SweetAlertIcon` | `'success'` | SweetAlert icon name.  |
| message  | `string`         | required    | Title text.            |

#### `messageError(icon?, message)` — toast variant

Shows a non-blocking toast in the top-right corner with a 3s timer and progress bar.
The toast pauses its timer on mouse hover. Use for transient error feedback where
you don't want to interrupt the user.

```javascript
messageError('error', 'Gagal menyimpan data, coba lagi.');
```

| Param    | Type             | Default   | Description            |
| :------- | :--------------- | :-------- | :--------------------- |
| icon     | `SweetAlertIcon` | `'error'` | SweetAlert icon name.  |
| message  | `string`         | required  | Toast title text.      |

#### `dialogError(message)`

Shows a modal error dialog with title `"Oops..."` and the given message. Use when
the user must acknowledge the error before continuing (e.g. blocking validation
failures).

```javascript
dialogError('Tidak dapat terhubung ke server.');
```

| Param    | Type     | Default  | Description           |
| :------- | :------- | :------- | :-------------------  |
| message  | `string` | required | Body text of dialog.  |

### Object Utilities

Helpers for converting between arrays of objects and keyed objects.

```javascript
import { arrayToObject, objectToArray } from '@bank-library/vuejs';
```

#### `arrayToObject(arr, keyField)`

Reduces an array of objects to an object keyed by `keyField`. Returns `{}` if `arr` is not an array.

```javascript
const users = [
  { id: 1, name: 'Andi' },
  { id: 2, name: 'Budi' }
];
arrayToObject(users, 'id');
// => { 1: { id: 1, name: 'Andi' }, 2: { id: 2, name: 'Budi' } }
```

| Param      | Type            | Default   | Description                                  |
| :--------- | :-------------- | :-------- | :------------------------------------------- |
| arr        | `T[]`           | required  | Source array.                                |
| keyField   | `keyof T`       | required  | Property of each item used as the object key. |

#### `objectToArray(objArr, keyObj?)`

Inverse of `arrayToObject`. Maps a keyed object back to an array, injecting the object key
as a property (default `'id'`) on each item. Returns `[]` for null/non-object input.

```javascript
const byId = { 1: { name: 'Andi' }, 2: { name: 'Budi' } };
objectToArray(byId);
// => [ { name: 'Andi', id: '1' }, { name: 'Budi', id: '2' } ]

objectToArray(byId, 'eid');
// => [ { name: 'Andi', eid: '1' }, { name: 'Budi', eid: '2' } ]
```

| Param      | Type                       | Default   | Description                                          |
| :--------- | :------------------------- | :-------- | :--------------------------------------------------- |
| objArr     | `Record<string, T>`        | required  | Source object map.                                   |
| keyObj     | `string`                   | `'id'`    | Property name to assign the object key to per item.  |

### Date Utilities

```javascript
import { validDate } from '@bank-library/vuejs';
```

#### `validDate(date)`

Returns `true` if `date` is a parseable date (string, number, or `Date` instance), `false` for
`null`/`undefined`/`''`/invalid inputs.

```javascript
validDate('2026-06-25');          // true
validDate(new Date());            // true
validDate('not-a-date');          // false
validDate(null);                  // false
validDate(undefined);             // false
validDate('');                    // false
```

| Param  | Type                  | Default   | Description                |
| :----- | :-------------------- | :-------- | :------------------------- |
| date   | `Date \| string \| number \| null \| undefined` | required | Value to validate. |

## Subpath Imports (Tree-Shaking)

Selain root `@bank-library/vuejs` (yang re-export semua fitur untuk backward compatibility), package ini juga menyediakan subpath import per domain. Pakai ini jika hanya butuh sebagian fitur agar kode komponen UI atau `callApi` tidak ikut masuk ke bundle produksi aplikasi Anda:

```javascript
// Hanya butuh function (validator, formatter, currency, date) — tanpa UI
import { formatRupiah, validateAccountNumber } from '@bank-library/vuejs/functions';

// Hanya butuh komponen UI Vue
import { BankAccountInput, CurrencyInput } from '@bank-library/vuejs/ui';

// Hanya butuh callApi
import { callApi } from '@bank-library/vuejs/api';
```

`callApi` menggunakan `fetch` bawaan browser — tidak ada dependency eksternal yang ikut terdownload.

## Rupiah Format Configuration

| Option | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `prefix` | `string` | `'Rp. '` | Currency symbol or label prepended to the number. |
| `decimalPlaces` | `number` | `0` | Number of decimal places to show. |
| `thousandSeparator` | `string` | `'.'` | Character separating thousands. |
| `decimalSeparator` | `string` | `','` | Character separating decimal fractions. |

## Requirements

- Vue.js ^3.0.0

## License

MIT
