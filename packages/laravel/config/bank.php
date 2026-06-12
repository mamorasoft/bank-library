<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Default Currency
    |--------------------------------------------------------------------------
    |
    | This option defines the default currency for banking operations.
    |
    */
    'default_currency' => env('BANK_DEFAULT_CURRENCY', 'USD'),

    /*
    |--------------------------------------------------------------------------
    | Supported Bank Codes
    |--------------------------------------------------------------------------
    |
    | List of supported bank codes for validation.
    |
    */
    'supported_banks' => [
        'BCA' => 'Bank Central Asia',
        'BNI' => 'Bank Negara Indonesia',
        'BRI' => 'Bank Rakyat Indonesia',
        'MANDIRI' => 'Bank Mandiri',
    ],
];
