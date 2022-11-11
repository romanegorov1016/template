const allureReporter = require('@wdio/allure-reporter').default;
const cucumberReport = require('wdio-cucumberjs-json-reporter').default;

/**
 * Attach response data to allure and cucumber reports
 * 
 * @example
 * attachResponseDataToReport(response)
 *
 * @param response response object returned on sendRequest
 */
const attachResponseDataToReport = (response) => {
  const responseData = {
    'statusCode': response.statusCode,
    'body': response.body,
    'headers': response.headers
  };

  const cucumberResponseData = {
    'response': responseData
  };

  allureReporter.addAttachment(`Response`, responseData, 'application/json');
  cucumberReport.attach(cucumberResponseData, 'application/json');
};

/**
 * Attach request data to allure and cucumber reports
 * 
 * @example
 * attachRequestDataToReport('GET', 'https://postman-echo.com/get');
 *
 * @param method request method
 * @param serviceUri request serviceUri
 * @param requestBody request body
 * @param contentType request contentType
 */
const attachRequestDataToReport = (method, serviceUri, requestBody, contentType = 'application/json') => {
  const allureAttachFileName = `${method} ${serviceUri}`;
  const cucumberAttachData = {
    'request': {
      'method': method,
      'serviceUri': serviceUri
    }
  };

  if (!requestBody) {
    allureReporter.addAttachment(allureAttachFileName, '');
    cucumberReport.attach(cucumberAttachData, 'application/json');
  } else if (contentType === 'application/json') {
    allureReporter.addAttachment(allureAttachFileName, requestBody, contentType);
    cucumberAttachData.request.body = requestBody;
    cucumberReport.attach(cucumberAttachData, contentType);
  } else {
    allureReporter.addAttachment(allureAttachFileName, `Content-Type: ${contentType}\nBody:\n${requestBody}`);
    cucumberAttachData.request.contentType = requestBody;
    cucumberAttachData.request.body = requestBody;
    cucumberReport.attach(cucumberAttachData, 'application/json');
  }
};

const attachUrlToReport = (url) => {
  allureReporter.addAttachment('URL:', url, '');
  cucumberReport.attach(Buffer.from(url).toString('base64'));
};

module.exports = {
  attachResponseDataToReport,
  attachRequestDataToReport,
  attachUrlToReport
};