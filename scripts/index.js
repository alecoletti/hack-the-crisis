const PasswordGenerator = require('strict-password-generator').default;
const AWS = require('aws-sdk');

const passwordGenerator = new PasswordGenerator();

const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({
  region: 'eu-west-1',
});

const UserPoolId = '<ADD_THE_USERPOOL_ID>';
const options = {
  upperCaseAlpha: true,
  lowerCaseAlpha: true,
  number: true,
  specialCharacter: false,
  exactLength: 12,
};

const addUser = (email) => {
  const params = {
    UserPoolId,
    Username: email,
    TemporaryPassword: passwordGenerator.generatePassword(options),
    UserAttributes: [
      {
        Name: 'email',
        Value: email,
      },
      {
        Name: 'email_verified',
        Value: 'true',
      },
    ],
  };

  return cognitoidentityserviceprovider
    .adminCreateUser(params)
    .promise()
    .catch((err) => {
      console.log(`ERROR: ${err.code} - ${err.message}`);
    });
};

addUser('<ADD_A_VALID_EMAIL>');
