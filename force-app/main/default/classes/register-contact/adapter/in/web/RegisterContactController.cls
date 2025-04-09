/**
 * Created by yosnak13 on 2025/04/06.
 */

public with sharing class RegisterContactController {
  final RegisterContactUseCase registerContactUseCase;

  private static final String REGISTER_FAILED_MESSAGE = '取引先責任者の登録に失敗しました: ';

  @AuraEnabled
  public static void register(final Id accountId, final String contactName, final String email) {
    RegisterContactController controller =
        new RegisterContactController(RegisterContactInjector.newRegisterContactUseCase());

    try {
      controller.registerContactUseCase.exec(new RegisterContactInput(accountId, contactName, email));
    } catch (HandledException e) {
      throw new HandledException(REGISTER_FAILED_MESSAGE + e.getMessage());
    }
  }

  private RegisterContactController(final RegisterContactUseCase registerContactUseCase) {
    this.registerContactUseCase = registerContactUseCase;
  }
}
