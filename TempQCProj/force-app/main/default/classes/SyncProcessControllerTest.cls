/**
@Description: Apex test class to test the all testing scenarios for the logic contained within the SyncProcessController.
@Author: Anuj Singh
@Created Date: July 31, 2023
@Modified Date: August 16, 2023
*/

@isTest
private class SyncProcessControllerTest {

    @testSetup static void methodName() {
        
        User intAdminUser = TestDataFactory.createIntegrationAdminUser();
        insert intAdminUser;
        
        User stdUser = TestDataFactory.createStandardUser();
        insert stdUser;
        
        Account acc = TestDataFactory.createAccount('High Volume');
        insert acc;

        Account acc1 = TestDataFactory.createAccount('Low Volume');
        insert acc1;
    }
    
    static testMethod void testIntegrationAdminMethod(){ 
    
        User usr = [SELECT Id FROM USER WHERE Profile.Name = 'Integration Admin' LIMIT 1];

        System.runAs(usr){
            Test.startTest();
            MockSyncProcessControllerTest mockCallout = new MockSyncProcessControllerTest('SuccessResponse');
            Test.setMock(HttpCalloutMock.class, mockCallout); 
            SyncProcessController.getcallout();       
            Test.stopTest();
            List<SQX_Part__c> partList = [SELECT Id FROM SQX_Part__c WHERE Account__r.Name = 'High Volume' OR Account__r.Name = 'Low Volume'];
            System.assertEquals(true, partList.size() == 2);
        }
    }
    
    
    static testMethod void testNonIntegrationAdminMethod(){ 
    
        User usr = [SELECT Id FROM USER WHERE Profile.Name = 'Standard User' LIMIT 1];

        System.runAs(usr){
            Test.startTest();
            MockSyncProcessControllerTest mockCallout = new MockSyncProcessControllerTest('SuccessResponse');
            Test.setMock(HttpCalloutMock.class, mockCallout); 
            SyncProcessController.getcallout();       
            Test.stopTest();
            List<SQX_Part__c> partList = [SELECT Id FROM SQX_Part__c WHERE Account__r.Name = 'High Volume' OR Account__r.Name = 'Low Volume'];
            System.assertEquals(true, partList.size() == 0);
        }
    }
    
    static testMethod void testExeptionMethod(){ 
    
        User usr = [SELECT Id FROM USER WHERE Profile.Name = 'Integration Admin' LIMIT 1];

        System.runAs(usr){
            Test.startTest();
            MockSyncProcessControllerTest mockCallout = new MockSyncProcessControllerTest('ExceptionResponse');
            Test.setMock(HttpCalloutMock.class, mockCallout); 
            SyncProcessController.getcallout();       
            Test.stopTest();
            List<SQX_Part__c> partList = [SELECT Id FROM SQX_Part__c WHERE Account__r.Name = 'High Volume' OR Account__r.Name = 'Low Volume'];
            System.assertEquals(true, partList.size() == 0);
        }
    }
}