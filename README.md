-   [CI Analytics at trunk.io](https://app.trunk.io/docwhat-github/docwhat/bashables/ci-analytics)
-   [![Continuous Integration](https://github.com/docwhat/bashables/actions/workflows/ci.yaml/badge.svg)](https://github.com/docwhat/bashables/actions/workflows/ci.yaml)

# bashables

> A framework and library of bash code, scripts and examples for use when writing your own utilities.

## What is bashables?

It is a framework and library meant to help you write and distribute your own portable utilities.

### The problem we're solving

A lot of projects have tasks or setup that needs to be performed so that the developers can be productive.

Some examples:

-   Installing compilers.
-   Verifying tools are installed and are a compatible version.
-   Checking on the status of software running in the cloud.
-   Authenticating or switching accounts.
-   Running analysis tools.
-   Formatting code according to project standards.

These utilities must be able to work on a developer's laptop which may be Linux, macOS, BSD, or even WSL (Windows Subsystem for Linux) regardless of what tools they have installed or have not installed.

Furthermore, the utilities must be kept up-to-date irrespective of changes in the project's code base.

The utilities almost always have little documentation and no testing.

### How we're solving the problem

We are providing a library of common functions. These are functions that I have written over and over again.

We provide tools to bundle and update the utility into a single package, if possible. These bundles will be easy to install and update.

We will provide tools to create `bash` documentation so that others can work on the generated utilities.

Finally, we are providing some help with writing tests for these utilities.

## Contributuing

Please check out the [CONTRIBUTING guide](CONTRIBUTING.md).
