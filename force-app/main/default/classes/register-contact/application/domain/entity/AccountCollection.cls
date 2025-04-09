/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public with sharing class AccountCollection {
  public final List<Account> accounts;

  public static final String NO_ACCOUNT_EXCEPTION = '取引先が存在しないため、取引先責任者を登録できませんでした。';

  // フィールドはList型にしたくないが、
  // 単数にしてヒットしない場合にList has no rows for assignment to SObjectが起こりうるためListにして安全にする
  public AccountCollection(List<Account> accounts) {
    this.accounts = new List<Account>(accounts);
  }

  public void validateExist() {
    if (accounts.isEmpty()) throw new HandledException(NO_ACCOUNT_EXCEPTION);
  }
}
