---
layout: post
title: "Helidon SE, another breed of speedy"
date: 2020-09-22
permalink: helidon-se
categories: [java, helidon]
tags: [java, helidon, cloud, graalvm, docker]
description: "In this follow-up to the Helidon series, we're going to explore the other Helidon sibling."
image: assets/images/road_runner.jpg
excerpt_separator: <!--more-->
---

In this follow-up to the [Helidon MP]({% post_url 2020-06-10-helidon-mp %}) post, I'm going to explore the other Helidon sibling: Helidon SE.

<!--more-->

As the java lightweight frameworks progress, taking a look around it seems to be a rich community of choices where the three most attractive to me seem Helidon, Micronaut, and Quarkus.

Helidon comes in two flavors:

- Helidon MP which stands for the Microprofile implementation (I found myself digging the MicroProfile flavor, that must be one of the perks of being a die-hard Java EE fan)
- Helidon SE is the non-blocking reactive way of building things (hence the reason for this post)

Helidon MP is more similar to Quarkus in terms of developer experience, while Micronaut has its own thing; more like the approach Spring Boot takes.

Where does Helidon SE fit in all of this?

Helidon SE is a microframework that embraces the latest Java SE features: reactive streams, asynchronous and functional programming, and fluent-style APIs.

To dig more into this, I'm going to build a project and tinker around with its web server specifically.

## Creating the project

We're going to use the maven archetype of helidon-quickstart for setting things up.

```bash
mvn -U archetype:generate -DinteractiveMode=false \
    -DarchetypeGroupId=io.helidon.archetypes \
    -DarchetypeArtifactId=helidon-quickstart-se \
    -DarchetypeVersion=2.0.2 \
    -DgroupId=com.albi \
    -DartifactId=helidon-se \
    -Dpackage=com.albi.helidon.se
```

### Exploring the structure

The generated project contains the following directory structure.

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

Besides the application logic classes which we will dive in a bit, it's good to know that there are provided deployment files for docker images and specific deployments with jlink and GraalVM profiles.

### Build

```bash
mvn package
```

### Serve

```bash
java -jar target/helidon-se.java
```

### Perform the first request

```bash
$ curl -X GET http://localhost:8080/greet
{
    "message":"Hello World!"
}
```

## Dissecting the Main class

One of the things that catch the eye in the project structure is the `Main` class. This class is the application starting point and contains the methods to configure and start the web server.

Exploring the main class, you get access to setting up components such as: config, routing, health checks, and logging.

The logging part aside, I have noticed the following flow of setting things up:

### 1. Create the config

Creating the config is straightforward.

```java
Config config = Config.create();
```

By default this bare statement will pick up `application.yaml` from the classpath.

Its default configuration seems minimal:

```yaml
app:
  greeting: "Hello"

server:
  port: 8080
  host: 0.0.0.0
```

The greeting variable is already defined and ready for the application code to make use of it.

This value would be grabbed by the system properties if it was set, and again the system property would have been overriden if an environment variable had been set.

You can create different configuration sources and use them instead by specifying tighter control employing the config builder.

### 2. Build routing

Let's move on to building a routing configuration.

```java
private static Routing createRouting(Config config) {
    MetricsSupport metrics = MetricsSupport.create();
    GreetService greetService = new GreetService(config);
    HealthSupport health = HealthSupport.builder()
            .addLiveness(HealthChecks.healthChecks())
            .build();

    return Routing.builder()
            .register(health)
            .register(metrics)
            .register("/greet", greetService)
            .build();
    }
```

Here, using provided support for `metrics` and `health`, we register these services at their respective routes: `/metrics` and `/health`. The next route is our own, providing the `greetService`.

Note that we pass the existing `config` that we created to our service, in order to make it available for the routing component.

### 3. Build the web server

We got what we need to build the web server.

```java
WebServer server = WebServer.builder(createRouting(config))
        .config(config.get("server"))
        .addMediaSupport(JsonpSupport.create())
        .build();
```

Again, note that also the web server makes use of the config, based on `application.yaml`, to retrieve the server configuration.

Here, we add the routing we created as an argument to the builder method of WebServer. Also, we add support for JSONP.

### 4. Start the web server

It seems like we're good to go.

