<p align="center">
  <img width="249" height="226" src="https://cloud.githubusercontent.com/assets/625463/25073793/b6cc61d2-22f6-11e7-8718-33b2582b80a4.png">
</p>

# Stosyk Web Service

[![language Swift 3.1](https://img.shields.io/badge/language-Swift%203.1-blue.svg)](https://swift.org)
[![Build Status](https://travis-ci.org/Stosyk/stosyk-service.svg?branch=develop)](https://travis-ci.org/Stosyk/stosyk-service) [![codecov](https://codecov.io/gh/Stosyk/stosyk-service/branch/develop/graph/badge.svg)](https://codecov.io/gh/Stosyk/stosyk-service)

Stosyk is a translation management platform for software projects. The API allows you to work with localization data stored in Stosyk for your account.

### Supported environments:
- [![sandbox](https://img.shields.io/badge/sandbox%20%20%20-https%3A%2F%2Fstosyk--sandbox.herokuapp.com-brightgreen.svg)](https://stosyk-sandbox.herokuapp.com)
- [![production](https://img.shields.io/badge/production-https%3A%2F%2Fstosyk.io-red.svg)](https://stosyk.io)

## Links

- Documentation(ReDoc):
    + https://stosyk.github.io/apidoc/public/
    + https://stosyk.github.io/apidoc/manage/
    + https://stosyk.github.io/apidoc/admin/
- SwaggerUI:
    + https://stosyk.github.io/apidoc/public/swagger-ui/
    + https://stosyk.github.io/apidoc/manage/swagger-ui/
    + https://stosyk.github.io/apidoc/admin/swagger-ui/
- Download full specs: https://stosyk.github.io/openapi-spec/

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

### PostgreSQL

We use Postgres as database. The easiest way to install Postgres is through Homebrew. 
Type in your terminal to download Postgres

```sh
brew install postgres
```

Type `psql --version` in the terminal to ensure that you have downloaded Postgres correctly, and you should see something like `psql (PostgreSQL) 9.5.4`.

Type `postgres -D /usr/local/var/postgres/` to start the Postgres server running locally

Once the server has started up, create the database `createdb stosyk`.
`\l` to list all available databases, `\c stosyk` to connect to stosyk db.

Create a configuration file for Postgres at `Config/secrets/postgresql.json` with following content:
```sh
{
    "host": "127.0.0.1",
    "user": "username",
    "password": "",
    "database": "stosyk",
    "port": 5432
}
```
Replace username with the name of your user.

Note that git ignores this file, check `.gitignore` for details.

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
