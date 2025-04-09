/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactServiceTest {
  private static final String ACCOUNT_NAME = 'RegisterContactServiceTest';
  private static final String EMAIL = 'sample@example.com';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void execTest() {
    RegisterContactService result = new RegisterContactService(
        new FindAccountRepositoryMock(), new RegisterContactRepositoryMock()
    );
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    ContactVo vo = new ContactVo(acct.Id, 'testName', EMAIL);

    result.exec(vo);

    System.assert(FindAccountRepositoryMock.wasCalled);
    System.assert(RegisterContactRepositoryMock.wasCalled);
  }
}
