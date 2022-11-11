const request = require('request'); // common lib uses it
const { endpointHelper, dataStoreHelper } = require('ngpd-merceros-testautomation-wdio-ta');
const utils = require('../../utils/api-util');
const userData = require('../../data/user-data');

const login = async (user) => {
  const authInfo = {};

  const username = user.login;
  const password = user.password;

  // implement authentication flow here:
  // get Bearer token for Authorization Header
  let authorizationHeader;
  // or
  // get cookie for Cookie Header
  let cookieHeader;
  // or 
  // get cookie jar;
  let cookieJar = request.jar();

  authInfo.headers = new Map();
  if (authorizationHeader) {
    authInfo.headers.set('Authorization', authorizationHeader);
  }

  if (cookieHeader) {
    authInfo.headers.set('Cookie', cookieHeader);
  }

  if (cookieJar) {
    authInfo.headers.set('Accept-Encoding', 'gzip, deflate, br');
    authInfo.headers.set('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9');
    authInfo.cookieJar = {
      jar: cookieJar,
      gzip: true
    };
  }

  dataStoreHelper.setData('authInfo', authInfo);

  return authInfo;
};

module.exports = {
  login
};