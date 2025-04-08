/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactInjector {
  public static RegisterContactUseCase newRegisterContactUseCase() {
    // E2Eテストのために、カスタム設定の項目値を利用するしかない
    ApexTestSetting__c testSetting = ApexTestSetting__c.getInstance();
    if (Test.isRunningTest() && !testSetting.IsE2ETest__c) return new RegisterContactServiceMock();

    return new RegisterContactService(new RegisterContactRepositoryImpl());
  }
}
