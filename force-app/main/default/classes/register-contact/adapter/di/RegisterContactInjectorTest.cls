/**
 * Created by yoshihisanakai on 2025/04/07.
 */

@IsTest
private class RegisterContactInjectorTest {
  @IsTest
  static void newRegisterContactUseCaseTestInTestContext() {
    RegisterContactService actual = RegisterContactInjector.newRegisterContactUseCase();
    // ビルドできていればOK、Mockを連携することになるがUseCaseの内部実装を検証しない。
    System.assertNotEquals(null, actual);
  }
}
