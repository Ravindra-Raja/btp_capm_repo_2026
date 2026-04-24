sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"mycap/hr/manageemployee/test/integration/pages/EmployeeSetList",
	"mycap/hr/manageemployee/test/integration/pages/EmployeeSetObjectPage"
], function (JourneyRunner, EmployeeSetList, EmployeeSetObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('mycap/hr/manageemployee') + '/test/flp.html#app-preview',
        pages: {
			onTheEmployeeSetList: EmployeeSetList,
			onTheEmployeeSetObjectPage: EmployeeSetObjectPage
        },
        async: true
    });

    return runner;
});

