import { describe, it, expect } from 'vitest';
import { mount } from '@vue/test-utils';
import CurrencyInput from '../src/ui/CurrencyInput.vue';

describe('CurrencyInput overridability', () => {
  it('forwards class attribute to the input element, not the wrapper', () => {
    const wrapper = mount(CurrencyInput, {
      attrs: { class: 'my-custom-input' },
    });

    const input = wrapper.find('input');
    expect(input.classes()).toContain('my-custom-input');
    expect(input.classes()).toContain('currency-field');
    expect(wrapper.classes()).not.toContain('my-custom-input');
  });

  it('applies wrapperClass, labelClass, and currencySymbolClass props', () => {
    const wrapper = mount(CurrencyInput, {
      props: {
        label: 'Amount',
        wrapperClass: 'custom-wrapper',
        labelClass: 'custom-label',
        currencySymbolClass: 'custom-symbol',
      },
    });

    expect(wrapper.classes()).toContain('custom-wrapper');
    expect(wrapper.find('label').classes()).toContain('custom-label');
    expect(wrapper.find('.currency-symbol').classes()).toContain('custom-symbol');
  });

  it('applies convertedAmountClass when showConverted is enabled', () => {
    const wrapper = mount(CurrencyInput, {
      props: {
        modelValue: 100,
        showConverted: true,
        conversionRate: 2,
        convertedAmountClass: 'custom-converted',
      },
    });

    expect(wrapper.find('.converted-amount').classes()).toContain('custom-converted');
  });
});
