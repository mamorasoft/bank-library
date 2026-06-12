export class IndonesianDate {
  private static months: Record<number, string> = {
    1: 'Januari',
    2: 'Februari',
    3: 'Maret',
    4: 'April',
    5: 'Mei',
    6: 'Juni',
    7: 'Juli',
    8: 'Agustus',
    9: 'September',
    10: 'Oktober',
    11: 'November',
    12: 'Desember'
  };

  private static shortMonths: Record<number, string> = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agt',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des'
  };

  private static days: Record<number, string> = {
    0: 'Minggu',
    1: 'Senin',
    2: 'Selasa',
    3: 'Rabu',
    4: 'Kamis',
    5: 'Jumat',
    6: 'Sabtu'
  };

  private static shortDays: Record<number, string> = {
    0: 'Min',
    1: 'Sen',
    2: 'Sel',
    3: 'Rab',
    4: 'Kam',
    5: 'Jum',
    6: 'Sab'
  };

  /**
   * Format a date using Indonesian day and month names.
   * Supports standard formatting characters similar to PHP date().
   */
  public static format(date: Date | string | number | null | undefined, formatStr: string): string {
    const d = this.parseDate(date);
    let result = '';
    let escaped = false;

    const pad = (n: number): string => (n < 10 ? '0' + n : String(n));

    for (let i = 0; i < formatStr.length; i++) {
      const char = formatStr[i];

      if (escaped) {
        result += char;
        escaped = false;
        continue;
      }

      if (char === '\\') {
        escaped = true;
        continue;
      }

      switch (char) {
        case 'l':
          result += this.days[d.getDay()];
          break;
        case 'D':
          result += this.shortDays[d.getDay()];
          break;
        case 'F':
          result += this.months[d.getMonth() + 1];
          break;
        case 'M':
          result += this.shortMonths[d.getMonth() + 1];
          break;
        case 'Y':
          result += d.getFullYear();
          break;
        case 'y':
          result += String(d.getFullYear()).slice(-2);
          break;
        case 'm':
          result += pad(d.getMonth() + 1);
          break;
        case 'n':
          result += d.getMonth() + 1;
          break;
        case 'd':
          result += pad(d.getDate());
          break;
        case 'j':
          result += d.getDate();
          break;
        case 'H':
          result += pad(d.getHours());
          break;
        case 'G':
          result += d.getHours();
          break;
        case 'h': {
          const h = d.getHours() % 12;
          result += pad(h === 0 ? 12 : h);
          break;
        }
        case 'g': {
          const h = d.getHours() % 12;
          result += h === 0 ? 12 : h;
          break;
        }
        case 'i':
          result += pad(d.getMinutes());
          break;
        case 's':
          result += pad(d.getSeconds());
          break;
        case 'w':
          result += d.getDay();
          break;
        case 'a':
          result += d.getHours() >= 12 ? 'pm' : 'am';
          break;
        case 'A':
          result += d.getHours() >= 12 ? 'PM' : 'AM';
          break;
        default:
          result += char;
          break;
      }
    }

    return result;
  }

  /**
   * Get the Indonesian month name.
   */
  public static month(date?: Date | string | number | null, short = false): string {
    return this.format(date, short ? 'M' : 'F');
  }

  /**
   * Get the Indonesian day name.
   */
  public static day(date?: Date | string | number | null, short = false): string {
    return this.format(date, short ? 'D' : 'l');
  }

  /**
   * Get the year.
   */
  public static year(date?: Date | string | number | null): string {
    return this.format(date, 'Y');
  }

  /**
   * Get the full Indonesian date (e.g. "4 Juni 2026" or "Kamis, 4 Juni 2026").
   */
  public static date(
    date?: Date | string | number | null,
    withDay = false,
    shortMonth = false
  ): string {
    const dayFormat = shortMonth ? 'D, j' : 'l, j';
    const monthFormat = shortMonth ? 'M' : 'F';
    const formatStr = withDay ? `${dayFormat} ${monthFormat} Y` : `j ${monthFormat} Y`;

    return this.format(date, formatStr);
  }

  /**
   * Parse input into a Date object.
   */
  public static parseDate(date?: Date | string | number | null): Date {
    if (date === null || date === undefined) {
      return new Date();
    }

    if (date instanceof Date) {
      return new Date(date.getTime());
    }

    if (typeof date === 'number') {
      // If timestamp is in seconds, convert to milliseconds
      return new Date(date < 10000000000 ? date * 1000 : date);
    }

    if (typeof date === 'string') {
      const parsed = new Date(date);
      if (isNaN(parsed.getTime())) {
        throw new Error(`Invalid date string provided: ${date}`);
      }
      return parsed;
    }

    throw new Error('Invalid date type provided. Expected null, string, number, or Date.');
  }
}
