/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactService implements RegisterContactUseCase {
  final FindAccountRepository accountRepository;
  final RegisterContactRepository contactRepository;

  public RegisterContactService(FindAccountRepository accountRepository, RegisterContactRepository contactRepository) {
    this.accountRepository = accountRepository;
    this.contactRepository = contactRepository;
  }

  public void exec(ContactVo vo) {
    Savepoint sp = Database.setSavepoint();
    AccountListEntity accountEntities = accountRepository.findById(vo.getAccountId());
    if (accountEntities.isEmpty()) {
      Database.rollback(sp);
      throw new HandledException('取引先が存在しないため、取引先責任者を登録できませんでした。');
    }
    contactRepository.create(vo);
  }
}
