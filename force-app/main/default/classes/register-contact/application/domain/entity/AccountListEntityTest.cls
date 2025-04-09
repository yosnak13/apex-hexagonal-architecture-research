/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class AccountListEntityTest {
  private static final String ACCOUNT_NAME = 'AccountListEntityTest';
  @TestSetup
  static void testSetUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void AccountListEntityTest() {
    List<Account> accounts = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    AccountListEntity hasEntity = new AccountListEntity(accounts);
    System.assert(!hasEntity.isEmpty());
    AccountListEntity emptyList = new AccountListEntity(new List<Account>());
    System.assert(emptyList.isEmpty());
  }
}
