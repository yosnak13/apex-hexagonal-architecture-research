/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public with sharing class RegisterContactInput {
  public Id accountId;
  public String contactName;
  public String email;

  public RegisterContactInput(Id accountId, String contactName, String email) {
    this.accountId = accountId;
    this.contactName = contactName;
    this.email = email;
  }
  // TODO: Entityをビルドするメソッドを実装

  public ContactVo toEntity() {
    return new ContactVo(accountId, contactName, email);
  }
}
