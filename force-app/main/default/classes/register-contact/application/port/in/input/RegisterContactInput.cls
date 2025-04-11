/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public with sharing class RegisterContactInput {
  final Id accountId;
  final String contactName;
  final String email;

  public RegisterContactInput(Id accountId, String contactName, String email) {
    this.accountId = accountId;
    this.contactName = contactName;
    this.email = email;
  }

  public ContactEntity toEntity() {
    return new ContactEntity(
        new AccountIdVo(accountId), new LastNameVo(contactName), new EmailVo(email));
  }

  // カプセル化を保ちつつテストで値を検証させたいので、privateでかつテストからのみ参照できるゲッターを定義
  @TestVisible
  private Id getAccountId() {
    return accountId;
  }

  @TestVisible
  private String getName() {
    return contactName;
  }

  @TestVisible
  private String getEmail() {
    return email;
  }
}
