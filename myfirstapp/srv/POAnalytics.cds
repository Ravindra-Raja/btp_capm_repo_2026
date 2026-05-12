using { myView.cds } from '../db/CDSViews';

service POAnalytics @(path:'POAnalytics') {

entity PurchaseAnalytics as projection on cds.CDSViews.POWorkList{
    *
};  

}
