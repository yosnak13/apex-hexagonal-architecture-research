/**
 * Created by yoshihisanakai on 2025/04/11.
 */

public with sharing class LastNameVo {
    final String lastName;

    private static final Integer MAX_LENGTH = 80; // Salesforce上の最大値
    private static final String ILLEGAL_MESSAGE = '姓は必須項目で、80文字以内である必要があります。';

    public LastNameVo(String lastName) {
        if (String.isBlank(lastName) || lastName.length() > MAX_LENGTH)
            throw new IllegalArgumentException(ILLEGAL_MESSAGE);

        this.lastName = lastName;
    }

    public String toLastName() {
        return lastName;
    }
}