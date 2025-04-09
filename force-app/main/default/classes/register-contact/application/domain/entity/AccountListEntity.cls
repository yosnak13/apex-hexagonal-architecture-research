/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public with sharing class AccountListEntity {
  final List<Account> accounts;

  // フィールドはList型にしたくないが、
  // 単数にしてヒットしない場合にList has no rows for assignment to SObjectが起こりうるためListにして安全にする
  public AccountListEntity(List<Account> accounts) {
    this.accounts = accounts;
  }

  public Boolean isEmpty() {
    return accounts.isEmpty();
  }
}
