/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactInjector {
    public static RegisterContactUseCase newRegisterContactUseCase() {
        // E2Eテストのために、カスタム設定の項目値を利用するしかない。Unitテスト以外は実装クラスを返す
        if (isUnitTest()) {
            return new RegisterContactServiceMock();
        }

        return new RegisterContactService(
            new FindAccountRepositoryImpl(),
            new RegisterContactRepositoryImpl(),
            new SendEmailRepositoryImpl()
        );
    }

    private static Boolean isUnitTest() {
        return Test.isRunningTest() && !ApexTestSetting__c.getInstance().IsE2ETest__c;
    }
}
