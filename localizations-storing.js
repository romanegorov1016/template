const Excel = require('exceljs');
const fs = require('fs');
const path = require('path');
const fileSep = path.sep;// returns '\\' on windows, '/' on *nix
const workbook = new Excel.Workbook();
let dirPath = './translation_templates';
const obj = new Object();

/**
 * Parsing available localizations .xlsx files in ./translation_templates folder. And create json object with all transtalions, where name of the parsed file become the key of the every localizations.
 * Store list of available localizaions (availableLocalizations)
 * @param dirPath (directory with localizations .xlsx files)
 * @returns json object stored in localization-storage.json file.
 */
(async function () {
  const localization = process.env.LOCALIZATION;
  switch (localization) {
    case 'Chinese':
      dirPath += '/Chinese';
      break;
    case 'Portuguese':
      dirPath += '/Portuguese';
      break;
    case 'Spanish':
      dirPath += '/Spanish';
      break;
    default:
      throw new Error('Please set your localization! Locally in feature file, or globally in common_config file.');
  }
  const filesInDir = fs.readdirSync(dirPath);
  obj.allLanguageItems = [];
  for (let curFileName of filesInDir) {
    if (!curFileName.includes('.xlsx#')) {
      let actual = [];
      const worksheet = await workbook.getWorksheet(1); // or name of the worksheet
      await worksheet.eachRow({ includeEmpty: true }, (row) => {
        actual.push(row.values);
      });
      obj.allLanguageItems.push(actual);
    }
  }
  fs.writeFileSync('./localization-storage.json', JSON.stringify(obj), 'utf8');

  // eslint-disable-next-line no-console
  console.log('Translations were stored from the file to localization-storage.json');
})();