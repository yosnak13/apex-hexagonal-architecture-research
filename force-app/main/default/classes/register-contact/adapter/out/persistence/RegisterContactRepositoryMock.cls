/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
public with sharing class RegisterContactRepositoryMock implements RegisterContactRepository {
    public static Boolean wasCalled = false;

    public void create(ContactEntity entity) {
        wasCalled = true;
        return;
    }
}