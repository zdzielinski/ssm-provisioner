# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [0.0.4](https://gitlab.com/zdzielinski/ssm-provisioner/compare/v0.0.3...v0.0.4) (2022-01-31)

### [0.0.3](https://gitlab.com/zdzielinski/ssm-provisioner/compare/v0.0.2...v0.0.3) (2022-01-31)


### Features

* added pre-commit hook via husky to check for repository secrets ([8f1c1ba](https://gitlab.com/zdzielinski/ssm-provisioner/commit/8f1c1baae8247fccf0c2fe83fd53e23c2f18e9b0))
* added simple npm test framework for ease of release validation ([28e0a4a](https://gitlab.com/zdzielinski/ssm-provisioner/commit/28e0a4a71f7d082705d43e8426c947df1d8fd5df))
* added the ability to pass environment variables to the remote script ([1988c12](https://gitlab.com/zdzielinski/ssm-provisioner/commit/1988c1262cd2515279fa32631ed606458116527c))


### Bug Fixes

* fixed bug where SSM timeout waiting was not working correctly, and could potentially never exit ([053b54c](https://gitlab.com/zdzielinski/ssm-provisioner/commit/053b54cbca81442258d06b1ad69286e0d63948e3))
* fixed bug where the SSH port was not being ingested correctly ([1ed46bd](https://gitlab.com/zdzielinski/ssm-provisioner/commit/1ed46bdc882c454f6c72f5e5c76c924b61dd87ec))

### [0.0.2](https://gitlab.com/zdzielinski/ssm-provisioner/compare/v0.0.1...v0.0.2) (2022-01-30)


### Bug Fixes

* fixed bug with bash debugging not re-enabling for one instance of sensitive output masking ([5d990cf](https://gitlab.com/zdzielinski/ssm-provisioner/commit/5d990cf15e1846e64fb00ec752e6d206d9a55a51))

### 0.0.1 (2022-01-30)
