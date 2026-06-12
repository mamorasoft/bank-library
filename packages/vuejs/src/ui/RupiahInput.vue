<template>
  <div class="rupiah-input">
    <label v-if="label" :for="inputId" class="rupiah-label">
      {{ label }}
      <span v-if="required" class="required">*</span>
    </label>
    <input
      :id="inputId"
      v-model="displayValue"
      v-rupiah="formatOptions"
      type="text"
      :placeholder="placeholder"
      :disabled="disabled"
      class="rupiah-field"
      @input="handleInput"
    />
    <div v-if="error" class="error-message">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { parseRupiah, FormatOptions } from '../functions/rupiahFormatter';
import { vRupiah } from '../functions/rupiahDirective';

interface Props {
  modelValue?: number | string;
  label?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  prefix?: string;
  decimalPlaces?: number;
  thousandSeparator?: string;
  decimalSeparator?: string;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
  placeholder: 'Rp. 0',
  prefix: 'Rp. ',
  decimalPlaces: 0,
  thousandSeparator: '.',
  decimalSeparator: ',',
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void;
  (e: 'update:numericValue', value: number): void;
}>();

const inputId = `rupiah-${Math.random().toString(36).substr(2, 9)}`;
const displayValue = ref('');

const formatOptions = computed<FormatOptions>(() => ({
  prefix: props.prefix,
  decimalPlaces: props.decimalPlaces,
  thousandSeparator: props.thousandSeparator,
  decimalSeparator: props.decimalSeparator,
}));

watch(() => props.modelValue, (newValue) => {
  if (newValue !== displayValue.value) {
    displayValue.value = String(newValue);
  }
}, { immediate: true });

function handleInput() {
  emit('update:modelValue', displayValue.value);
  const numericValue = parseRupiah(displayValue.value, formatOptions.value);
  emit('update:numericValue', numericValue);
}
</script>

<style scoped>
.rupiah-input {
  margin-bottom: 1rem;
}

.rupiah-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #374151;
}

.required {
  color: #ef4444;
}

.rupiah-field {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 0.375rem;
  font-size: 1rem;
  transition: border-color 0.2s;
}

.rupiah-field:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.rupiah-field:disabled {
  background-color: #f3f4f6;
  cursor: not-allowed;
  color: #9ca3af;
}

.error-message {
  margin-top: 0.25rem;
  font-size: 0.875rem;
  color: #ef4444;
}
</style>
