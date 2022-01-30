const standardVersion = require('standard-version')

module.exports = {
  noVerify: true,
  commitAll: true,
  infile: "docs/CHANGELOG.md",
  packageFiles: [
    {
      filename: "package.json",
      type: "json"
    }
  ],
  bumpFiles: [
    {
      filename: "package.json",
      type: "json"
    },
    {
      filename: "package-lock.json",
      type: "json"
    },
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