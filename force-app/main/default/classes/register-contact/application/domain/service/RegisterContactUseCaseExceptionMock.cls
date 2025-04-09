/**
 * Created by yoshihisanakai on 2025/04/09.
 */

@IsTest
public with sharing class RegisterContactUseCaseExceptionMock implements RegisterContactUseCase {
  public static Boolean wasCalled = false;

  public void exec(ContactVo vo) {
    wasCalled = true;
    throw new DmlException();
  }
}
