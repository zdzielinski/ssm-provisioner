// obtain current version from package.json
const package = require('../package.json');
const currentVersion = package.version;

// skip attempting to find version in any files
// return current version from package.json
module.exports.readVersion = function (contents) {
  return currentVersion;
}

// knowing current version, replace it's occurence with new version
// replace instances of `v<currentVersion>` with `v<newVersion>
module.exports.writeVersion = function (contents, newVersion) {
  console.log(`Version: ${version}`);
  return contents.replace(`v${currentVersion}`, `v${newVersion}`);
}