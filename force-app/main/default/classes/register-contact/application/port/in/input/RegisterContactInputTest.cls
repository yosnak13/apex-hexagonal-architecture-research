/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
private class RegisterContactInputTest {
  private static final String ACCOUNT_NAME = 'ContactVoTest';
  private static final String CONTACT_NAME = 'ContactNameTest';
  private static final String EMAIL = 'sample@example.com';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void RegisterContactInputTest() {
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    String expectedName = CONTACT_NAME;
    String expectedEmail = EMAIL;
    RegisterContactInput input = new RegisterContactInput(acct.Id, expectedName, expectedEmail);

    System.assertEquals(acct.Id, input.getAccountId());
    System.assertEquals(expectedName, input.getName());
    System.assertEquals(expectedEmail, input.getEmail());
  }

  @IsTest
  static void toEntityTest() {
    Account acct = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    String expectedName = CONTACT_NAME;
    String expectedEmail = EMAIL;
    RegisterContactInput input = new RegisterContactInput(acct.Id, expectedName, expectedEmail);

    // 値チェックはContactEntityで実施するため、ここではビルド成功のみ検証
    input.toEntity();
    System.assert(true);
  }
}
