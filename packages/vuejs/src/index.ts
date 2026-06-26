import type { App } from 'vue';
import * as components from './ui';
import * as functions from './functions';
import { vRupiah } from './functions/rupiahDirective';
import { formatRupiah, parseRupiah, FormatOptions } from './functions/rupiahFormatter';
import { IndonesianDate } from './functions/indonesianDate';
import { responsiveColsTailwind, getDefaultCol, _setGlobalGridOptions, GridColOptions } from './functions/gridColumns';

export * from './ui';
export * from './functions';
export * from './api';

export interface BankLibraryOptions extends FormatOptions, GridColOptions {}

export default {
  install(app: App, globalOptions?: BankLibraryOptions) {
    // Register components
    Object.entries(components).forEach(([name, component]) => {
      if (name !== 'default') {
        app.component(name, component);
      }
    });

    // Register v-rupiah directive globally with options merging
    app.directive('rupiah', {
      mounted(el, binding) {
        const options = { ...globalOptions, ...binding.value };
        vRupiah.mounted!(el, { ...binding, value: options }, binding.instance as any, null as any);
      },
      updated(el, binding) {
        const options = { ...globalOptions, ...binding.value };
        vRupiah.updated!(el, { ...binding, value: options }, binding.instance as any, null as any);
      },
      unmounted(el, binding) {
        if (vRupiah.unmounted) {
          vRupiah.unmounted(el, binding, binding.instance as any, null as any);
        }
      }
    });

    // Provide global helper functions
    app.config.globalProperties.$formatRupiah = (value: number | string, options?: FormatOptions) => {
      return formatRupiah(value, { ...globalOptions, ...options });
    };
    
    app.config.globalProperties.$parseRupiah = parseRupiah;

    // Register Indonesian Date helper functions globally
    app.config.globalProperties.$indoDate = (
      date?: Date | string | number | null,
      withDay = false,
      shortMonth = false
    ): string => IndonesianDate.date(date, withDay, shortMonth);

    app.config.globalProperties.$indoMonth = (
      date?: Date | string | number | null,
      short = false
    ): string => IndonesianDate.month(date, short);

    app.config.globalProperties.$indoDay = (
      date?: Date | string | number | null,
      short = false
    ): string => IndonesianDate.day(date, short);

    app.config.globalProperties.$indoFormat = (
      date: Date | string | number | null | undefined,
      formatStr: string
    ): string => IndonesianDate.format(date, formatStr);

    // Store global grid column options (read by getDefaultCol())
    _setGlobalGridOptions({ defaultCol: globalOptions?.defaultCol });

    // Register grid column helpers globally
    app.config.globalProperties.$getDefaultCol = getDefaultCol;
    app.config.globalProperties.$responsiveColsTailwind = responsiveColsTailwind;
  },
};

declare module '@vue/runtime-core' {
  export interface ComponentCustomProperties {
    $formatRupiah: (value: number | string, options?: FormatOptions) => string;
    $parseRupiah: (value: string | number) => number;
    $indoDate: (date?: Date | string | number | null, withDay?: boolean, shortMonth?: boolean) => string;
    $indoMonth: (date?: Date | string | number | null, short?: boolean) => string;
    $indoDay: (date?: Date | string | number | null, short?: boolean) => string;
    $indoFormat: (date: Date | string | number | null | undefined, formatStr: string) => string;
    $getDefaultCol: () => number | undefined;
    $responsiveColsTailwind: (defaultCol: number, step: number, max: number) => string;
  }
}

