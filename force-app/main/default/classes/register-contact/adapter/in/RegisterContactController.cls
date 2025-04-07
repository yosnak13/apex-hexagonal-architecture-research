/**
 * Created by yosnak13 on 2025/04/06.
 */

public with sharing class RegisterContactController {
  @AuraEnabled
  public static void register(Id accountId, String contactName) {
    RegisterContactUseCase useCase = RegisterContactInjector.newRegisterContactUseCase();
    useCase.exec(new ContactVo(accountId, contactName));
  }
}
