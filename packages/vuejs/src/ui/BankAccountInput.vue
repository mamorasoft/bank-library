<template>
  <div class="bank-account-input" :class="wrapperClass">
    <label v-if="label" :for="inputId" class="bank-account-label" :class="labelClass">
      {{ label }}
      <span v-if="required" class="required">*</span>
    </label>
    <div class="input-wrapper">
      <input
        :id="inputId"
        v-model="localValue"
        type="text"
        :placeholder="placeholder"
        :disabled="disabled"
        v-bind="$attrs"
        :class="['bank-account-field', { 'is-invalid': !isValid && localValue }]"
        @input="handleInput"
        @blur="handleBlur"
      />
      <span v-if="showValidation && localValue" class="validation-icon" :class="validationIconClass">
        <span v-if="isValid" class="valid">✓</span>
        <span v-else class="invalid">✗</span>
      </span>
    </div>
    <div v-if="errorMessage && !isValid && localValue" class="error-message" :class="errorClass">
      {{ errorMessage }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { validateAccountNumber } from '../functions/accountValidator';

defineOptions({
  inheritAttrs: false,
});

interface Props {
  modelValue?: string;
  label?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  showValidation?: boolean;
  errorMessage?: string;
  bankCode?: string;
  wrapperClass?: string | Record<string, boolean> | Array<unknown>;
  labelClass?: string | Record<string, boolean> | Array<unknown>;
  errorClass?: string | Record<string, boolean> | Array<unknown>;
  validationIconClass?: string | Record<string, boolean> | Array<unknown>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
  placeholder: 'Enter account number',
  showValidation: true,
  errorMessage: 'Invalid account number',
  bankCode: '',
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void;
  (e: 'validate', isValid: boolean): void;
}>();

const inputId = `bank-account-${Math.random().toString(36).substr(2, 9)}`;
const localValue = ref(props.modelValue);

const isValid = computed(() => {
  if (!localValue.value) return true;
  return validateAccountNumber(localValue.value, props.bankCode);
});

watch(() => props.modelValue, (newValue) => {
  localValue.value = newValue;
});

function handleInput() {
  emit('update:modelValue', localValue.value);
}

function handleBlur() {
  emit('validate', isValid.value);
}
</script>

<style scoped>
/* Struktural saja — tidak ada warna/border/spacing dekoratif, komponen unstyled by default */
.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.validation-icon {
  position: absolute;
  right: 0.75rem;
}
</style>
