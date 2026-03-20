namespace myView.cds;
using { myfirst.db.master, myfirst.db.transaction  } from './datamodel';

context CDSViews {
    define view![POWorkList] as 
        select from transaction.purchaseorder{
            key PO_ID as ![PurchaseOrderId],
            key items.PO_ITEM_POS as ![ItemPositition],
            PARTNER_GUID.BP_ID as ![PartnerId],
            PARTNER_GUID.COMPANY_NAME as ![CompanyName],
            GROSS_AMOUNT as ![GroosAmount],
            NET_AMOUNT as ![NetAmount], 
            TAX_AMOUNT as ![TaxAmount],
            CURRENCY as ![Currency],
            OVERALL_STATUS as ![OverallStatus],
            items.PRODUCT_GUID.PRODUCT_ID as ![ProductId],
            items.PRODUCT_GUID.DESCRIPTION as ![Description],
            PARTNER_GUID.ADDRESS_GUID.CITY as ![City],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
    };

    define view![ProductHelpValue] as
        select from master.product {
            @EndUserText.label:[
                {
                    language: 'EN',
                    text: 'Product Id'
                },
                {
                    language: 'DE',
                    text: 'Prodkt Id'
                }
            ]
            PRODUCT_ID as ![Product Id],
            @EndUserText.label:[
                {
                    language: 'EN',
                    text: 'Product Description'
                },
                {
                    language: 'DE',
                    text: 'Prodkt Descripon'
                }
            ]            
            DESCRIPTION as ![Description],
        };

    define view![ItemsView] as
        select from transaction.poitems {
            ID as ![PoItemId],
            PARENT_KEY.PARTNER_GUID.NODE_KEY as ![CustomerId],
            PRODUCT_GUID.NODE_KEY as ![ProductId],
            CURRENCY as ![Currency],
            GROSS_AMOUNT as ![GrossAmount],
            NET_AMOUNT as ![NetAmount],
            TAX_AMOUNT as ![TaxAmount],
            PARENT_KEY.OVERALL_STATUS as ![Status],
        };

    define view![ProductView] as select from master.product
    // Mixin is a keyword to define lose coupling
    // which will never load the data from product and items together 
    // it will load product data and later ONDEMAND does the join to load items data
    mixin {
        // View on view
        PO_ORDER : Association to many ItemsView on PO_ORDER.ProductId = $projection.ProductId
    } into {
        NODE_KEY as![ProductId],
        DESCRIPTION as ![Descripon],
        PRICE as ![Price],
        SUPPLIER_GUID.BP_ID as ![SupplierId],
        SUPPLIER_GUID.COMPANY_NAME as ![CompanyName],
        SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
        // Exposed association - @ runtime we load on-demand 
        PO_ORDER as ![To_Items],
    };

    define view![CProductValuesView] as 
        select from ProductView {
            ProductId,
            Country,
            round(sum(To_Items.GrossAmount), 2) as![TotalAmount],
            To_Items.Currency as![Currency],
        } group by ProductId, Country, To_Items.Currency; 
}
