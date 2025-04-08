/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class ContactVo {
  final Id accountId;
  final String contactName;

  private static final String ACCOUNT = 'Account';
  private static final String ILLEGAL_ID_MESSAGE = 'AccountのIdではありません';
  private static final String ILLEGAL_CONTACT_NAME_MESSAGE = '取引先窓口名を入力してください';

  public ContactVo(Id accountId, String contactName) {
    if (accountId.getSobjectType().getDescribe().getName() != ACCOUNT) throw new IllegalArgumentException(ILLEGAL_ID_MESSAGE);
    if (String.isEmpty(contactName)) throw new IllegalArgumentException(ILLEGAL_CONTACT_NAME_MESSAGE);

    this.accountId = accountId;
    this.contactName = contactName;
  }

  public Contact buildNewContact() {
    return new Contact(AccountId = accountId, LastName = contactName);
  }

  public Id getAccountId() {
    return accountId;
  }
}
