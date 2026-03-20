using CatelogService as service from '../../srv/CatelogService';

// Add annotatations
// Filter bar annotations

annotate service.PurchaseOrderSet with @(

// Add fields to the screen for Filtering

    UI.SelectionFields: [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS
    ],

// Add fields to the table data

    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatelogService.boost',
            Label : 'boost',
            Inline : true,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
            Criticality: colorIcon
        }
    ],

// Header info

    UI.HeaderInfo: {
        // Title of the table - First screen
        TypeName : 'Purchase Order',
        TypeNamePlural : 'Purchase orders',
        // Second screen title section
        Title: {Value: PO_ID},
        Description: {Value : PARTNER_GUID.COMPANY_NAME}
    },

// Add a tab strip in the second page

    UI.Facets:[
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets : [
                {
                    Label : 'Basic Info',
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification',
                },
                {
                    Label : 'Pricing Details',
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#Pricing',
                },
                {
                    Label : 'Status Info',
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#statusInfo',
                },
            ],
        },
        {
            Label : 'Items',
            $Type : 'UI.ReferenceFacet',
            Target : 'items/@UI.LineItem',
        },
    ],

    // default block which is always and always one - Identification
    // contains the group of fields
    UI.Identification : [
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : NOTE,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },        
    ],
    
    // Field group block
    UI.FieldGroup #Pricing: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
        ],
        
    },

   // Field group for status data

   UI.FieldGroup #statusInfo : {
    Data :[
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
        },
        {
            $Type : 'UI.DataField',
            Value : LIFECYCLE_STATUS,
        },
    ]
   } 
    
);

// item data

annotate service.PurchaseItemsSet with @(

    UI.HeaderInfo : {
        TypeName: 'PO Items',
        TypeNamePlural: 'Purchase order items',
        Title: { Value: PO_ITEM_POS},
        Description: {Value: PRODUCT_GUID.DESCRIPTION}
    },

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
    ],

    UI.Facets: [
        {
            Label : 'Item details',
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.Identification',
        },
    ],

    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
    ]
);

// annotate meaningful name header
annotate service.PurchaseOrderSet with { 
    @(
        Common.Text: overallStatus,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'StatusCodeSet',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : OVERALL_STATUS,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Status',
        },
        Common.ValueListWithFixedValues : true,
    )
    OVERALL_STATUS; 
    @Common.Text: NOTE
    PO_ID;
    @Common.Text: PARTNER_GUID.COMPANY_NAME
    @Valuelist.entity : service.businessPartnerSet
    
    // @Common : { TextArrangement : #TextOnly }
    PARTNER_GUID;
};

annotate service.PurchaseItemsSet with {
    @Common.Text: PRODUCT_GUID.DESCRIPTION 
    @Valuelist.entity : service.ProudctSet
    PRODUCT_GUID;
};

// Design value help for BP Guid, PRODUCT Guid

@cds.odata.valuelist
annotate service.businessPartnerSet with @(
    UI.Identification :[
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        },
    ]
);

@cds.odata.valuelist
annotate service.ProudctSet with @(
    UI.Identification :[
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
    ]
) ;

annotate service.StatusCodeSet with {
    code @Common.Text : value
};

