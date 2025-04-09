/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class ContactEntity {
  final Id accountId;
  final String contactName;
  final String email;

  private static final String ACCOUNT = 'Account';
  private static final String ILLEGAL_ID_MESSAGE = 'AccountのIdではありません';
  private static final String ILLEGAL_CONTACT_NAME_MESSAGE = '取引先窓口名を入力してください';

  public ContactEntity(Id accountId, String contactName, String email) {
    if (accountId.getSobjectType().getDescribe().getName() != ACCOUNT) throw new IllegalArgumentException(ILLEGAL_ID_MESSAGE);
    if (String.isEmpty(contactName)) throw new IllegalArgumentException(ILLEGAL_CONTACT_NAME_MESSAGE);

    this.accountId = accountId;
    this.contactName = contactName;
    this.email = email;
  }

  public Contact toContact() {
    return new Contact(AccountId = accountId, LastName = contactName, Email = email);
  }

  public Id getAccountId() {
    return accountId;
  }
}
