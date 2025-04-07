/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
public with sharing class RegisterContactRepositoryMock implements RegisterContactRepository {
  public void create(ContactVo vo) {
    return;
  }
}
