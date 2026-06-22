import { describe, it, expect } from 'vitest';
import { mount } from '@vue/test-utils';
import BankAccountInput from '../src/ui/BankAccountInput.vue';

describe('BankAccountInput overridability', () => {
  it('forwards class attribute to the input element, not the wrapper', () => {
    const wrapper = mount(BankAccountInput, {
      attrs: { class: 'my-custom-input' },
    });

    const input = wrapper.find('input');
    expect(input.classes()).toContain('my-custom-input');
    expect(input.classes()).toContain('bank-account-field');
    expect(wrapper.classes()).not.toContain('my-custom-input');
  });

  it('applies wrapperClass, labelClass, and errorClass props to their respective elements', () => {
    const wrapper = mount(BankAccountInput, {
      props: {
        label: 'No. Rekening',
        wrapperClass: 'custom-wrapper',
        labelClass: 'custom-label',
        errorClass: 'custom-error',
        modelValue: 'invalid',
      },
    });

    expect(wrapper.classes()).toContain('custom-wrapper');
    expect(wrapper.find('label').classes()).toContain('custom-label');
    expect(wrapper.find('.error-message').classes()).toContain('custom-error');
  });

  it('renders correctly without any override props (default behavior preserved)', () => {
    const wrapper = mount(BankAccountInput, {
      props: { modelValue: '1234567890' },
    });

    expect(wrapper.find('input').exists()).toBe(true);
    expect(wrapper.find('.validation-icon').exists()).toBe(true);
  });
});
