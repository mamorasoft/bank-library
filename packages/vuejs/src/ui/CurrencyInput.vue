<template>
  <div class="currency-input" :class="wrapperClass">
    <label v-if="label" :for="inputId" class="currency-label" :class="labelClass">
      {{ label }}
      <span v-if="required" class="required">*</span>
    </label>
    <div class="input-wrapper">
      <span class="currency-symbol" :class="currencySymbolClass">{{ currencySymbol }}</span>
      <input
        :id="inputId"
        v-model="displayValue"
        type="text"
        :placeholder="placeholder"
        :disabled="disabled"
        v-bind="$attrs"
        class="currency-field"
        @input="handleInput"
        @blur="handleBlur"
        @focus="handleFocus"
      />
    </div>
    <div v-if="showConverted && convertedAmount !== null" class="converted-amount" :class="convertedAmountClass">
      ≈ {{ formattedConvertedAmount }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { formatCurrency } from '../functions/currencyConverter';

defineOptions({
  inheritAttrs: false,
});

interface Props {
  modelValue?: number;
  label?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  currency?: string;
  locale?: string;
  showConverted?: boolean;
  convertedCurrency?: string;
  conversionRate?: number;
  wrapperClass?: string | Record<string, boolean> | Array<unknown>;
  labelClass?: string | Record<string, boolean> | Array<unknown>;
  currencySymbolClass?: string | Record<string, boolean> | Array<unknown>;
  convertedAmountClass?: string | Record<string, boolean> | Array<unknown>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: 0,
  placeholder: '0.00',
  currency: 'USD',
  locale: 'en-US',
  showConverted: false,
  convertedCurrency: 'EUR',
  conversionRate: 1,
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: number): void;
}>();

const inputId = `currency-${Math.random().toString(36).substr(2, 9)}`;
const displayValue = ref('');
const isFocused = ref(false);

const currencySymbol = computed(() => {
  try {
    const formatted = formatCurrency(0, props.currency, props.locale);
    return formatted.replace(/[\d.,\s]/g, '');
  } catch {
    return props.currency;
  }
});

const convertedAmount = computed(() => {
  if (!props.showConverted || !props.modelValue) return null;
  return props.modelValue * props.conversionRate;
});

const formattedConvertedAmount = computed(() => {
  if (convertedAmount.value === null) return '';
  return formatCurrency(convertedAmount.value, props.convertedCurrency, props.locale);
});

watch(() => props.modelValue, (newValue) => {
  if (!isFocused.value) {
    displayValue.value = newValue ? newValue.toFixed(2) : '';
  }
}, { immediate: true });

function handleInput(event: Event) {
  const target = event.target as HTMLInputElement;
  const value = target.value.replace(/[^0-9.]/g, '');
  displayValue.value = value;
  
  const numericValue = parseFloat(value) || 0;
  emit('update:modelValue', numericValue);
}

function handleFocus() {
  isFocused.value = true;
}

function handleBlur() {
  isFocused.value = false;
  const numericValue = parseFloat(displayValue.value) || 0;
  displayValue.value = numericValue.toFixed(2);
}
</script>

<style scoped>
/* Struktural saja — tidak ada warna/border/spacing dekoratif, komponen unstyled by default */
.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.currency-symbol {
  position: absolute;
  left: 0.75rem;
}
</style>
