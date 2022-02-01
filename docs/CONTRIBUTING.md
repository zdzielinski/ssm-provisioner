# contributing

This page describes the process of contributing to this project.

## Local Development

Steps to set up your local development environment for contribution.

### Requirements

The following packages must be installed:

* [NodeJS](https://nodejs.org/en/download/)
* [GitLeaks](https://github.com/zricethezav/gitleaks)

### Setup

Install all global NPM packages:

```bash
npm install -g commitizen
```

Install all repository NPM packages:

This will also link versioned git hooks via `husky` for commit validation.

```bash
npm i
```

After installation, versioned git hooks will be automatically linked via `husky`.

## Submitting Code

First, [create a fork](https://gitlab.com/zdzielinski/ssm-provisioner/-/forks/new) of the repository.

Work on your proposed changes, ensure all of your commits follow the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.

Any contributions that do not follow this standard will be rejected.

When you are ready to submit your changes, [open a merge request](https://gitlab.com/zdzielinski/ssm-provisioner/-/merge_requests/new) in the repository.

## NPM References

An unstructured set of NPM documentation references:

* https://typicode.github.io/husky/#/
* https://github.com/conventional-changelog/standard-version
* https://github.com/commitizen/cz-cli
* https://github.com/commitizen/cz-conventional-changelog
* https://commitlint.js.org/#/