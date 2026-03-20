sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"purchase/ui/managepo/test/integration/pages/PurchaseOrderSetList",
	"purchase/ui/managepo/test/integration/pages/PurchaseOrderSetObjectPage",
	"purchase/ui/managepo/test/integration/pages/PurchaseItemsSetObjectPage"
], function (JourneyRunner, PurchaseOrderSetList, PurchaseOrderSetObjectPage, PurchaseItemsSetObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('purchase/ui/managepo') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetList: PurchaseOrderSetList,
			onThePurchaseOrderSetObjectPage: PurchaseOrderSetObjectPage,
			onThePurchaseItemsSetObjectPage: PurchaseItemsSetObjectPage
        },
        async: true
    });

    return runner;
});

