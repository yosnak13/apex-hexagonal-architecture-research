/**
 * Created by yoshihisanakai on 2025/04/08.
 */

@IsTest
public with sharing class RegisterContactServiceMock implements RegisterContactUseCase {
  public static Boolean wasCalled = false;

  public void exec(ContactVo vo) {
    wasCalled = true;
    return ;
  }
}
