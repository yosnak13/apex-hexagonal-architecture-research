/**
 * Created by yoshihisanakai on 2025/04/07.
 */

public with sharing class RegisterContactRepositoryImpl implements RegisterContactRepository {
  public void create(ContactVo vo) {
    Contact con = vo.buildNewContact();
    insert con;
  }
}
