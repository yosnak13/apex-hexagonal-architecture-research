/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactInjector {
  public static RegisterContactService RegisterContactService() {
    RegisterContactRepository repo = new RegisterContactRepositoryImpl();
    return new RegisterContactService(repo);
  }
}
