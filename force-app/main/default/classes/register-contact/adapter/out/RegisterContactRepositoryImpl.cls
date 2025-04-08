/**
 * Created by yoshihisanakai on 2025/04/07.
 */

public with sharing class RegisterContactRepositoryImpl implements RegisterContactRepository {
  private static final String ILLEGAL_MESSAGE = 'No Account Is Exist.';

  public void create(ContactVo vo) {
    Contact con = vo.buildNewContact();
    List<Account> accounts = [SELECT Id FROM Account WHERE Id = :vo.getAccountId()];
    if (accounts.isEmpty()) throw new HandledException(ILLEGAL_MESSAGE);

    insert con;
  }
}
