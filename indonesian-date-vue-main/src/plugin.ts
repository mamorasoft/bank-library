import { App } from 'vue';
import { IndonesianDate } from './IndonesianDate';

export const IndonesianDatePlugin = {
  install(app: App): void {
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
  }
};

declare module '@vue/runtime-core' {
  export interface ComponentCustomProperties {
    $indoDate: (date?: Date | string | number | null, withDay?: boolean, shortMonth?: boolean) => string;
    $indoMonth: (date?: Date | string | number | null, short?: boolean) => string;
    $indoDay: (date?: Date | string | number | null, short?: boolean) => string;
    $indoFormat: (date: Date | string | number | null | undefined, formatStr: string) => string;
  }
}
