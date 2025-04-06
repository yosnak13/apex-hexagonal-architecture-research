/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class ContactVo {
  final Id accountId;
  final String contactName;

  public ContactVo(Id accountId, String contactName) {
    if (accountId.getSobjectType().getDescribe().getName() != 'Account') throw new IllegalArgumentException();
    if (String.isEmpty(contactName)) throw new IllegalArgumentException();

    this.accountId = accountId;
    this.contactName = contactName;
  }

  public Contact buildNewContact() {
    return new Contact(AccountId = accountId, Name = contactName);
  }
}