```java
server.start()
        .thenAccept(ws -> {
            System.out.println(
                    "WEB server is up! http://localhost:" + ws.port() + "/greet");
            ws.whenShutdown().thenRun(()
                    -> System.out.println("WEB server is DOWN. Good bye!"));
        })
        .exceptionally(t -> {
            System.err.println("Startup failed: " + t.getMessage());
            t.printStackTrace(System.err);
            return null;
        });
```

Here, an attempt is made to start the server and we provide handlers to the outcome of this action. These handlers are passed as lambda functions to the respective results of success and error: `thenAccept` and `exceptionally`.

## Adding another service

Up to this point, we have explored out-of-the-box capabilities that Helidon SE offers, and have seen a fraction of its programming model.

It's natural to add another service to this package so we see how it responds to our needs.

Now, the building block of adding another service is implementing the `Service` interface, located in the `io.helidon.webserver` namespace.

```java
class MovieService implements Service { }
```

This is a functional interface, with a single abstract method, called `update`.

```java
@FunctionalInterface
public interface Service {
    void update(Rules var1);
}
```

This offers the possibility of adding a one line imlpementation of a service, if fit.

For example, adding a new route would be as easy as:

```java
return Routing.builder()
    //...
    .register("/greet", greetService)
    .register("/inline", rules -> rules.get((request, response) -> response.send("Hello world")))
    .build();
```

Performing a GET request on this route will return the requested message.

```bash
$ curl -X GET http://localhost:8080/inline
Hello world
```

This is not the case for services with some more specialized application logic, and rich processing needs, but it is good to know that you can write code in this model for simple things.

A better-suited implementation for most cases would be the continuation of the `MovieService` class.

```java
@Override
public void update(Routing.Rules rules) {
    rules
            .get("/list", this.getListHandler())
            .get("/test", this.getTestHandler());
}
```

The second argument to the `get` method is a `Handler` interface implementation.

```java
private Handler getListHandler() {
    return (request, response) -> response.send(
            JSON.createArrayBuilder(
                List.of("Batman", "Man of Steel", "Shrek"))
                .build()
    );
}
```

Let's set this service up:

```java
MovieService movieService = new MovieService();
return Routing.builder()
    //...
    .register("/movies", movieService)
    .build()
```

Quick testing follows.

```bash
$ curl -X GET http://localhost:8080/movies/test
{"message":"test"}
```

For a more serious movie-goers experience, test the endpoint containing the list of movies.

```bash
$ curl -X GET http://localhost:8080/movies/list
["Batman","Man of Steel","Shrek"]
```

In this example, services proved to be an effective way of of organizing route configuration code and adding multiple methods for a route in a single point of access, the service implementation class.

## A potential downside

Our code example seems like a move away from the simplicity of automatic JSON transformations that other libraries like Spring REST or JAX-RS provide. This is due to the fact that we have added support for JSONP, which requires the converters such as `JsonObject` and `JsonArray`.

After digging a bit, it seems that this issue is resolved after Helidon added support for Jackson. To add this feature into the project, we'd have to include this module in our maven pom file.

```xml
<dependency>
    <groupId>io.helidon.media</groupId>
    <artifactId>helidon-media-jackson</artifactId>
</dependency>
```

Remember when we declared JsonP support in the web server creation? We'd have to change that now to JacksonSupport.

```java
WebServer server = WebServer.builder(createRouting(config))
    .config(config.get("server"))
    .addMediaSupport(JacksonSupport.create())
    .build();
```

That's supposed to be enough for us to remove the Jsonp wrappers from our Movie service class.

```java
private Handler getListHandler() {
    return (request, response) -> response.send(List.of("Batman", "Man of Steel", "Shrek"));
}
```

Let's check if the issue is resolved.

```bash
$ curl -X GET http://localhost:8080/movies/list
["Batman","Man of Steel","Shrek"]
```

It was simple as that. This brings the data transformation on par with the other players' simplicity, keeping the functional lightweight touch that Helidon adds.

To make it more json-object-y like, we would create a Movie class, which would make a great record, one Jackson fully supports them.

After that the repose would be like:

```bash
$ curl -X GET http://localhost:8080/movies/list
[
  {
    "title": "The Dark Knight",
    "year": 2006
  },
  {
    "title": "Man of Steel",
    "year": 2011
  },
  {
    "title": "Shrek",
    "year": 2003
  }
]
```

## Error Handling

What happens if the movies are not available? Let's say the database is down and you cannot get your movies data (oh no), how do you let the consumer of your API know about it?

