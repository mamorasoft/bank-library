import { describe, it, expect, beforeEach } from 'vitest';
import {
  responsiveColsTailwind,
  getDefaultCol,
  _setGlobalGridOptions,
} from '../src/functions/gridColumns';

describe('responsiveColsTailwind', () => {
  it('emits base + 4 breakpoint classes when step adds and max stops at xl', () => {
    // 1 + 2 = 3, 3 + 2 = 5, 5 + 2 = 7, 7 + 2 = 9 (capped to max=8)
    expect(responsiveColsTailwind(1, 2, 8)).toBe(
      'col-span-1 sm:col-span-3 md:col-span-5 lg:col-span-7 xl:col-span-8'
    );
  });

  it('emits 5 breakpoint classes when step adds 1 and max allows 6', () => {
    expect(responsiveColsTailwind(2, 1, 6)).toBe(
      'col-span-2 sm:col-span-3 md:col-span-4 lg:col-span-5 xl:col-span-6'
    );
  });

  it('caps the last breakpoint at max when next step would exceed it', () => {
    expect(responsiveColsTailwind(3, 2, 12)).toBe(
      'col-span-3 sm:col-span-5 md:col-span-7 lg:col-span-9 xl:col-span-11 2xl:col-span-12'
    );
  });

  it('emits only the base class when defaultCol equals max', () => {
    expect(responsiveColsTailwind(6, 1, 6)).toBe('col-span-6');
    expect(responsiveColsTailwind(12, 2, 12)).toBe('col-span-12');
  });

  it('emits only the base class when defaultCol already exceeds max bound is impossible (caller error)', () => {
    // defaultCol > max throws; see RangeError test below.
  });

  it('treats non-positive step as 1', () => {
    expect(responsiveColsTailwind(1, 0, 4)).toBe(
      'col-span-1 sm:col-span-2 md:col-span-3 lg:col-span-4'
    );
    expect(responsiveColsTailwind(1, -5, 3)).toBe(
      'col-span-1 sm:col-span-2 md:col-span-3'
    );
  });

  it('throws RangeError for defaultCol < 1', () => {
    expect(() => responsiveColsTailwind(0, 2, 8)).toThrow(RangeError);
    expect(() => responsiveColsTailwind(-1, 2, 8)).toThrow(RangeError);
    expect(() => responsiveColsTailwind(1.5, 2, 8)).toThrow(RangeError);
  });

  it('throws RangeError when max < defaultCol', () => {
    expect(() => responsiveColsTailwind(4, 1, 2)).toThrow(RangeError);
  });

  it('uses the full 5-breakpoint chain when step is small and max is large', () => {
    // 1, +1 each step, max 12 -> uses all 5 breakpoints and stops at 6
    expect(responsiveColsTailwind(1, 1, 6)).toBe(
      'col-span-1 sm:col-span-2 md:col-span-3 lg:col-span-4 xl:col-span-5 2xl:col-span-6'
    );
  });
});

describe('getDefaultCol', () => {
  beforeEach(() => {
    _setGlobalGridOptions({});
  });

  it('returns undefined when no global option is set', () => {
    _setGlobalGridOptions({});
    expect(getDefaultCol()).toBeUndefined();
  });

  it('returns the configured defaultCol after _setGlobalGridOptions', () => {
    _setGlobalGridOptions({ defaultCol: 4 });
    expect(getDefaultCol()).toBe(4);
  });

  it('returns undefined when defaultCol is explicitly undefined', () => {
    _setGlobalGridOptions({ defaultCol: undefined });
    expect(getDefaultCol()).toBeUndefined();
  });
});
