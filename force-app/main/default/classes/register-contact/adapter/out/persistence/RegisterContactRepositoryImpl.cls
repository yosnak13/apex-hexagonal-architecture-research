/**
 * Created by yoshihisanakai on 2025/04/07.
 */

public with sharing class RegisterContactRepositoryImpl implements RegisterContactRepository {
  public void create(ContactEntity entity) {
    Contact con = entity.toContact();
    insert con;
  }
}
