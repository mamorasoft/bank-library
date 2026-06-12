import { describe, it, expect } from 'vitest';
import { IndonesianDate, indoDate, indoMonth, indoDay, indoFormat } from '../src';

describe('IndonesianDate', () => {
  const testDate = new Date('2026-06-04T10:15:30'); // Thursday, June 4, 2026

  it('formats dates using PHP-style characters correctly', () => {
    expect(IndonesianDate.format(testDate, 'l, j F Y')).toBe('Kamis, 4 Juni 2026');
    expect(IndonesianDate.format(testDate, 'D, d M y')).toBe('Kam, 04 Jun 26');
    expect(IndonesianDate.format(testDate, 'H:i:s')).toBe('10:15:30');
    expect(IndonesianDate.format(testDate, 'Y-m-d H:i:s')).toBe('2026-06-04 10:15:30');
    expect(IndonesianDate.format(testDate, '\\D\\a\\t\\e: d-m-Y')).toBe('Date: 04-06-2026');
  });

  it('retrieves correct day and month names', () => {
    expect(IndonesianDate.day(testDate)).toBe('Kamis');
    expect(IndonesianDate.day(testDate, true)).toBe('Kam');
    expect(IndonesianDate.month(testDate)).toBe('Juni');
    expect(IndonesianDate.month(testDate, true)).toBe('Jun');
  });

  it('retrieves correct full date formatting', () => {
    expect(IndonesianDate.date(testDate)).toBe('4 Juni 2026');
    expect(IndonesianDate.date(testDate, true)).toBe('Kamis, 4 Juni 2026');
    expect(IndonesianDate.date(testDate, true, true)).toBe('Kam, 4 Jun 2026');
  });

  it('correctly parses inputs (Date, number, string, null)', () => {
    expect(IndonesianDate.parseDate('2026-06-04').getDate()).toBe(4);
    
    // Seconds timestamp
    const epochSecs = Math.floor(testDate.getTime() / 1000);
    expect(IndonesianDate.parseDate(epochSecs).getFullYear()).toBe(2026);
    
    // Milliseconds timestamp
    expect(IndonesianDate.parseDate(testDate.getTime()).getFullYear()).toBe(2026);
    
    // Default to current date when null/undefined
    expect(IndonesianDate.parseDate(null)).toBeInstanceOf(Date);
  });

  it('provides helper functions matching the core class methods', () => {
    expect(indoDate(testDate, true)).toBe('Kamis, 4 Juni 2026');
    expect(indoMonth(testDate)).toBe('Juni');
    expect(indoDay(testDate)).toBe('Kamis');
    expect(indoFormat(testDate, 'Y-m-d')).toBe('2026-06-04');
  });
});
