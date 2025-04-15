/**
 * Created by yoshihisanakai on 2025/04/14.
 */

public with sharing class SendEmailRepositoryImpl implements SendEmailRepository {

  public void sendEmail(Messaging.SingleEmailMessage emailMessage) {
    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
        emailMessage
    });
  }
}
