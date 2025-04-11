/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactRepositoryImplTest {
  private static final String ACCOUNT_NAME = 'RegisterContactRepositoryImplTest';
  private static final String CONTACT_NAME = 'ContactNameTest';
  private static final String EMAIL = 'sample@example.com';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void createTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    ContactEntity arg = new ContactEntity(new AccountIdVo(accountId), CONTACT_NAME, EMAIL);

    Test.startTest();
    RegisterContactRepositoryImpl impl = new RegisterContactRepositoryImpl();
    impl.create(arg);
    Test.stopTest();

    Contact actual = [SELECT AccountId, LastName FROM Contact WHERE AccountId = :accountId];
    System.assertEquals(accountId, actual.AccountId);
    System.assertEquals(CONTACT_NAME, actual.LastName);
  }
}
