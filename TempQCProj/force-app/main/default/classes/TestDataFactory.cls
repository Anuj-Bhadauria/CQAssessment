/**
@Description:     This class is a DataFactory class that can be called by test methods to perform useful tasks,
                  such as setting up test data.
@Author:          Anuj Singh
@Created Date:    August 16, 2023
@Last Modified:   August 16, 2023
*/

public class TestDataFactory {

    public static user createIntegrationAdminUser(){
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='Integration Admin'];
        if(userProfile != null){
            User u = new User(Alias = 'testU', Email='intadmusr@test.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = userProfile.Id, 
                              TimeZoneSidKey='America/Los_Angeles', Username = 'testU@a.com' + System.currentTimeMillis());
            return u;
        }
        else return null;
    }
    
    public static user createStandardUser(){
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        if(userProfile != null){
            User u = new User(Alias = 'testU', Email='intadmusr@test.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = userProfile.Id, 
                              TimeZoneSidKey='America/Los_Angeles', Username = 'testU@a.com' + System.currentTimeMillis());
            return u;
        }
        else return null;
    }
    
    public static Account createAccount(String name){
        Account acc = new Account(Name = name);
        return acc;
    }
}