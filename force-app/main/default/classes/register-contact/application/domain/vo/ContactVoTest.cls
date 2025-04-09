/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class ContactVoTest {
  private static final String ACCOUNT_NAME = 'ContactVoTest';
  private static final String CONTACT_NAME = 'ContactNameTest';
  private static final String EMAIL = 'sample@example.com';
  private static final String BLANK = '';
  private static final String ILLEGAL_ID_MESSAGE = 'AccountのIdではありません';
  private static final String ILLEGAL_CONTACT_NAME_MESSAGE = '取引先窓口名を入力してください';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void ContactVoTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    Contact dummyContact = new Contact(LastName = 'dummy');
    insert dummyContact;
    Id dummyId = [SELECT Id FROM Contact WHERE LastName = 'dummy'].Id;

    ParameterizedTest[] parameterizedTests = new List<ParameterizedTest>{
        new ParameterizedTest(accountId, CONTACT_NAME, EMAIL, true, BLANK),
        new ParameterizedTest(dummyId, CONTACT_NAME, EMAIL, false, ILLEGAL_ID_MESSAGE),
        new ParameterizedTest(accountId, BLANK, EMAIL, false, ILLEGAL_CONTACT_NAME_MESSAGE)
    };

    for (ParameterizedTest p : parameterizedTests) {
      try {
        new ContactVo(p.AccountId, p.contactName, p.email);
        System.assert(p.isAssert);
      } catch (Exception e) {
        System.assert(!p.isAssert);
        System.assertEquals(p.exceptionMessage, e.getMessage());
      }
    }
  }

  @IsTest
  static void buildNewContactTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    String expectedName = CONTACT_NAME;
    String expectedEmail = EMAIL;

    ContactVo vo = new ContactVo(accountId, expectedName, expectedEmail);
    Contact actual = vo.buildNewContact();

    System.assertEquals(accountId, actual.AccountId);
    System.assertEquals(expectedName, actual.LastName);
    System.assertEquals(expectedEmail, actual.Email);
  }

  @IsTest
  static void getAccountIdTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    ContactVo actual = new ContactVo(accountId, CONTACT_NAME, EMAIL);

    System.assertEquals(accountId, actual.getAccountId());
  }

  private class ParameterizedTest {
    final Id AccountId;
    final String contactName;
    final String email;
    final Boolean isAssert;
    final String exceptionMessage;

    private ParameterizedTest(Id AccountId, String contactName, String email, Boolean isAssert, String exceptionMessage) {
      this.AccountId = AccountId;
      this.contactName = contactName;
      this.email = email;
      this.isAssert = isAssert;
      this.exceptionMessage = exceptionMessage;
    }
  }
}
