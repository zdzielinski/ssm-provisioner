const standardVersion = require('standard-version')

module.exports = {
  noVerify: true,
  commitAll: true,
  infile: "docs/CHANGELOG.md",
  bumpFiles: [
    {
      filename: "README.md",
      updater: require("./.updaters/v-string-updater.js")
    },
    {
      filename: "ssm-provisioner.sh",
      updater: require("./.updaters/v-string-updater.js")
    }
  ]
};