/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class FindAccountRepositoryEmptyMock implements FindAccountRepository {
  public AccountListEntity findById(Id accountId) {
    return new AccountListEntity(new List<Account>());
  }
}
