/**
 * Created by yosnak13 on 2025/04/06.
 */

public with sharing class RegisterContactController {
  final RegisterContactUseCase registerContactUseCase;

  @AuraEnabled
  public static void register(final Id accountId, final String contactName, final String email) {
    RegisterContactController controller =
        new RegisterContactController(RegisterContactInjector.newRegisterContactUseCase());

    // TODO: 具体的な例外は独自の例外を実装する
    try {
      controller.registerContactUseCase.exec(new ContactVo(accountId, contactName, email));
    } catch (HandledException e) {
      throw new HandledException('取引先責任者の登録に失敗しました: ' + e.getMessage());
    }
  }

  private RegisterContactController(final RegisterContactUseCase registerContactUseCase) {
    this.registerContactUseCase = registerContactUseCase;
  }
}
