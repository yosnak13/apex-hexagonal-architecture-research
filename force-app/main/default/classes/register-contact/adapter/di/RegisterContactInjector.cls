/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactInjector {
  public static RegisterContactUseCase newRegisterContactUseCase() {
    if (Test.isRunningTest()) return new RegisterContactServiceMock();

    return new RegisterContactService(new RegisterContactRepositoryImpl());
  }
}
