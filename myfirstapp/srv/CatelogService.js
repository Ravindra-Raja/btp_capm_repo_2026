const cds = require('@sap/cds')

module.exports = class CatelogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProudctSet, businessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseItemsSet } = cds.entities('CatelogService')

  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSet', req.data)
    // Get the employee salary info
    let salaryAmount = parseFloat(req.data.salaryAmount);
    if (salaryAmount > 50000) {
      
    // Contominate the incoming request, so CAPM will know that something gone wrong in your green box 
    req.error(500, "Check the salary, none of the employee get above 50 thousands");
      
    }
  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProudctSet, async (req) => {
    console.log('Before CREATE/UPDATE ProudctSet', req.data)
  })
  this.after ('READ', ProudctSet, async (proudctSet, req) => {
    console.log('After READ ProudctSet', proudctSet)
  })
  this.before (['CREATE', 'UPDATE'], businessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE businessPartnerSet', req.data)
  })
  this.after ('READ', businessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ businessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    console.log('After READ PurchaseOrderSet', purchaseOrderSet)
    for (let index = 0; index < purchaseOrderSet.length; index++) {
      const element = purchaseOrderSet[index];
      if (!element.NOTE) {
        element.NOTE = 'Not Found';
      }
      
    }
  })
  this.before (['CREATE', 'UPDATE'], PurchaseItemsSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseItemsSet', req.data)
  })
  this.after ('READ', PurchaseItemsSet, async (purchaseItemsSet, req) => {
    console.log('After READ PurchaseItemsSet', purchaseItemsSet)
  })

// Get default values Implementation

  this.on('getdefaultvalue', async (req, res) => {
    return {
      OVERALL_STATUS : 'N',
      LIFECYCLE_STATUS : 'N'
    }
  });
// Function Implementation
// generic handler to support my function Implementation - always returns data GET

  this.on('getLargestOrder', async (req, res) => {
    try {
      const tx = cds.tx(req);

      // use CDS QL to make a call DB

      const reply = await tx.read(PurchaseOrderSet).orderBy({
        'GROSS_AMOUNT' : 'desc' 
      }).limit(3);

      return reply;
    } catch (error) {
      req.error(500, 'Some Error occured' + error.toString());
    }
  })

  // implementation of action - create, update in server

  this.on('boost', async (req) => {
    
    try {
      // Get Primary Key in JSON { NODE_KEY : 'Key value' }
      const PRIMARYKEY = req.params[0];
      // Start a transaction to db
      const tx = cds.tx(req);

      await tx.update(PurchaseOrderSet).with({
        GROSS_AMOUNT : { '+=' : 1000 },
        NOTE: 'Boosted!!'
      }).where(PRIMARYKEY);

      // After update, then read the data
      return await tx.read(PurchaseOrderSet).where(PRIMARYKEY);

    } catch (error) {
      req.error(500, 'Some Error occured' + error.toString());
    }

  })

  return super.init();
}}
