// Implementation file - js with same name
// DPC_EXT class you write in ABAP for service implementation

const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {

  this.on ('MyInitCall', async (req) => {
    console.log('On MyInitCall', req.data)
    let myName = req.data.name;
    return `Welcome to CAP server, Hello ${myName}!! How are you `;
  })

// Calling parent class consturctor here
  return super.init()
}}
