/**
 * Created by yoshihisanakai on 2025/04/11.
 */

@IsTest
private class LastNameVoTest {

  private static final String BLANK = '';
  private static final Integer MAX_LENGTH = 80;
  private static final String EIGHTY_LENGTH_STR = 'あ'.repeat(MAX_LENGTH);
  private static final String ILLEGAL_MESSAGE = '姓は必須項目で、80文字以内である必要があります。';

  @IsTest
  static void lastNameVoTest() {
    ParameterizedTest[] tests = new List<ParameterizedTest>{
        new ParameterizedTest('山田', true),
        new ParameterizedTest(EIGHTY_LENGTH_STR, true),
        new ParameterizedTest(EIGHTY_LENGTH_STR + 'あ', false),
        new ParameterizedTest(BLANK, false),
        new ParameterizedTest(null, false)
    };

    for (ParameterizedTest t : tests) {
      try {
        LastNameVo actual = new LastNameVo(t.lastName);
        System.assert(t.isAssert);
        System.assertEquals(t.lastName, actual.toLastName());
      } catch (IllegalArgumentException e) {
        System.assertEquals(ILLEGAL_MESSAGE, e.getMessage());
      }
    }
  }

  private class ParameterizedTest {
    final String lastName;
    final Boolean isAssert;

    private ParameterizedTest(String lastName, Boolean isAssert) {
      this.lastName = lastName;
      this.isAssert = isAssert;
    }
  }
}
