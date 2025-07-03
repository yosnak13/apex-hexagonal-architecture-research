module.exports = {
    extends: ['eslint:recommended', 'plugin:lwc/recommended'],
    plugins: ['lwc'],
    env: {
        browser: true,
        es2021: true
    },
    rules: {
        semi: ['error', 'always'],
        'no-console': 'warn'
    }
};
