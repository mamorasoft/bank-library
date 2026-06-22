import { describe, it, expect } from 'vitest';
import { mount } from '@vue/test-utils';
import RupiahInput from '../src/ui/RupiahInput.vue';

describe('RupiahInput overridability', () => {
  it('forwards class attribute to the input element, not the wrapper', () => {
    const wrapper = mount(RupiahInput, {
      attrs: { class: 'my-custom-input' },
    });

    const input = wrapper.find('input');
    expect(input.classes()).toContain('my-custom-input');
    expect(input.classes()).toContain('rupiah-field');
    expect(wrapper.classes()).not.toContain('my-custom-input');
  });

  it('applies wrapperClass, labelClass, and errorClass props', () => {
    const wrapper = mount(RupiahInput, {
      props: {
        label: 'Jumlah',
        error: 'Wajib diisi',
        wrapperClass: 'custom-wrapper',
        labelClass: 'custom-label',
        errorClass: 'custom-error',
      },
    });

    expect(wrapper.classes()).toContain('custom-wrapper');
    expect(wrapper.find('label').classes()).toContain('custom-label');
    expect(wrapper.find('.error-message').classes()).toContain('custom-error');
  });
});
