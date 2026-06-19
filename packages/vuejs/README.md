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
- Provide global helpers `$formatRupiah` and `$parseRupiah`

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
