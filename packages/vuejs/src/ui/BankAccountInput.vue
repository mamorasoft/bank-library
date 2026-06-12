<template>
  <div class="bank-account-input">
    <label v-if="label" :for="inputId" class="bank-account-label">
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
        :class="{ 'is-invalid': !isValid && localValue }"
        @input="handleInput"
        @blur="handleBlur"
        class="bank-account-field"
      />
      <span v-if="showValidation && localValue" class="validation-icon">
        <span v-if="isValid" class="valid">✓</span>
        <span v-else class="invalid">✗</span>
      </span>
    </div>
    <div v-if="errorMessage && !isValid && localValue" class="error-message">
      {{ errorMessage }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { validateAccountNumber } from '../functions/accountValidator';

interface Props {
  modelValue?: string;
  label?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  showValidation?: boolean;
  errorMessage?: string;
  bankCode?: string;
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
.bank-account-input {
  margin-bottom: 1rem;
}

.bank-account-label {
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

.bank-account-field {
  width: 100%;
  padding: 0.75rem 2.5rem 0.75rem 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 0.375rem;
  font-size: 1rem;
  transition: border-color 0.2s;
}

.bank-account-field:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.bank-account-field.is-invalid {
  border-color: #ef4444;
}

.bank-account-field:disabled {
  background-color: #f3f4f6;
  cursor: not-allowed;
}

.validation-icon {
  position: absolute;
  right: 0.75rem;
  font-weight: bold;
}

.valid {
  color: #10b981;
}

.invalid {
  color: #ef4444;
}

.error-message {
  margin-top: 0.25rem;
  font-size: 0.875rem;
  color: #ef4444;
}
</style>
