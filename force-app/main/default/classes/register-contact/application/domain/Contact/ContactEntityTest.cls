/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class ContactEntityTest {
  private static final String ACCOUNT_NAME = 'ContactVoTest';
  private static final String CONTACT_NAME = 'ContactNameTest';
  private static final String EMAIL = 'sample@example.com';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void ContactVoTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    AccountIdVo idVo = new AccountIdVo(accountId);

    ContactEntity actual = new ContactEntity(idVo, CONTACT_NAME, EMAIL);

    System.assertEquals(idVo.toId(), actual.getAccountId());
    System.assertEquals(CONTACT_NAME, actual.getContactName());
    System.assertEquals(EMAIL, actual.getEmail());
  }

  @IsTest
  static void buildNewContactTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    String expectedName = CONTACT_NAME;
    String expectedEmail = EMAIL;

    ContactEntity entity = new ContactEntity(new AccountIdVo(accountId), expectedName, expectedEmail);
    Contact actual = entity.toContact();

    System.assertEquals(accountId, actual.AccountId);
    System.assertEquals(expectedName, actual.LastName);
    System.assertEquals(expectedEmail, actual.Email);
  }

  @IsTest
  static void getAccountIdTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    ContactEntity actual = new ContactEntity(new AccountIdVo(accountId), CONTACT_NAME, EMAIL);

    System.assertEquals(accountId, actual.getAccountId());
  }
}
