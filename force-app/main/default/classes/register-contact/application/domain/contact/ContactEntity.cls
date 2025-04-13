/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class ContactEntity {
  final AccountIdVo idVo;
  final LastNameVo contactNameVo;
  final EmailVo emailVo;

  public ContactEntity(AccountIdVo idVo, LastNameVo contactNameVo, EmailVo emailVo) {
    this.idVo = idVo;
    this.contactNameVo = contactNameVo;
    this.emailVo = emailVo;
  }

  public Contact toContact() {
    return new Contact(AccountId = idVo.toId(), LastName = contactNameVo.toLastName(), Email = emailVo.toEmail());
  }

  public Id getAccountId() {
    return idVo.toId();
  }

  @TestVisible
  private String getContactNameVo() {
    return contactNameVo.toLastName();
  }

  @TestVisible
  private String getEmailVo() {
    return emailVo.toEmail();
  }
}
