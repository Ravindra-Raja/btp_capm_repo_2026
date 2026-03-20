namespace myGlobal.common;
using { Currency } from '@sap/cds/common';

// Similar concepts in Data element
type Guid:  String(32);

// Domain fixed values
type Gender : String(2) enum{
    male = 'M';
    female = 'F';
    undisclosed = 'U';
};

// Reference field
type AmountT : Decimal(10, 2) @(
    Semantic.amount.currencycode: 'CURRENCY_code'
);

// Custom Structure
aspect amount {
    CURRENCY: Currency;
    GROSS_AMOUNT: AmountT @(title: '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT: AmountT @(title: '{i18n>NET_AMOUNT}');
    TAX_AMOUNT: AmountT @(title: '{i18n>TAX_AMOUNT}');
}

type phoneNumber : String(30) @assert.format : '^[6-9]\d{9}$';
type email : String(250) @assert.format : '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';


