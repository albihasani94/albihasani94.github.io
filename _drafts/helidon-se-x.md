---
layout: post
title: "Helidon SE, another breed of speedy"
date: 2020-06-25
permalink: helidon-se
categories: [java, helidon]
tags: [java, helidon, cloud, graalvm, docker]
description: "In this follow-up to the Helidon series, we're going to explore the other Helidon sibling."
image: assets/images/road_runner.jpg
excerpt_separator: <!--more-->
---

In this follow-up to the Helidon series, we're going to explore the other Helidon sibling.

<!--more-->

Since the last article I posted, I have taken a look around and there seem to be a rich community of java lightweight frameworks where the three most attractice to me seem Helidon, Micronaut, and Quarkus. Helidon comes in two flavors:

- Helidon MP which represents the Microprofile implementation (I found myself digging the MicroProfile flavor, that must be one of the perks of being a die-hard Java EE fan)
- Helidon SE is the non-blocking reactive way of building things

Helidon MP is more similar to Quarkus in terms of developer experience, and Micronaut its own thing, more like the Spring Boot appoach.

Where does Helidon SE fit in all of this?

Helidon SE is a microframework that embraces the latest Java SE features: reactive streams, asynchronous and functional programming, and fluent-style APIs.

To dig more into this, we're going to build a project and play with its feature set.

## Creating the project

```bash
mvn -U archetype:generate -DinteractiveMode=false \
    -DarchetypeGroupId=io.helidon.archetypes \
    -DarchetypeArtifactId=helidon-quickstart-se \
    -DarchetypeVersion=2.0.0 \
    -DgroupId=com.albi \
    -DartifactId=helidon-se \
    -Dpackage=com.albi.helidon.se
```

## Exploring the structure

```bash
$ tree .
.
├── Dockerfile
├── Dockerfile.jlink
├── Dockerfile.native
├── README.md
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── albi
    │   │           └── helidon
    │   │               └── se
    │   │                   ├── GreetService.java
    │   │                   ├── Main.java
    │   │                   └── package-info.java
    │   └── resources
    │       ├── META-INF
    │       │   └── native-image
    │       │       └── reflect-config.json
    │       ├── application.yaml
    │       └── logging.properties
    └── test
        └── java
            └── com
                └── albi
                    └── helidon
                        └── se
                            └── MainTest.java
```

## Build the thing

```bash
mvn package
```

## Run it

```bash
java -jar target/helidon-se.ja
```

## Serving first request

```bash
$ curl -X GET http://localhost:8080/greet
{
    "message":"Hello World!"
}
```

## Hold on a sec

The first thing that catches the eye is that the project has a `Main` class. This class is the application starting point and provides access to methods

## Let's switch to OpenAPI to get a better view of our API.
