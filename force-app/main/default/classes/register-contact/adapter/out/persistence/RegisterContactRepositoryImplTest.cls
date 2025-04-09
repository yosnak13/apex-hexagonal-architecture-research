/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactRepositoryImplTest {
  private static final String ACCOUNT_NAME = 'RegisterContactRepositoryImplTest';
  private static final String CONTACT_NAME = 'ContactNameTest';
  private static final String ILLEGAL_MESSAGE = 'No Account Is Exist.';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void createTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    ContactVo arg = new ContactVo(accountId, CONTACT_NAME);

    Test.startTest();
    RegisterContactRepositoryImpl impl = new RegisterContactRepositoryImpl();
    impl.create(arg);
    Test.stopTest();

    Contact actual = [SELECT AccountId, LastName FROM Contact WHERE AccountId = :accountId];
    System.assertEquals(accountId, actual.AccountId);
    System.assertEquals(CONTACT_NAME, actual.LastName);
  }

  @IsTest
  static void createTest_NoAccountIsExist() {
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    ContactVo arg = new ContactVo(acct.Id, CONTACT_NAME);
    delete acct;

    Test.startTest();
    try {
      RegisterContactRepositoryImpl impl = new RegisterContactRepositoryImpl();
      impl.create(arg);
    } catch (HandledException e) {
      System.assertEquals(ILLEGAL_MESSAGE, e.getMessage());
    }
    Test.stopTest();
  }
}
