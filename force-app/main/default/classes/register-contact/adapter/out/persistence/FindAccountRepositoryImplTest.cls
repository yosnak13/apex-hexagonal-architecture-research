/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
private class FindAccountRepositoryImplTest {
  private static final String ACCOUNT_NAME = 'FindAccountRepositoryImplTest';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }


  @IsTest
  static void findByIdTest() {
    Account expected = [SELECT Id, Name FROM Account WHERE Name = :ACCOUNT_NAME];
    FindAccountRepositoryImpl repo = new FindAccountRepositoryImpl();

    Test.startTest();
    AccountCollection actual = repo.findById(expected.Id);
    Test.stopTest();

    System.assertEquals(1, actual.accounts.size());
  }
}
