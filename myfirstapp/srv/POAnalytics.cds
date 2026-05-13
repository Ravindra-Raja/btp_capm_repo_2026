using { myView.cds } from '../db/CDSViews';

service POAnalytics @(path:'POAnalytics') {

entity PurchaseAnalytics as projection on cds.CDSViews.POWorkList{
    *
};  

    // Need to add the aggregatio entity

 annotate POAnalytics.PurchaseAnalytics with @(
    Aggregation.ApplySupported: {
        Transformations : [
            'aggregate',
            'identity',
            'topcount',
            'bottomcount',
            'concat',
            'groupby',
            'filter',
            'expand',
            'search'
        ],
        GroupableProperties: [
            CompanyName,
            Description,
            Currency,
            Country
        ],
        AggregatableProperties : [
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : GroosAmount,
            }
        ],
    },
    Analytics : {
        AggregatedProperty #GroosAmount : {
            $Type : 'Analytics.AggregatedPropertyType',
            Name : 'GroosAmount',
            AggregationMethod : 'sum',
            AggregatableProperty : GroosAmount,
            @Common.Label : 'Total Purchase'
        },
    }
 );

// Block3 Visual filter 
// Company name : X axis - Dimension - # Category
// Gross amount : Y axis - Measures 

annotate POAnalytics.PurchaseAnalytics with @(
    UI.Chart #visual :{
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Title : 'Filter by country',
        Dimensions : [ Country ],
        DimensionAttributes : [
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension : Country,
                Role : #Category
            },
        ], 
        DynamicMeasures : [
            ![@Analytics.AggregatedProperty#GroosAmount]
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                DynamicMeasure : ![@Analytics.AggregatedProperty#GroosAmount],
                Role : #Axis1
            }
        ]
    },
    // Initially load whether show chart or not
    UI.PresentationVariant #pvvisual: {
        $Type : 'UI.PresentationVariantType',
        Visualizations : [
            '@UI.Chart#visual',
        ]
    }
){
    Country @Common : { 
        ValueList #vlCountry : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'PurchaseAnalytics',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : Country,
                    ValueListProperty : 'Country',
                },
            ],
            PresentationVariantQualifier : 'pvvisual'
        },
     }
};


// Block 4 
// Company name : X axis - Dimension - # Category
// Gross amount : Y axis - Measures 

annotate POAnalytics.PurchaseAnalytics with @(
    UI.Chart :{
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Column,
        Title : 'Total Purchase by Company',
        Dimensions : [ CompanyName ],
        DimensionAttributes : [
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension : CompanyName,
                Role : #Category
            },
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension : Country,
                Role : #Series,    
            }
        ], 
        DynamicMeasures : [
            ![@Analytics.AggregatedProperty#GroosAmount]
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                DynamicMeasure : ![@Analytics.AggregatedProperty#GroosAmount],
                Role : #Axis1
            }
        ]
    },
    // Initially load whether show chart or not
    UI.PresentationVariant : {
        $Type : 'UI.PresentationVariantType',
        Visualizations : [
            '@UI.Chart',
        ]
    }
);

 annotate POAnalytics.PurchaseAnalytics with @(
    UI : {
        SelectionFields  : [
            PurchaseOrderId,
            CompanyName,
            Currency,
            Description,
            Country
        ],
        LineItem  : [
            {
                $Type : 'UI.DataField',
                Value : PurchaseOrderId,
            },
            {
                $Type : 'UI.DataField',
                Value : ItemPositition
            },
            {
                $Type : 'UI.DataField',
                Value : CompanyName,
            },   
            {
                $Type : 'UI.DataField',
                Value :  GroosAmount,
            },    
            {
                $Type : 'UI.DataField',
                Value :  Currency,
            },                       
            {
                $Type : 'UI.DataField',
                Value :  Description,
            },    
            {
                $Type : 'UI.DataField',
                Value :  OverallStatus,
            }, 
            {
                $Type : 'UI.DataField',
                Value : Country,
            }                                                                  
        ],
    }
 ) ;
 

}
