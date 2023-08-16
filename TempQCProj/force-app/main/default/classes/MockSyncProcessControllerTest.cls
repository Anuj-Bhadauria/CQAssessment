/**
@Description: Apex test class to create a fake response.
@Author: Anuj Singh
@Created Date: July 31, 2023
@Modified Date: August 16, 2023
*/

@isTest
global class MockSyncProcessControllerTest implements HttpCalloutMock {
    private String callOutType;
    global MockSyncProcessControllerTest(string callOutType){
        this.callOutType = callOutType;
    }
    
    global HTTPResponse respond(HTTPRequest request) {
        if(callOutType == 'SuccessResponse'){
            return getSuccessResponse();
            
        }
        if(callOutType == 'ExceptionResponse'){
            return getExeptionResponse();
        }
        return null;
    } 
    
    public static HttpResponse getSuccessResponse() {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000},{"_id": "629989816a50f02a0000b83e","Part Name": "Pressure Adapt","Total Quantity Shipped": 12}]');
        response.setStatusCode(200);
        return response; 
    }
    
    public static HTTPResponse getExeptionResponse() {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor"}');
        response.setStatusCode(200);
        return response; 
    }   
}