/**
 * Validate bank account number format
 * @param accountNumber - The account number to validate
 * @param bankCode - Optional bank code
 * @returns boolean indicating if the account number is valid
 */
export function validateAccountNumber(accountNumber: string, bankCode: string = ''): boolean {
  // Remove any spaces or special characters
  const cleanNumber = accountNumber.replace(/[^0-9]/g, '');
  
  // Basic validation: account number should be between 8-16 digits
  if (cleanNumber.length < 8 || cleanNumber.length > 16) {
    return false;
  }
  
  return true;
}

/**
 * Validate IBAN (International Bank Account Number)
 * @param iban - The IBAN to validate
 * @returns boolean indicating if the IBAN is valid
 */
export function validateIBAN(iban: string): boolean {
  const cleanIban = iban.toUpperCase().replace(/\s/g, '');
  
  if (cleanIban.length < 15 || cleanIban.length > 34) {
    return false;
  }
  
  // Move first 4 characters to the end
  const rearranged = cleanIban.slice(4) + cleanIban.slice(0, 4);
  
  // Replace letters with numbers (A=10, B=11, ..., Z=35)
  let numericIban = '';
  for (let i = 0; i < rearranged.length; i++) {
    const char = rearranged[i];
    if (/[A-Z]/.test(char)) {
      numericIban += (char.charCodeAt(0) - 'A'.charCodeAt(0) + 10).toString();
    } else {
      numericIban += char;
    }
  }
  
  // Calculate mod 97
  let remainder = numericIban;
  while (remainder.length > 2) {
    const block = remainder.slice(0, 9);
    remainder = (parseInt(block, 10) % 97).toString() + remainder.slice(block.length);
  }
  
  return parseInt(remainder, 10) % 97 === 1;
}

/**
 * Format account number with spaces for readability
 * @param accountNumber - The account number to format
 * @param groupSize - Number of digits per group (default: 4)
 * @returns Formatted account number
 */
export function formatAccountNumber(accountNumber: string, groupSize: number = 4): string {
  const cleanNumber = accountNumber.replace(/[^0-9]/g, '');
  return cleanNumber.match(new RegExp(`.{1,${groupSize}}`, 'g'))?.join(' ') || cleanNumber;
}
