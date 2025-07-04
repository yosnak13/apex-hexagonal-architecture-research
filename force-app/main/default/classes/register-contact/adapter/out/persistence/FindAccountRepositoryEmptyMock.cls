/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class FindAccountRepositoryEmptyMock implements FindAccountRepository {
    public static Boolean wasCalled = false;

    public AccountCollection findById(Id accountId) {
        wasCalled = true;
        return new AccountCollection(new List<Account>());
    }
}