/**
 * Created by yoshihisanakai on 2025/04/14.
 */

@IsTest
private class SendEmailRepositoryImplTest {
  private static final String TEST_EMAIL = 'sample@example.com';
  private static final String TEST_EMAIL_SUBJECT = 'テストメールタイトル';
  private static final String TEST_EMAIL_BODY = 'テストメール本文';

  @IsTest
  static void sendEmailTest() {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[]{
        TEST_EMAIL
    });
    mail.setSubject(TEST_EMAIL_SUBJECT);
    mail.setPlainTextBody(TEST_EMAIL_BODY);

    SendEmailRepositoryImpl actual = new SendEmailRepositoryImpl();

    try {
      actual.sendEmail(mail);
      System.assert(true);
    } catch (EmailException e) {
      System.assert(false);
    }
  }
}
