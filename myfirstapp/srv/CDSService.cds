using { myView.cds } from '../db/CDSViews';

service CDSService @(path:'CDSService') {

entity ProductSet as projection on cds.CDSViews.ProductView{
    *,
    // never persist in DB
    virtual soldCount : Int16
};

entity ItemsSet as projection on cds.CDSViews.ItemsView;    

}

