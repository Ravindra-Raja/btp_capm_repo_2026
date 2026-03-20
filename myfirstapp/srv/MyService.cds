// definition of the service
// In ABAP Similar SEGW - Define a service

service MyService @(path : 'MyService') {
    //Service end point
    function MyInitCall(name : String) returns String;

}