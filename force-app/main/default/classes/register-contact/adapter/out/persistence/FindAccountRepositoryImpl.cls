/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public with sharing class FindAccountRepositoryImpl implements FindAccountRepository {
    public AccountCollection findById(Id accountId) {
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        return new AccountCollection(accounts);
    }
}