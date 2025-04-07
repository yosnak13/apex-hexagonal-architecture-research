/**
 * Created by yosnak13 on 2025/04/06.
 */

public with sharing class RegisterContactController {
  @AuraEnabled
  public static void register(Id accountId, String contactName) {
    RegisterContactUseCase useCase = RegisterContactInjector.newRegisterContactUseCase();
    try {
      useCase.exec(new ContactVo(accountId, contactName));
    } catch (DmlException e) {
      throw e;
    }
  }
}
