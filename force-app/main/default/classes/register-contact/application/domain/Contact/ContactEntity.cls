/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class ContactEntity {
  final AccountIdVo idVo;
  final String contactName;
  final EmailVo emailVo;

  private static final String ILLEGAL_CONTACT_NAME_MESSAGE = '取引先窓口名を入力してください';

  public ContactEntity(AccountIdVo idVo, String contactName, EmailVo emailVo) {
    if (String.isEmpty(contactName)) throw new IllegalArgumentException(ILLEGAL_CONTACT_NAME_MESSAGE);

    this.idVo = idVo;
    this.contactName = contactName;
    this.emailVo = emailVo;
  }

  public Contact toContact() {
    return new Contact(AccountId = idVo.toId(), LastName = contactName, Email = emailVo.toEmail());
  }

  public Id getAccountId() {
    return idVo.toId();
  }

  @TestVisible
  private String getContactName() {
    return contactName;
  }

  @TestVisible
  private String getEmailVo() {
    return emailVo.toEmail();
  }
}
