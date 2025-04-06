/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactInjector {
  public static RegisterContactService RegisterContactService() {
    // TODO: 生焼け状態はrepository実装後に修正
    RegisterContactRepository repo;
    return new RegisterContactService(repo);
  }
}
