/**
 * Created by yosnak13 on 2025/04/06.
 */

public with sharing class RegisterContactController {
  final RegisterContactUseCase registerContactUseCase;

  @AuraEnabled
  public static void register(final Id accountId, final String contactName, final String email) {
    RegisterContactController controller =
        new RegisterContactController(RegisterContactInjector.newRegisterContactUseCase());

    try {
      controller.registerContactUseCase.exec(new ContactVo(accountId, contactName, email));
    } catch (Exception e) {
      throw new HandledException('取引先責任者の登録に失敗しました: ' + e.getMessage());
    }
  }

  private RegisterContactController(final RegisterContactUseCase registerContactUseCase) {
    this.registerContactUseCase = registerContactUseCase;
  }
}
