/**
 * Created by yoshihisanakai on 2025/04/08.
 */

@IsTest
private class RegisterContactE2ETest {
  private static final String ACCOUNT_NAME = 'RegisterContactE2ETest';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void registerTestE2E() {
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    ApexTestSetting__c testSetting = new ApexTestSetting__c(IsE2ETest__c = true);
    insert testSetting;

    Test.startTest();
    RegisterContactController.register(acct.Id, 'contactTest');
    Test.stopTest();

    Integer recordSize = [SELECT COUNT() FROM Contact WHERE AccountId = :acct.Id];
    System.assertEquals(1, recordSize);
  }
}
