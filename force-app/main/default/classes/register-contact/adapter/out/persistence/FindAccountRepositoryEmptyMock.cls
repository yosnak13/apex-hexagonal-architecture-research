/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class FindAccountRepositoryEmptyMock implements FindAccountRepository {
  public AccountCollection findById(Id accountId) {
    return new AccountCollection(new List<Account>());
  }
}
