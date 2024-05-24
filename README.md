# test-spark
test-spark + maven + github ci

## setup (ubuntu)
- sudo apt-get install openjdk-19-jdk
- sudo apt-get install maven

## To build:
- mvn compile
- mvn package

## To test
curl http://localhost:4567/hello


## docker & docker-compose
- docker-compose build
- docker-compose up
- docker-compose stop

## Setup of Github Actions
```
# This workflow will build a Java project with Maven, and cache/restore any dependencies to improve the workflow execution time
# For more information see: https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven

# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

name: Java CI with Maven

on:
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4
    - name: Set up JDK 19
      uses: actions/setup-java@v3
      with:
        java-version: '19'
        distribution: 'temurin'
        cache: maven
    - name: Build with Maven
      run: mvn -B package --file pom.xml

    # Optional: Uploads the full dependency graph to GitHub to improve the quality of Dependabot alerts this repository can receive
    - name: Update dependency graph
      uses: advanced-security/maven-dependency-submission-action@571e99aab1055c2e71a1e2309b9691de18d6b7d6
```

## How to deploy to Maven Github Repository

- Access to your GitHub account (organization or personal)
- Settings
- < Developer Settings >
- Personal Access / Tokens (classic)
- Create or choose a token with the following permissions:
  * write:packages - Upload packages to GitHub Package Registry
  * read:packages - Download packages from GitHub Package Registry
  * delete:packages - Delete packages from GitHub Package Registry

**Choose an appropriate expiration date**

Change the file `pom.xml` adding a section for deployment
```xml
<distributionManagement>
  <repository>
      <id>github</id>
      <name>GitHub ACCOUNT Apache Maven Packages</name>
      <url>https://maven.pkg.github.com/YOURACCOUNT/your-repository</url>
  </repository>
</distributionManagement>
```

Create or modify `~./m2/settings.xml` file:
```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      http://maven.apache.org/xsd/settings-1.0.0.xsd">

  <activeProfiles>
    <activeProfile>github</activeProfile>
  </activeProfiles>

  <profiles>
    <profile>
      <id>github</id>
      <repositories>
        <repository>
          <id>github</id>
          <url>https://maven.pkg.github.com/YOURACCOUNT/your-repository</url>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
      </repositories>
    </profile>
  </profiles>

  <servers>
    <server>
      <id>github</id>
      <username>{GITHUB.USERNAME}</username>
      <password>{GITHUB.TOKEN}</password>
    </server>
  </servers>
</settings>
```

After the `build` it's enough to run `mvn deploy` to transfer your JAR file to GitHub Maven Directory

The package will be available in your GitHub repo.
