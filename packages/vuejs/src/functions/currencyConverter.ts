/**
 * Currency exchange rates interface
 */
export interface ExchangeRates {
  [currency: string]: number;
}

/**
 * Format currency amount
 * @param amount - The amount to format
 * @param currency - Currency code (e.g., 'USD', 'EUR')
 * @param locale - Locale string (e.g., 'en-US', 'id-ID')
 * @returns Formatted currency string
 */
export function formatCurrency(
  amount: number,
  currency: string = 'USD',
  locale: string = 'en-US'
): string {
  try {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currency,
    }).format(amount);
  } catch (error) {
    // Fallback formatting
    return `${currency} ${amount.toFixed(2)}`;
  }
}

/**
 * Convert amount between currencies
 * @param amount - The amount to convert
 * @param fromCurrency - Source currency code
 * @param toCurrency - Target currency code
 * @param rates - Exchange rates object
 * @returns Converted amount
 */
export function convertCurrency(
  amount: number,
  fromCurrency: string,
  toCurrency: string,
  rates: ExchangeRates
): number {
  if (fromCurrency === toCurrency) {
    return amount;
  }
  
  // Convert to base currency (USD) first, then to target currency
  const fromRate = rates[fromCurrency] || 1;
  const toRate = rates[toCurrency] || 1;
  
  const inUSD = amount / fromRate;
  return inUSD * toRate;
}

/**
 * Parse currency string to number
 * @param currencyString - String with currency formatting
 * @returns Parsed number
 */
export function parseCurrency(currencyString: string): number {
  // Remove currency symbols and separators, keep decimal point
  const cleaned = currencyString.replace(/[^0-9.-]/g, '');
  return parseFloat(cleaned) || 0;
}
