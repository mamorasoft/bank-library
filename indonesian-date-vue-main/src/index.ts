import { IndonesianDate } from './IndonesianDate';
import { IndonesianDatePlugin } from './plugin';

export { IndonesianDate, IndonesianDatePlugin };

/**
 * Format a date into Indonesian format.
 * Mimics the php helper function indo_date().
 */
export function indoDate(
  date?: Date | string | number | null,
  withDay = false,
  shortMonth = false
): string {
  return IndonesianDate.date(date, withDay, shortMonth);
}

/**
 * Get Indonesian month name.
 * Mimics the php helper function indo_month().
 */
export function indoMonth(
  date?: Date | string | number | null,
  short = false
): string {
  return IndonesianDate.month(date, short);
}

/**
 * Get Indonesian day name.
 * Mimics the php helper function indo_day().
 */
export function indoDay(
  date?: Date | string | number | null,
  short = false
): string {
  return IndonesianDate.day(date, short);
}

/**
 * Format date using a custom pattern mimicking PHP's format specifiers.
 */
export function indoFormat(
  date: Date | string | number | null | undefined,
  formatStr: string
): string {
  return IndonesianDate.format(date, formatStr);
}
