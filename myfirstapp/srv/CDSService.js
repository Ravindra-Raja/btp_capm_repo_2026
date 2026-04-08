const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CDSService extends cds.ApplicationService { init() {

  const { ProductSet, ItemsSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    // console.log('After READ ProductSet', productSet)
    // Get unique product ids

    let ids = productSet.map( p => p.ProductId);

    // CDS Query language to go to items data and aggregate the count.

    const orderCount = await SELECT.from(ItemsSet)
                                   .columns('ProductId', { func : 'count', as: 'prodCount'} )
                                   .where({'ProductId' :  {in : ids}})
                                   .groupBy('ProductId');


   for (let index = 0; index < productSet.length; index++) {
    const element = productSet[index];
    const foundRecord = orderCount.find(pc => pc.ProductId === element.ProductId);

    element.soldCount = foundRecord ? foundRecord.prodCount: 0;
   }

  });

  this.before (['CREATE', 'UPDATE'], ItemsSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemsSet', req.data)
  })
  this.after ('READ', ItemsSet, async (itemsSet, req) => {
    console.log('After READ ItemsSet', itemsSet)
  })


  return super.init()
}}
