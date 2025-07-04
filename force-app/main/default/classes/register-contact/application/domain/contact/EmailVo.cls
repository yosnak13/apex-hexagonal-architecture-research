/**
 * Created by yoshihisanakai on 2025/04/11.
 */

public with sharing class EmailVo {
    final String email;

    /**
     * ^(?!\\.)	ローカル部の先頭に . がない
     * (?!.*\\.\\.)	全体に連続 .. がない
     * [a-zA-Z0-9._%+-]+	ローカル部本体
     * (?<!\\.)	ローカル部の末尾が . でない
     * @	@ で区切る
     * [a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*	サブドメイン対応（連続ドット禁止）
     * (\\.[a-zA-Z]{2,})$	TLD（Top Level Domain）は2文字以上必須
     */
    private static final String EMAIL_PATTERN = '^(?!\\.)(?!.*\\.\\.)[a-zA-Z0-9._%+-]+(?<!\\.)@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,})$';

    private static final String INVALID_EMAIL_MESSAGE = '無効なメールアドレスです。';

    public EmailVo(String email) {
        if (String.isBlank(email) || !Pattern.matches(EMAIL_PATTERN, email)) {
            throw new IllegalArgumentException(INVALID_EMAIL_MESSAGE);
        }
        this.email = email;
    }

    public String toEmail() {
        return email;
    }
}