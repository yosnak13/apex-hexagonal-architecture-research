/**
 * Created by yosnak13 on 2025/04/07.
 */

public with sharing class RegisterContactService implements RegisterContactUseCase {
    final FindAccountRepository accountRepository;
    final RegisterContactRepository contactRepository;
    final SendEmailRepository emailRepository;

    public RegisterContactService(
        FindAccountRepository accountRepository,
        RegisterContactRepository contactRepository,
        SendEmailRepository emailRepository
    ) {
        this.accountRepository = accountRepository;
        this.contactRepository = contactRepository;
        this.emailRepository = emailRepository;
    }

    public void exec(RegisterContactInput input) {
        ContactEntity entity = input.toEntity();
        Savepoint sp = Database.setSavepoint();
        try {
            AccountCollection collection = accountRepository.findById(entity.getAccountId());
            collection.validateExist();
            contactRepository.create(entity);
            emailRepository.sendEmail(entity.toEmailMessage());
        } catch (EmailException e) {
            Database.rollback(sp);
            throw new HandledException(e.getMessage());
        }
    }
}