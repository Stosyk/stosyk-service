<p align="center">
  <img width="498" height="452" src="https://cloud.githubusercontent.com/assets/625463/25073547/cd36d92a-22f1-11e7-80c6-843fafcbc1d4.png">
</p>

# Stosyk Web Service

[![language Swift 3.1](https://img.shields.io/badge/language-Swift%203.1-blue.svg)](https://swift.org)
[![Build Status](https://travis-ci.org/Stosyk/stosyk-service.svg?branch=develop)](https://travis-ci.org/Stosyk/stosyk-service) [![codecov](https://codecov.io/gh/Stosyk/stosyk-service/branch/develop/graph/badge.svg)](https://codecov.io/gh/Stosyk/stosyk-service)

Stosyk is a translation management platform for software projects. The API allows you to work with localization data stored in Stosyk for your account.

### Supported environments:
- [![sandbox](https://img.shields.io/badge/sandbox%20%20%20-https%3A%2F%2Fstosyk--sandbox.herokuapp.com-brightgreen.svg)](https://stosyk-sandbox.herokuapp.com)
- [![production](https://img.shields.io/badge/production-https%3A%2F%2Fstosyk.io-red.svg)](https://stosyk.io)

## Links
- Vapor web framework: http://docs.vapor.codes
- Documentation(ReDoc): https://stosyk.github.io/openapi-spec/
- SwaggerUI: https://stosyk.github.io/openapi-spec/swagger-ui/

## Install

Learn more about Vapor Toolbox <a href="https://vapor.github.io/documentation/getting-started/install-toolbox.html">here</a>.

### Homebrew

```sh
# install Vapor Toolbox
brew install vapor/tap/vapor
```

### Linux
```sh
# install Vapor Toolbox
# Ubuntu 16.04 / Ubuntu 16.10
```

Install pre dependencies

```sh
sudo apt-get install software-properties-common python-software-properties
```

Import verification key with:

```sh
wget -q https://repo.vapor.codes/apt/keyring.gpg -O- | sudo apt-key add -
```

Add this repository to /etc/apt/sources.list as:

```sh
echo "deb https://repo.vapor.codes/apt $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/vapor.list
```

Update apt-get

```sh
sudo apt-get update
```

Install Swift and Vapor

```
sudo apt-get install swift vapor
```

## Launch

Clone the project to a local folder and navigate your terminal there

### Compiling

Make sure you are in the root directory of the project and run the following command.

```
vapor build
```

Note: `vapor build` runs `swift build` in the background.

The Swift Package Manager will first start by downloading the appropriate dependencies from git. It will then compile and link these dependencies together.

### Run

Boot up the server by running the following command.

```
vapor run
```

You should see a message `Server starting...`. You can now visit `http://localhost:8080/v1/projects` in your browser.

### Xcode

We don't include an Xcode project and it is ignored in `.gitignore`.

To generate a new Xcode project for a project, use:

```
vapor xcode
```

### Tests

Run Unit Tests with following commands.

```
vapor build
vapor test
```
