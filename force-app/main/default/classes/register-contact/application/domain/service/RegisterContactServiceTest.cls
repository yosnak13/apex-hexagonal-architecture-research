/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactServiceTest {
  private static final String ACCOUNT_NAME = 'RegisterContactServiceTest';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void execTest() {
    RegisterContactService result = new RegisterContactService(new RegisterContactRepositoryMock());
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    ContactVo vo = new ContactVo(acct.Id, 'testName');
    result.exec(vo);

    System.assert(RegisterContactRepositoryMock.wasCalled);
  }

  @IsTest
  static void execTest_catchDMLException() {
    RegisterContactService result = new RegisterContactService(new RegisterContactRepositoryExceptionMock());
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    ContactVo vo = new ContactVo(acct.Id, 'testName');
    try {
      result.exec(vo);
    } catch (DmlException e) {
      String expectedMessage = RegisterContactRepositoryExceptionMock.MESSAGE;
      System.assertEquals(expectedMessage, e.getMessage());
    }
  }
}
