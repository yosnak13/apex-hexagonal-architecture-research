/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class FindAccountRepositoryMock implements FindAccountRepository {
    public static Boolean wasCalled = false;
    public static final String ACCOUNT_NAME = 'FindAccountRepositoryMock';

    public AccountCollection findById(Id accountId) {
        wasCalled = true;
        List<Account> mockAccounts = new List<Account>{ new Account(Name = ACCOUNT_NAME) };
        return new AccountCollection(mockAccounts);
    }
}