I'm gonna add a flawed request for this purpose.

```java
rules
    .get("/list", this.getListHandler())
    .get("/list/flawed", this::getFlawedList)
    .get("/test", this.getTestHandler());
```

```java
private void getFlawedList(ServerRequest request, ServerResponse response) {
    throw new UnsupportedOperationException("Sorry movies are closed");
}
```

Let's take the server for a spin and see what hapens.

```bash
$ curl -X GET http://localhost:8080/movies/list/flawed
value cannot be null!
```

This message hardly helps anyone understand what has happened, beyond the fact that something has made our server angry.

Checking the logs, this comes down to the fact that the response cannot be null. Simply adding a message to the exception, and re-performing the GET request, you would get the following response:

```bash
$ curl -X GET http://localhost:8080/movies/list/flawed
Sorry movies are closed
```

This is a more readable message, automatically transformed from the thrown exception to the json response, but the logs still pop up an important warning:

```java
2020.09.22 01:04:44 WARNING io.helidon.webserver.RequestRouting Thread[nioEventLoopGroup-3-1,10,main]: Default error handler: Unhandled exception encountered.
java.util.concurrent.ExecutionException: Unhandled 'cause' of this exception encountered.
```

This lets us know that there no handler for this exception that has occurred. Going back to the pattern that Helidon follows, we're going to extend our method with a failure handler.

To do that, I will set up a method that has the original purpose to supply a CompleteableFuture, but in this case it will fail.

```java
private CompletableFuture<List<Movie>> getFlawedList() {
    return CompletableFuture.failedFuture(new RuntimeException("Sorry movies are closed"));
}
```

And I am going to make sense of this exception.

```java
private void getFlawedListHandler(ServerRequest request, ServerResponse response) {
    this.getFlawedList()
            .thenAccept(response::send)
            .exceptionally(error -> {
                response.status(Http.Status.NOT_FOUND_404);
                response.send(
                        new MovieNotFound("Could not get movies", LocalDateTime.now().toString())
                );
                return null;
            });
}
```

Then update the rules with this route.

```java
rules
    .get("/list", this::getListHandler)
    .get("/list/flawed", this::getFlawedListHandler)
```

If the completeableFuture is successful, this will trigger the `thenAccept` block and perform that action, in this case directly send the response. In case an exception occurs on the way, the `exceptionally` block will catch it and make something out of it. What we do here is set a custom response status code, and return send a custom error message with the response.

```bash
$ curl -X GET http://localhost:8080/movies/list/flawed
{
  "message": "Could not get movies",
  "incidentTime": "2020-09-22T21:43:51.347416"
}
```

The `thenAccept` block could be expanded further to set response status based on the data returned by the completeableFuture, such as `NOT_FOUND` in case of empty list or perform other mappings.

### Revisiting the inline service

In the example above, of writing an inline service for the routing builder, you can swap service registration with specific handler for method.

For example, `register` would become `get` and the Service implementation would become a Handler implementation.

```java
return Routing.builder()
    //...
    .register("/greet", greetService)
    .register("/movies", movieService)
    .get("/inline", (request, response) -> response.send("Hello world"))
    .build();
```

This is a little bit more convinient, regarding the inline route configuration experience.

## What to take out of it

In this post I've taken a quick look to the web server component of Helidon SE. It offers a nice way of setting routes and services up.

If one were to explore other included components such as metrics and health, could do so by accessing the `/metrics` and `/health` endpoints.

I did not include examples for reactive db client support. That first seems like the approach Spring Data takes with r2dbc. As far as I know, reactive mongodb client is supported, and traditional jdbc drivers are supported inside a wrapper.

The Helidon SE flavor it is indeed a move away from the Helidon MP flavor. It is even more micro than that, and takes an event-driven approach. In my opinion, it's a viable option for doing simple things fast, once you get a used a little bit to its programming model.

If you take a look at the bigger scheme of things, there are odds that Helidon SE will co-exist with Micronaut framework in the future. What makes me believe this is Graeme Rocher, the creator of Micronaut joining [Oracle](https://twitter.com/graemerocher/status/1278770836996886528){:target="_blank"}, and statements like [this](https://twitter.com/graemerocher/status/1286398505922297856){:target="_blank"}. The future is exciting.

*Source code is on [Github](https://github.com/albihasani94/helidon-se)*
