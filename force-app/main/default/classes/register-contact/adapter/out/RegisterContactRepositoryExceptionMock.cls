/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
public with sharing class RegisterContactRepositoryExceptionMock implements RegisterContactRepository {
  public static final String MESSAGE = 'DML Exception has occurred';

  public void create(ContactVo vo) {
    throw new DmlException(MESSAGE);
  }
}
