/**
 * Created by yoshihisanakai on 2025/04/14.
 */

@IsTest
public with sharing class SendEmailRepositoryExceptionMock implements SendEmailRepository {
  public static Boolean wasCalled = false;
  public static final String EXCEPTION_MESSAGE = 'メール送信に失敗しました。';

  public void sendEmail(Messaging.SingleEmailMessage emailMessage) {
    wasCalled = true;
    throw new EmailException(EXCEPTION_MESSAGE);
  }
}
