/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class AccountCollectionTest {
  private static final String ACCOUNT_NAME = 'AccountCollectionTest';
  private static final String NO_ACCOUNT_EXCEPTION = '取引先が存在しないため、取引先責任者を登録できませんでした。';

  @TestSetup
  static void testSetUp() {
    insert new Account(Name = ACCOUNT_NAME);
  }

  @IsTest
  static void validateExistTest() {
    List<Account> accounts = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME];
    AccountCollection hasEntity = new AccountCollection(accounts);

    hasEntity.validateExist();
    System.assertEquals(accounts.size(), hasEntity.getAccountSize());
  }

  @IsTest
  static void validateExistTest_Exception() {
    AccountCollection empty = new AccountCollection(new List<Account>());

    try {
      empty.validateExist();
    } catch (HandledException e) {
      System.assertEquals(NO_ACCOUNT_EXCEPTION, e.getMessage());
    }
  }
}
