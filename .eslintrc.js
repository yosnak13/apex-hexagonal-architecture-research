// eslint-disable-next-line no-undef
module.exports = {
    extends: ['eslint:recommended', '@salesforce/eslint-config-lwc'],
    env: {
        browser: true,
        es2021: true
    },
    rules: {
        semi: ['error', 'always'],
        quotes: ['error', 'single'],
        'no-console': 'warn',
        'no-unused-vars': 'warn'
    }
};
