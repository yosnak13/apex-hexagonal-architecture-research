/**
 * Created by yoshihisanakai on 2025/04/09.
 */

public interface FindAccountRepository {
  AccountListEntity findById(Id accountId);
}
