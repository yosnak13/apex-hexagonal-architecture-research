/**
 * Created by yoshihisanakai on 2025/04/11.
 */

@IsTest
private class AccountIdVoTest {

  private static final String ACCOUNT_NAME = 'AccountIdVoTest';
  private static final String CONTACT_NAME = 'ContactTest';
  private static final String ILLEGAL_ID_MESSAGE = 'AccountのIdではありません';

  @TestSetup
  static void setUp() {
    insert new Account(Name = ACCOUNT_NAME);
    insert new Contact(LastName = CONTACT_NAME);
  }

  @IsTest
  static void AccountIdVoTest() {
    Id accountId = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME].Id;
    Id contactId = [SELECT Id FROM Contact WHERE LastName = :CONTACT_NAME].Id;

    AccountIdVo validVo = new AccountIdVo(accountId);
    System.assertEquals(accountId, validVo.toId());
    try {
       new AccountIdVo(contactId);
    } catch (IllegalArgumentException e) {
      System.assertEquals(ILLEGAL_ID_MESSAGE, e.getMessage());
    }
  }
}
