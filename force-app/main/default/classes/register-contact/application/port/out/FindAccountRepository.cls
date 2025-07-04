/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public interface FindAccountRepository {
    AccountCollection findById(Id accountId);
}