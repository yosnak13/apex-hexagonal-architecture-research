/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactService implements RegisterContactUseCase {
  final RegisterContactRepository contactRepository;

  public RegisterContactService(RegisterContactRepository contactRepository) {
    this.contactRepository = contactRepository;
  }

  public void exec(ContactVo vo) {
    contactRepository.register(vo);
  }
}
