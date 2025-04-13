/**
 * Created by yoshihisanakai on 2025/04/11.
 */

public with sharing class AccountIdVo {
  final Id acctIdVo;

  private static final String ACCOUNT = 'Account';
  private static final String ILLEGAL_ID_MESSAGE = 'AccountのIdではありません';

  public AccountIdVo(Id acctIdVo) {
    if (!acctIdVo.getSobjectType().getDescribe().getName().equals(ACCOUNT)) {
      throw new IllegalArgumentException(ILLEGAL_ID_MESSAGE);
    }

    this.acctIdVo = acctIdVo;
  }

  public Id toId() {
    return acctIdVo;
  }
}
