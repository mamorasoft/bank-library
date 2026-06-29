<template>
  <div class="rupiah-input" :class="wrapperClass">
    <label v-if="label" :for="inputId" class="rupiah-label" :class="labelClass">
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
      v-bind="$attrs"
      class="rupiah-field"
      @input="handleInput"
    />
    <div v-if="error" class="error-message" :class="errorClass">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { parseRupiah, FormatOptions } from '../functions/rupiahFormatter';
import { vRupiah } from '../functions/rupiahDirective';

defineOptions({
  inheritAttrs: false,
});

interface RupiahInputProps {
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
  wrapperClass?: string | Record<string, boolean> | Array<unknown>;
  labelClass?: string | Record<string, boolean> | Array<unknown>;
  errorClass?: string | Record<string, boolean> | Array<unknown>;
}

const props = withDefaults(defineProps<RupiahInputProps>(), {
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

