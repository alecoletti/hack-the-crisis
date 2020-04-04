module.exports = {
  extends: ['airbnb-base', 'prettier'],
  env: {
    jest: true
  },
  plugins: ['prettier', 'jest'],
  rules: {
    'prettier/prettier': ['error'],
    'import/no-unresolved': [2, { devDependencies: true }],
    'import/no-extraneous-dependencies': ['error', { devDependencies: true }]
  }
};
