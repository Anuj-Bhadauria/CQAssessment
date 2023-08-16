/**
@Description: Apex class to call a web Service and created CQ Parts Records on the basis of success response.
@Author: Anuj Singh
@Created Date: July 31, 2023
@Modified Date: August 16, 2023
*/

public class SyncProcessController {

    @AuraEnabled
    public static void getCallout() {
        try{ 
            User usr = [SELECT Profile.Name FROM USER WHERE Id =: UserInfo.getUserId()];
            if(usr.Profile.Name == 'Integration Admin'){
                CQ_Configuration__mdt cqConfig = CQ_Configuration__mdt.getInstance('Sync_Process');    
                List<SyncProcessWrapper> syncProcessWrapperList = new List<SyncProcessWrapper>();
                Account accHighVolume = [Select Id FROM Account WHERE Name = 'High Volume' LIMIT 1];
                Account accLowVolume = [Select Id FROM Account WHERE Name = 'Low Volume' LIMIT 1];
                List<SQX_Part__c> cqPartsList = new List<SQX_Part__c>();
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(cqConfig.Endpoint__c);
                request.setHeader('Content-type', cqConfig.Content_Type__c);
                request.setHeader('x-api-key', cqConfig.API_Key__c);
                request.setMethod('GET');           
                HttpResponse response = http.send(request);
                
                // If the request is successful, parse the JSON response.
                if(response.getStatusCode() == 200) {
                    String jsonBody = response.getBody();
                    String jsonStr = jsonBody.replaceAll('_id', 'id').replaceAll('Part Name', 'PartName').replaceAll('Total Quantity Shipped', 'TotalQuantityShipped');
                    syncProcessWrapperList = (List<SyncProcessWrapper> ) System.JSON.deserialize(jsonStr, List<SyncProcessWrapper>.class);
                    for(SyncProcessWrapper wrapper: syncProcessWrapperList){
                        SQX_Part__c cqPart = new SQX_Part__c();
                        cqPart.Part_Number__c = wrapper.id;
                        if(wrapper.TotalQuantityShipped <99){
                            cqPart.Account__c = accHighVolume.Id;
                        }
                        else if(wrapper.TotalQuantityShipped >=99){
                            cqPart.Account__c = accLowVolume.Id;
                        }
                        cqPart.Name = wrapper.PartName;
                        cqPart.Active__c = true;
                        cqPartsList.add(cqPart);
                    }
                    if(!cqPartsList.isEmpty()){
                        insert cqPartsList;
                    }
                } 
            }
        }
        catch(Exception e){
            System.debug('Exception getLineNumber'+e.getLineNumber());
            System.debug('Exception getMessage'+e.getMessage());
        }
    }

    
    public class SyncProcessWrapper{
        @AuraEnabled public string id;
        @AuraEnabled public string PartName;
        @AuraEnabled public Integer TotalQuantityShipped;
    }
}