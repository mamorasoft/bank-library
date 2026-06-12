<?php

namespace BankLibrary\Laravel\Function;

class CurrencyConverter
{
    /**
     * Format currency amount
     *
     * @param float $amount
     * @param string $currency
     * @param string $locale
     * @return string
     */
    public static function formatCurrency(float $amount, string $currency = 'USD', string $locale = 'en_US'): string
    {
        $formatter = new \NumberFormatter($locale, \NumberFormatter::CURRENCY);
        return $formatter->formatCurrency($amount, $currency);
    }
    
    /**
     * Convert amount between currencies
     *
     * @param float $amount
     * @param string $fromCurrency
     * @param string $toCurrency
     * @param array $rates Exchange rates
     * @return float
     */
    public static function convert(float $amount, string $fromCurrency, string $toCurrency, array $rates): float
    {
        if ($fromCurrency === $toCurrency) {
            return $amount;
        }
        
        // Convert to base currency (USD) first, then to target currency
        $inUSD = $amount / ($rates[$fromCurrency] ?? 1);
        return $inUSD * ($rates[$toCurrency] ?? 1);
    }
}
