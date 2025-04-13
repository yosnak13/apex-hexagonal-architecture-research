/**
 * Created by yoshihisanakai on 2025/04/11.
 */

@IsTest
private class EmailVoTest {
  private static final String TEST_EMAIL = 'test@example.com';
  private static final String INVALID_EMAIL_MESSAGE = '無効なメールアドレスです。';

  @IsTest
  static void testValidEmail() {
    ParameterizedTest[] tests = new List<ParameterizedTest>{
        // valid patterns
        new ParameterizedTest(TEST_EMAIL, true), // basic pattern
        new ParameterizedTest('user@mail.example.co.jp', true), // with subdomain
        new ParameterizedTest('user123@domain99.org', true), // includes number
        new ParameterizedTest('john.doe+tag@example.co.uk', true), // includes symbol
        new ParameterizedTest('Test.Email@Example.COM', true), // includes large case
        // invalid patterns
        new ParameterizedTest('test.example.com', false), // without @
        new ParameterizedTest('@example.com', false), // blank before @
        new ParameterizedTest('user@', false), // blank after @
        new ParameterizedTest('user@example', false), // no dot in domain
        new ParameterizedTest('.user@example.com', false), // dot locates at top of local part
        new ParameterizedTest('user.@example.com', false), // dot locates at end of local part
        new ParameterizedTest('user..name@example.com', false), // double dot in local part
        new ParameterizedTest('user.name@sub..example.com', false), // double dot in domain
        new ParameterizedTest('user@@example.com', false), // double @ exists
        new ParameterizedTest('user@example.c', false), // too short TLD
        new ParameterizedTest('###@example.com', false), // only symbol in local part
        new ParameterizedTest('user@com', false) // invalid  domain
    };

    for (ParameterizedTest t : tests) {
      try {
        EmailVo vo = new EmailVo(t.email);
        System.assertEquals(t.email, vo.toEmail());
        System.assert(t.isAssert);
      } catch (IllegalArgumentException e) {
        System.assert(!t.isAssert);
        System.assertEquals(INVALID_EMAIL_MESSAGE, e.getMessage());

      }
    }
  }

  private class ParameterizedTest {
    final String email;
    final Boolean isAssert;

    private ParameterizedTest(String email, Boolean isAssert) {
      this.email = email;
      this.isAssert = isAssert;
    }
  }
}
