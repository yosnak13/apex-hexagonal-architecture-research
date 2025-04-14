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
    LastNameVo lastNameVo = new LastNameVo(CONTACT_NAME);
    EmailVo emailVo = new EmailVo(EMAIL);

    ContactEntity actual = new ContactEntity(idVo, lastNameVo, emailVo);

    System.assertEquals(idVo.toId(), actual.getAccountId());
    System.assertEquals(CONTACT_NAME, actual.getContactNameVo());
    System.assertEquals(EMAIL, actual.getEmailVo());
  }

  @IsTest
  static void buildNewContactTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    String expectedName = CONTACT_NAME;
    String expectedEmail = EMAIL;

    ContactEntity entity = new ContactEntity(new AccountIdVo(accountId), new LastNameVo(expectedName), new EmailVo(EMAIL));
    Contact actual = entity.toContact();

    System.assertEquals(accountId, actual.AccountId);
    System.assertEquals(expectedName, actual.LastName);
    System.assertEquals(expectedEmail, actual.Email);
  }

  @IsTest
  static void getAccountIdTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    ContactEntity actual = new ContactEntity(
        new AccountIdVo(accountId), new LastNameVo(CONTACT_NAME), new EmailVo(EMAIL));

    System.assertEquals(accountId, actual.getAccountId());
  }

  @IsTest
  static void toEmailMessageTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    String expectedEmail = EMAIL;

    ContactEntity entity = new ContactEntity(new AccountIdVo(accountId), new LastNameVo(CONTACT_NAME), new EmailVo(expectedEmail));
    Messaging.SingleEmailMessage actual = entity.toEmailMessage();

    Integer emailToIsExistInFirstIndex = 0;
    System.assertEquals(expectedEmail, actual.toAddresses[emailToIsExistInFirstIndex]);
    String expectedTitle = '【ようこそ】' + entity.getContactNameVo() + ' 様';
    System.assertEquals(expectedTitle, actual.subject);
    System.assertEquals(buildHtmlBodyForTest(entity), actual.htmlBody);
  }

  private static String buildHtmlBodyForTest(ContactEntity entity) {
    return ''
        + '<!DOCTYPE html>'
        + '<html>'
        + '<head><meta charset="UTF-8"><style>'
        + '  body { font-family: Arial, sans-serif; line-height: 1.6; }'
        + '  .content { padding: 20px; background: #f9f9f9; border-radius: 10px; }'
        + '</style></head>'
        + '<body>'
        + '  <div class="content">'
        + '    <h2>' + entity.getContactNameVo() + ' 様</h2>'
        + '    <p>この度はご登録いただき、誠にありがとうございます。</p>'
        + '    <p>ご不明点等ございましたら、お気軽にご連絡ください。</p>'
        + '    <p>今後ともよろしくお願いいたします。</p>'
        + '  </div>'
        + '</body>'
        + '</html>';
  }
}
