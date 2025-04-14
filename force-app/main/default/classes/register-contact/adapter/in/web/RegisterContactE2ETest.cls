/**
 * Created by yoshihisanakai on 2025/04/08.
 */

@IsTest
private class RegisterContactE2ETest {
  private static final String ACCOUNT_NAME = 'RegisterContactE2ETest';

  private static final String EXPECTED_LAST_NAME = 'contactTest';
  private static final String EXPECTED_EMAIL = 'sample@example.com';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void registerTestE2E() {
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    ApexTestSetting__c testSetting = new ApexTestSetting__c(IsE2ETest__c = true);
    insert testSetting;

    Id expectedAccountId = acct.Id;

    Test.startTest();
    RegisterContactController.register(expectedAccountId, EXPECTED_LAST_NAME, EXPECTED_EMAIL);
    Test.stopTest();

    Contact actual = [SELECT AccountId, LastName, Email FROM Contact WHERE AccountId = :expectedAccountId];
    System.assertEquals(expectedAccountId, actual.AccountId);
    System.assertEquals(EXPECTED_LAST_NAME, actual.LastName);
    System.assertEquals(EXPECTED_EMAIL, actual.Email);
  }
}
