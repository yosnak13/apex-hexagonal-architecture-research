/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactInjector {
  public static RegisterContactService newRegisterContactUseCase() {
    return new RegisterContactService(resolveRepository());
  }

  private static RegisterContactRepository resolveRepository() {
    if (Test.isRunningTest()) return new RegisterContactRepositoryMock();

    return new RegisterContactRepositoryImpl();
  }
}
