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

  public Messaging.SingleEmailMessage toEmailMessage() {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new List<String>{ emailVo.toEmail() });
    mail.setSubject('【ようこそ】' + contactNameVo.toLastName() + ' 様');
    mail.setHtmlBody(buildHtmlBody());
    return mail;
  }

  private String buildHtmlBody() {
    return ''
        + '<!DOCTYPE html>'
        + '<html>'
        + '<head><meta charset="UTF-8"><style>'
        + '  body { font-family: Arial, sans-serif; line-height: 1.6; }'
        + '  .content { padding: 20px; background: #f9f9f9; border-radius: 10px; }'
        + '</style></head>'
        + '<body>'
        + '  <div class="content">'
        + '    <h2>' + contactNameVo.toLastName() + ' 様</h2>'
        + '    <p>この度はご登録いただき、誠にありがとうございます。</p>'
        + '    <p>ご不明点等ございましたら、お気軽にご連絡ください。</p>'
        + '    <p>今後ともよろしくお願いいたします。</p>'
        + '  </div>'
        + '</body>'
        + '</html>';
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
