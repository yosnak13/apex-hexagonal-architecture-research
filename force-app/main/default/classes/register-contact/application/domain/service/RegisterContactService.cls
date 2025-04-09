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
    AccountCollection collection = accountRepository.findById(vo.getAccountId());
    collection.validateExist();
    contactRepository.create(vo);
  }
}
