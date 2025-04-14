/**
 * Created by yoshihisanakai on 2025/04/14.
 */

@IsTest
public with sharing class SendEmailRepositoryMock implements SendEmailRepository {
  public static Boolean wasCalled = false;

  public void sendEmail(Messaging.SingleEmailMessage emailMessage) {
    wasCalled = true;
    return ;
  }
}
