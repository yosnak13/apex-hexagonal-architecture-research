/**
 * Created by yoshihisanakai on 2025/04/14.
 */

@IsTest
public with sharing class SendEmailRepositoryExceptionMock implements SendEmailRepository {
    public static Boolean wasCalled = false;
    public static final String FOR_ROLLBACK_CHECK_CONTACT_NAME = 'rollback';
    public static final String EXCEPTION_MESSAGE = 'メール送信に失敗しました。';

    public void sendEmail(Messaging.SingleEmailMessage emailMessage) {
        wasCalled = true;
        insert new Contact(LastName = FOR_ROLLBACK_CHECK_CONTACT_NAME);
        throw new EmailException(EXCEPTION_MESSAGE);
    }
}