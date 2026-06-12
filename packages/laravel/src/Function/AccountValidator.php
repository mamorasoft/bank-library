<?php

namespace BankLibrary\Laravel\Function;

class AccountValidator
{
    /**
     * Validate bank account number format
     *
     * @param string $accountNumber
     * @param string $bankCode
     * @return bool
     */
    public static function validateAccountNumber(string $accountNumber, string $bankCode = ''): bool
    {
        // Remove any spaces or special characters
        $accountNumber = preg_replace('/[^0-9]/', '', $accountNumber);
        
        // Basic validation: account number should be between 8-16 digits
        if (strlen($accountNumber) < 8 || strlen($accountNumber) > 16) {
            return false;
        }
        
        return true;
    }
    
    /**
     * Validate IBAN (International Bank Account Number)
     *
     * @param string $iban
     * @return bool
     */
    public static function validateIBAN(string $iban): bool
    {
        $iban = strtoupper(str_replace(' ', '', $iban));
        
        if (strlen($iban) < 15 || strlen($iban) > 34) {
            return false;
        }
        
        // Move first 4 characters to the end
        $rearranged = substr($iban, 4) . substr($iban, 0, 4);
        
        // Replace letters with numbers (A=10, B=11, ..., Z=35)
        $numericIban = '';
        for ($i = 0; $i < strlen($rearranged); $i++) {
            $char = $rearranged[$i];
            if (ctype_alpha($char)) {
                $numericIban .= (string)(ord($char) - ord('A') + 10);
            } else {
                $numericIban .= $char;
            }
        }
        
        // Calculate mod 97
        return bcmod($numericIban, '97') === '1';
    }
}
