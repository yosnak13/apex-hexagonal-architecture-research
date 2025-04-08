/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactControllerTest {
  private static final String ACCOUNT_NAME = 'RegisterContactControllerTest';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void registerTest() {
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];

    Test.startTest();
    RegisterContactController.register(acct.Id, 'contactTest');
    Test.stopTest();

    System.assert(RegisterContactServiceMock.wasCalled);
  }
}
