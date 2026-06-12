<template>
  <div class="currency-input">
    <label v-if="label" :for="inputId" class="currency-label">
      {{ label }}
      <span v-if="required" class="required">*</span>
    </label>
    <div class="input-wrapper">
      <span class="currency-symbol">{{ currencySymbol }}</span>
      <input
        :id="inputId"
        v-model="displayValue"
        type="text"
        :placeholder="placeholder"
        :disabled="disabled"
        @input="handleInput"
        @blur="handleBlur"
        @focus="handleFocus"
        class="currency-field"
      />
    </div>
    <div v-if="showConverted && convertedAmount !== null" class="converted-amount">
      ≈ {{ formattedConvertedAmount }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { formatCurrency } from '../functions/currencyConverter';

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
.currency-input {
  margin-bottom: 1rem;
}

.currency-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.required {
  color: #ef4444;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.currency-symbol {
  position: absolute;
  left: 0.75rem;
  color: #6b7280;
  font-weight: 500;
}

.currency-field {
  width: 100%;
  padding: 0.75rem 0.75rem 0.75rem 2.5rem;
  border: 1px solid #d1d5db;
  border-radius: 0.375rem;
  font-size: 1rem;
  transition: border-color 0.2s;
}

.currency-field:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.currency-field:disabled {
  background-color: #f3f4f6;
  cursor: not-allowed;
}

.converted-amount {
  margin-top: 0.25rem;
  font-size: 0.875rem;
  color: #6b7280;
}
</style>
