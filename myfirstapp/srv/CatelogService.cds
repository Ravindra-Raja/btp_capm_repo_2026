// Consume reference of my DB
using { myfirst.db.master, myfirst.db.transaction } from '../db/datamodel';

service CatelogService @(path: 'CatelogService', requires: 'authenticated-user') {

// Create Entity set

entity EmployeeSet @(restrict: [
                                // Row level security
                                {grant : ['READ'], to: 'Viewer', where : 'bankName = $user.bankName'},
                                {grant : ['WRITE', 'DELETE'], to: 'Editor'}                                
                            ]) 
                            as projection on master.employee;
entity ProudctSet as projection on master.product;
entity businessPartnerSet as projection on master.businesspartner;
entity AddressSet as projection on master.address;
@readonly
entity StatusCodeSet as projection on master.statusCode;
// @Capabilities : { Deletable : false }
entity PurchaseOrderSet @(
                            restrict: [
                                {grant : ['READ'], to: 'Viewer'},
                                {grant : ['WRITE', 'DELETE'], to: 'Editor'}                                
                            ],
                            odata.draft.enabled: true ,
                            Common.DefaultValuesFunction : 'getdefaultvalue') as projection on transaction.purchaseorder{
    *,
    case OVERALL_STATUS
        when 'P' then 'Pending'
        when 'A' then 'Approved'
        when 'X' then 'Rejected'
        when 'D' then 'Delivered'
        else 'Unknown'
            end as overallStatus: String(10),
    case OVERALL_STATUS
        when 'P' then 2
        when 'A' then 3
        when 'X' then 1
        when 'D' then 3
        else '0'
            end as colorIcon: Integer           
            
}
actions{
    // Side effect - a trigger to my action leads to change of a field value in data
    // this force frame work to make a GET call after action to load data
    // _refresh variable that will contain the updated data from back end

    @cds.odata.bindingparameter.name: '_refresh'
    @Common.SideEffects :{
        TargetProperties: ['_refresh/GROSS_AMOUNT']
    }
    // System will pass the PO primary key - NODE_KEY Automatically
    action boost() returns PurchaseOrderSet
};

entity PurchaseItemsSet as projection on transaction.poitems;

// Non instance bound Because This is not connected to any entity
function getLargestOrder() returns array of PurchaseOrderSet;
function getdefaultvalue() returns PurchaseOrderSet;
}