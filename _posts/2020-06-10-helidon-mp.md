---
layout: post
title: "Helidon MP, child of Java EE and the Cloud"
date: 2020-06-10
permalink: helidon-mp
categories: [java, helidon]
tags: [java, helidon, cloud, graalvm, docker]
description: "What is Helidon? Turning to etymology, Helidon comes from Greece and it means the swallow bird in English."
image: assets/images/swallow_noun.jpg
excerpt_separator: <!--more-->
---

What is Helidon? Turning to etymology, Helidon comes from Greece and it means the _swallow_ bird in English.

<!--more-->

According to the Cambridge Dictionary, [swallow](https://dictionary.cambridge.org/dictionary/english/swallow){:target="_blank"} is a small bird with pointed wings and a tail with two points that flies quickly and catches insects to eat as it flies.

![helidon-bird](/assets/images/swallow_noun.jpg)

Oracle nailed it getting the coolest name for a tech framework. You’ve most likely seen this kind of bird at least once, and of course, it is dallëndyshe in Albanian.

Let’s head to the motivation behind this framework and the purpose it holds, as it takes flight.

Now as it is common with birds, there are many families. And Helidon comes in two shapes, Helidon SE and Helidon MP.

Helidon SE embraces the latest Java SE features: reactive streams, asynchronous and functional programming, and fluent-style APIs. At the same time, Helidon MP provides an implementation of the MicroProfile specification. This is the child of Java EE and the cloud.

Helidon SE seems to be the coolest of the siblings, but both look like a step in the right direction to me.

With this post, I am going to give a try to the Helidon MP. I am going to start with the Helidon v2, which requires Maven 3.6.1+ and JDK 11 or newer.

## Preparing the Ground

There is a proper way to start with it, by using a maven archetype.

```bash
mvn archetype:generate -DinteractiveMode=false \
    -DarchetypeGroupId=io.helidon.archetypes \
    -DarchetypeArtifactId=helidon-quickstart-mp \
    -DarchetypeVersion=2.0.0-RC1 \
    -DgroupId=com.albi \
    -DartifactId=helidon-mp \
    -Dpackage=com.albi.helidon.mp
```

By navigating to the project, we see that the directory has the following structure:

```bash
.
├── Dockerfile
├── Dockerfile.jlink
├── Dockerfile.native
├── README.md
├── app.yaml
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── albi
    │   │           └── helidon
    │   │               └── mp
    │   │                   ├── GreetResource.java
    │   │                   ├── GreetingProvider.java
    │   │                   ├── ReactiveService.java
    │   │                   └── package-info.java
    │   └── resources
    │       ├── META-INF
    │       │   ├── beans.xml
    │       │   └── microprofile-config.properties
    │       └── logging.properties
    └── test
        ├── java
        │   └── com
        │       └── albi
        │           └── helidon
        │               └── mp
        │                   └── MainTest.java
        └── resources
            └── META-INF
                └── microprofile-config.properties
```

That’s neat. And there is some code for us. We will look at it shortly.

We build the application:

```bash
mvn package
```

As the build tool fetches the dependencies, runs some tests, we will be set.

## Let's ~~run~~ fly

```bash
java -jar target/helidon-mp.jar
```

Well, that was.. like pretty fast. Let's see what we got here.

Either via curl or Postman (or [Insomnia](https://insomnia.rest/){:target="_blank"}):

```
curl -X GET http://localhost:8080/greet
```

The response is on point:

```
{
  "message": "Hello World!"
}
```

Try another one

```
curl -X GET http://localhost:8080/greet/Helidon
```

Response

```
{
  "message": "Hello Helidon!"
}
```

GET requests are easy. We all know what's tricky. PUT requests. Make the computer listen from your input.

```
curl -X PUT -H "Content-Type: application/json" -d \
  '{"greeting" : "Aloha"}' http://localhost:8080/greet/greeting
```

This request has no response body. It could return the updated greeting in my opinion.

Now we've changed the greeting. Let's greet someone cool, like [Stitch](https://en.wikipedia.org/wiki/Stitch_(Disney)){:target="_blank"}.

```
curl -X GET http://localhost:8080/greet/Stitch
```

Response

```
{
  "message": "Aloha Stitch!"
}
```

The way it works just of the box is impressive. No hand-written dependencies, no setup, and no application server!

Let's see what we had there to start with in more detail.

## Show me the code

The bits of application logic provided to us free of charge or any pain are in the following source files.

```bash
── mp
   ├── GreetResource.java
   ├── GreetingProvider.java
   └── ReactiveService.java
```

We're going to see the main picture without focusing too much on the methods.

First goes the GreetResource:

```java
@Path("/greet")
@RequestScoped
public class GreetResource {

    @Inject 
    GreetingProvider greetingProvider;

    @Path("/{name}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public JsonObject getMessage(@PathParam("name") String name) {
        return createResponse(name);
    }

    // add other paths and methods
```

This is a JAX-RS application. Java EE is dead. Long live Jakarta EE!

Then comes the GreetingProvider:

```java
@ApplicationScoped
public class GreetingProvider {
    private final AtomicReference<String> message = new AtomicReference<>();

    @Inject
    public GreetingProvider(@ConfigProperty(name = "app.greeting") String message) {
        this.message.set(message);
    }

    // getter and setter
}
```

This is a CDI bean. It acts as a provider for the GreetResource, in which it has been injected. The `@ConfigProperty` annotation injects an application property into the source code.
This feature is part of the [MicroProfile Configuration](https://www.tomitribe.com/blog/an-overview-of-microprofile-configuration/){:target="_blank"} API.

## Checking the gears

Taking a look for a minute at the `resources` folder reveals some configuration properties.

```bash
── resources
   ├── META-INF
   │   ├── beans.xml
   │   └── microprofile-config.properties
   └── logging.properties
```

The `beans.xml` belongs to the CDI specification and is used to enable CDI services. By default, annotated beans are considered for dependency injection.

```xml
bean-discovery-mode="annotated"
```

The `microprofile-config.properties` can hold application properties and microprofile server properties, e.g. port.

```properties
# Application properties. This is the default greeting
app.greeting=Hello

# Microprofile server properties
server.port=8080
```

And the logging configuration can be tuned in `logging.properties`, as the name suggests.

## Inspecting over the nest

If we take a look at the `target` directory, where our build is created, we're in for interesting stuff.

```bash
du -sh target/*
 28K	target/classes
  0B	target/generated-sources
  0B	target/generated-test-sources
 12K	target/helidon-mp.jar
 18M	target/libs
4.0K	target/maven-archiver
 16K	target/maven-status
 12K	target/surefire-reports
8.0K	target/test-classes
```

The `jar` where our application logic resides is only `12 KBytes`. That's crazy, even beyond java standards.

The actual reason for that is that application dependencies lie in the `libs` folder. This is a very intuitive decision. 

Build-wise, it allows docker builds to be faster by only doing a rebuild of your application rather than having to build runtime dependencies into the jar, hence the cloud-native part.

Secondly, but no less important, there is a clear separation between the business logic and the libraries, as it should be.

## Adding DataSource to the mix

Add dependencies.

```xml
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>1.4.199</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.helidon.integrations.cdi</groupId>
    <artifactId>helidon-integrations-cdi-datasource-hikaricp</artifactId>
    <scope>runtime</scope>
</dependency>
```

Add db connection properties.

```properties
javax.sql.DataSource.test.dataSourceClassName=org.h2.jdbcx.JdbcDataSource
javax.sql.DataSource.test.dataSource.url=jdbc:h2:mem:test
javax.sql.DataSource.test.dataSource.user=sa
javax.sql.DataSource.test.dataSource.password=
```

Interacting with the db is straightforward.

```java
@Path("/ds")
@ApplicationScoped
public class DataSourceExample {
    @Inject
    @Named("test")
    private DataSource testDataSource;

    @GET
    @Path("tables")
    @Produces("text/plain")
    public String getTableNames() throws SQLException {
        StringBuilder sb = new StringBuilder();
        try (Connection connection = this.testDataSource.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(" SELECT TABLE_NAME"
                             + " FROM INFORMATION_SCHEMA.TABLES "
                             + "ORDER BY TABLE_NAME ASC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                sb.append(rs.getString(1)).append("\n");
            }
        }
        return sb.toString();
    }
}
```

Reaching the endpoint.

```bash
curl -X GET http://localhost:8080/ds/tables
```

This will fetch and display table names for the information schema in H2 database.

```bash
CATALOGS
COLLATIONS
COLUMNS
...
USERS
VIEWS
```

## Adding persistence

I have added persistence to my demo application, but it is nothing more than this [post](https://medium.com/helidon/helidon-and-jpa-da20492f5395){:target="_blank"} I came across. I recommend reading it if you want to take a look at JPA integration.

Now what I want to put an emphasis on is that even after adding datasource and jpa integration to my application, the jar size is impressively small.

There is a bump on the application jar of only from 12KB to 20KB. As expected, the `libs` folder has gotten bigger, from 18MB to 31MB.

```bash
du -sh target/helidon-mp.jar target/libs/
 20K	target/helidon-mp.jar
 31M	target/libs/
```

## OpenAPI

Helidon flies smoothly together with the MicroProfile OpenAPI specification. It provides an implementation to this specification, which is much appreciated.

Naturally, you would want to add these dependencies on your `pom.xml`. In this quickstart, these seem to be pulled from the `helidon-microprofile` artifact.

```xml
<dependency>
    <groupId>org.eclipse.microprofile.openapi</groupId>
    <artifactId>microprofile-openapi-api</artifactId>
    <version>1.1.2</version>
</dependency>
<dependency>
    <groupId>io.helidon.microprofile.openapi</groupId>
    <artifactId>helidon-microprofile-openapi</artifactId>
    <version>2.0.0-RC1</version>
    <scope>runtime</scope>
</dependency>
```

Let's write some API documentation.

```java
@GET
@Path("withSalutation/{salutation}")
@Produces("text/plain")
@Operation(summary = "Returns a greeting", description = "Returns a greeting for the given salutation")
@APIResponse(description = "Text containing the greeting",
        content = @Content(mediaType = MediaType.TEXT_PLAIN, schema = @Schema(implementation = Greeting.class)))
public String getResponse(@PathParam("salutation") String salutation) {
    return greetingService.findBySalutation(salutation);
}
```

With the `@Operation` and `@APIResponse` we have just documented this method.

Now, when the application starts, we can reach the `/openapi` endpoint and the application will serve us an `openapi.yaml` file with this API's OpenAPI specification.

We can import this file to our API development tool and it will create the endpoints for testing.

To make things a little bit more user friendly, we can add a touch of Swagger UI.

```xml
<dependency>
    <groupId>org.microprofile-ext.openapi-ext</groupId>
    <artifactId>openapi-ui</artifactId>
    <version>1.1.4</version>
    <scope>runtime</scope>
</dependency>
```

On our browser, by navigating to `http://localhost:8080/openapi-ui` a familiar taste welcomes us.

![openapi-ui](/assets/images/openapi-ui.png)

## Sailing with Docker

To explore a bit of the cloud native side of Helidon, we would start with `docker`.

The quickstart provides a `Dockerfile` to make things smoother. What is there for us to do?

Build the image.

```bash
docker build -t helidon--mp .
```

I seemed to never get this command working. To get it right, I had to take some notes on static weaving and one of the Helidon creators on Slack pointed me to a solution.
The problem is that, when configuring the JPA integration, we enabled static weaving. 

Heading to EclipseLink [documentation](https://www.eclipse.org/eclipselink/documentation/2.7/concepts/app_dev005.htm#CCHJEDFH){:target="_blank"}: "Weaving is a technique of manipulating the byte-code of compiled Java classes. The EclipseLink JPA persistence provider uses weaving to enhance both JPA entities and Plain Old Java Object (POJO) classes for such things as lazy loading, change tracking, fetch groups, and internal optimizations."

So, weaving can be done dynamically at runtime, or statically at build time. Helidon does not support dynamic weaving, as it tends to embrace the lightweight option between the two. This is obviously a performance-wise decision.

### What does this have to do with the docker build?

If we see carefully the `Dockerfile`, there are two `mvn` invocations in the build.

```Dockerfile
# Create a first layer to cache the "Maven World" in the local repository.
# Incremental docker builds will always resume after that, unless you update
# the pom
ADD pom.xml .
RUN mvn package -DskipTests

# Do the Maven build!
# Incremental docker builds will resume here when you change sources
ADD src src
RUN mvn package -DskipTests
```

The first invocation pulls the dependencies layer separately from the second invocation which builds the application layer.
For the first invocation, there is no build. No build means no target folder output. When the eclipselink plugin runs, it attempts to perform weaving on the classes produced
by mvn command. Since there is no target folder, this fails and I would get this message:

```bash
[ERROR] Failed to execute goal
com.ethlo.persistence.tools:eclipselink-maven-plugin:2.7.5.1:weave
(weave) on project helidon-mp:
Source directory /helidon/target/classes does not exist -> [Help 1]
```

Luckily, there is a flag to prevent the plugin from running in the first command.

```Dockerfile
RUN mvn package -DskipTests -Declipselink.weave.skip=true
```

This fixed the build for me. To prevent it from happening to new users, I would suggest either adding the option beforehand in the quickstart-archetype's Dockerfile or document the necessity of its usage in the JPA section in the documentation. That's up for discussion.

#### Sail

```bash
docker run --rm -p 8080:8080 helidon-mp:latest
```

#### Voila

```bash
2020.06.09 20:36:13 INFO io.helidon.microprofile.server.ServerCdiExtension
Thread[main,5,main]: Server started on http://localhost:8080
(and all other host addresses) in 4619 milliseconds (since JVM startup).
```

For some reason, the docker image starts up even faster than my local installation. Only `4619 ms`, and that's for an application with JAX-RS, CDI, JPA, OpenAPI, Config, Health, and Metrics.

Let's do a change in the code and rebuild the image to see how the building process changes. I am changing the default message to something more classy.

```java
@GET
@Produces(MediaType.APPLICATION_JSON)
public JsonObject getDefaultMessage() {
    return createResponse("Monde");
}
```

Now I'm doing a rebuild of the docker image.

```bash
docker build -t helidon--mp .
```

And test it

```bash
curl -X GET http://localhost:8080/greet
{"message":"Hello Monde!"}
```

The rebuild process is seamless and it is pretty fast.

Alternatively, we could use [Jib](https://github.com/GoogleContainerTools/jib){:target="_blank"}. That is not the point of this post but I have included an example of that in the source code.

## Stepping the game up with jlink

Introduced with Java 9, jlink is a tool to assemble and optimize a set of modules and their dependencies into a custom runtime image.

This means creating slimmed down Java Runtimes who provide only the modules of JDK that we know our application might use at some point.

Helidon already ships with its own `helidon-maven-plugin` which makes it effortless to create runtime images with jlink.

There is already a profile for us.

```bash
mvn package -Pjlink-image
```

The output looks neat.

```bash
[INFO] Java Runtime Image helidon-mp completed in 45.1 seconds
[INFO]
[INFO]      initial size: 312.7M  (279.6 JDK + 33.1 application)
[INFO]        image size: 150.7M  ( 46.5 JDK + 33.1 application + 71.1 CDS)
[INFO]         reduction:  51.8%
```

There is runtime reduction from `312.7MB` to `150.7MB`, only half of it.

The output is the `target/helidon-mp` directory which contains both the JDK image and the application with its dependencies.

To start the application

```bash
./target/helidon-mp/bin/start
```

To make the most out of jlink size-reduction, we would create a docker image with the custom runtime image.

```bash
docker build -t helidon-quickstart-mp-jlink -f Dockerfile.jlink .
```

On a side note, startup time inside the docker container is also reduced to `3694 ms`.

```bash
2020.06.10 00:54:10 INFO io.helidon.microprofile.server.ServerCdiExtension 
Thread[main,5,main]: Server started on http://localhost:8080 
(and all other host addresses) in 3694 milliseconds (since JVM startup).
```

## Last but not least, GraalVM

The tricky part here is getting GraalVM to work in MacOS Catalina. I cannot document that process, but I can tell you that a subsequent number of keystrokes made it work. This is a known [issue](https://www.graalvm.org/docs/release-notes/known-issues/){:target="_blank"} due to application allowance policy in MacOS 10.15.

After installing GraalVM, and installing `native-image`.

Be ready to get your machine fried.

```bash
mvn package -Pnative-image
```

My machine became so hot I had to open my window to give it air support.

After subsequent runs, I still could not get the graalvm build to work. Reading the logs, this was partly due to H2 driver incompatibility from either side, GraalVM or H2. So, work has still to be done in that direction.

To get a taste of GraalVM, I would start to strip down some application features. After removing `datasource` and `jpa` integration in a separate [branch](https://github.com/albihasani94/helidon-mp-playground/tree/native-image){:target="_blank"}, I was able to get it going.

That doesn't look so good for production, but the GraalVM support for Helidon MP is still in early phases so I would expect better interoperability by the end of the year. Helidon SE should fully support GraalVM native images.

Only later I learned that this is known and the [roadmap](https://github.com/oracle/helidon/issues/716){:target="_blank"} for native images with Helidon MP does not yet support [JPA and JTA](https://github.com/oracle/helidon/issues/1293){:target="_blank"} at this time.

The build produces a single executable file, and that's all you need to run.

```bash
./target/helidon-mp
2020.06.10 12:25:33 INFO io.helidon.microprofile.server.ServerCdiExtension
Thread[main,5,main]: Server started on http://localhost:8080
(and all other host addresses) in 68 milliseconds (since JVM startup).
```

That happened in around `0.06s`. The whole application startup. That's beyond any expectation I had. GraalVM is so fast it is ridiculous.

Let's see if GraalVM is fooling with us.

```bash
curl -X GET http://localhost:8080/greet/GraalVM
{"message":"Hello GraalVM!"}
```

It's unfortunate that I had to miss datasource and jpa integration in my demo, but I don't have any doubts on whether a full MicroProfile application will work in the future with GraalVM. We've got a glimpse into that future and it looks so promising.

## Conclusion

In this first part of Helidon series (there has to be at least one another part, Helidon SE), I would take away some considerations.

The architecture of Helidon MP must be a result of some right decisions design-wise. The application jar remained very small during the whole series of changes and I think it's a good thing to separate application logic from dependencies.

The docker and jlink integration make for some enjoyable image creating process, and you reap the benefits of smaller images and faster startup times.

And oh my, GraalVM is so fast.

This is the first time I've taken a serious look at MicroProfile, and it brings back some Java EE memories without having to use an application server at all. I think that developer experience is good with Helidon, the community is very welcoming, and there is a mindset for the lightweight approach and performance that goes into each decision.

The code is out [there](https://github.com/albihasani94/helidon-mp-playground){:target="_blank"}.

On a personal note, it feels refreshing to get to write after such a long time. Since the last time I did Earth has seen a global disease outbreak, the quarantine, [UFOs](https://www.theguardian.com/world/2020/apr/27/pentagon-releases-three-ufo-videos-taken-by-us-navy-pilots){:target="_blank"} were confirmed by the US government, there were massive protests in USA, and they burnt down an [Arby's](https://twitter.com/officialmcafee/status/1266324846826397699){:target="_blank"}. We have to come together as humans, be kind, and this too shall pass.
