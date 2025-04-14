/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactServiceTest {
  private static final String ACCOUNT_NAME = 'RegisterContactServiceTest';
  private static final String EMAIL = 'sample@example.com';

  private static final String NO_ACCOUNT_EXCEPTION = AccountCollection.NO_ACCOUNT_EXCEPTION;

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void execTest() {
    RegisterContactService result = new RegisterContactService(
        new FindAccountRepositoryMock(), new RegisterContactRepositoryMock(), new SendEmailRepositoryMock()
    );
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    RegisterContactInput input = new RegisterContactInput(acct.Id, 'testName', EMAIL);

    result.exec(input);

    System.assert(FindAccountRepositoryMock.wasCalled);
    System.assert(RegisterContactRepositoryMock.wasCalled);
    System.assert(SendEmailRepositoryMock.wasCalled);
  }

  @IsTest
  static void execTest_NoAccountIsExist() {
    RegisterContactService result = new RegisterContactService(
        new FindAccountRepositoryEmptyMock(), new RegisterContactRepositoryMock(), new SendEmailRepositoryMock()
    );
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    RegisterContactInput input = new RegisterContactInput(acct.Id, 'testName', EMAIL);

    try {
      result.exec(input);
    } catch (HandledException e) {
      System.assertEquals(NO_ACCOUNT_EXCEPTION, e.getMessage());
    }

    System.assert(FindAccountRepositoryEmptyMock.wasCalled);
    System.assert(!RegisterContactRepositoryMock.wasCalled);
    System.assert(!SendEmailRepositoryMock.wasCalled);
  }

  @IsTest
  static void execTest_CatchEmailExceptionFromEmailRepo() {
    RegisterContactService result = new RegisterContactService(
        new FindAccountRepositoryMock(), new RegisterContactRepositoryMock(), new SendEmailRepositoryExceptionMock()
    );
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    RegisterContactInput input = new RegisterContactInput(acct.Id, 'testName', EMAIL);

    try {
      result.exec(input);
    } catch (HandledException e) {
      System.assertEquals(SendEmailRepositoryExceptionMock.EXCEPTION_MESSAGE, e.getMessage());
    }

    System.assert(FindAccountRepositoryMock.wasCalled);
    System.assert(RegisterContactRepositoryMock.wasCalled);
    System.assert(SendEmailRepositoryExceptionMock.wasCalled);
  }
}
