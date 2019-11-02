---
layout: post
title:  "Let there be var"
date:   2019-11-02
permalink: /draft-there
categories: [java10, var]
tags: [java10, var]
excerpt: "Being late to the game with var in Java? No problem."
---

*This is old news.*

I have heard this excerpt at a talk by Brian Goetz and you can't blame him. From the time var was introduced to the language, it was dreaded and loved, feared and embraced.. and the world with var is not that bad after all.

## Local Variable Type Inference

To understand the roots of this feature, one ought to have to have heard about *Project Amber.* This nice gem-y name project is all about introducing new language features to keep Java modern and more attractive to developers. *(Java you have always been good, it's just that these improvements will do no bad either).*

Local-Variable type inference is part of this project under the umbrella of [JEP 286](https://openjdk.java.net/jeps/286).

Did this invention happen in Java? Not by a long shot. Java's evil twin brother (C#) has had var for more than a decade now, and other languages in the JVM ecosystem like Scala, Groovy and Kotlin already support a form of local-variable type inference.

## The Ceremony

```java
URL url = new URL("https://www.albinhasani.net/");
URLConnection conn = url.openConnection();
BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));

String inputLine;
while ((inputLine = reader.readLine()) != null) {
    System.out.println(inputLine);
}
```

Running this code will output the contents of the HTML file at the homepage of this blog.

What's wrong? Nothing. This code just is not fun to write.

## How do we make it fun to write?

Give developers autonomy, office perks, a big kitchen, a PS4 playground, and a high salary.

All nice. *But* still from a developer perspective is not as much fun to write.

Now let's look at this.

```java
var url = new URL("https://www.albinhasani.net/");
var conn = url.openConnection();
var reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));

String inputLine;
while ((inputLine = reader.readLine()) != null) {
    System.out.println(inputLine);
}
```

This immediately removes some clutter from the program. It needs strong emphasis to be put on the variable naming though. 

However a bad name it may be, everyone could guess that a `BufferedReader magicMaker` is a BufferedReader, but one would need `var reader` explicitly named to guess what this variable may be about without looking at the right side of the assignment. 

Don't get me wrong, I am a strong advocate of good naming in all cases, this case only needs some extra attention.

![how dare you?](/assets/images/how-dare-you-stand-where-he-stood.jpg)

## The birth of var

This type of type inference can only be used for local variables in methods, not fields or method return types.

It has been around for some time in Java in some kind. You could write code like this with the addition of streams.

```java
int longestTitle = books.stream()
        .map(b -> b.getTitle())
        .mapToInt(String::length)
        .max()
        .orElse(0);
```

In this block of code, we didn't have to:

- declare any intermediate type like Stream<Book> or IntStream
- declare the type of lambda variable b

Local Variable Type Inference pushes this one step further with the local types.

```java
var path = Paths.get(fileName);
var bytes = Files.readAllBytes(path);
var list = new ArrayList<String>();
```

The var identifier is not a keyword which means that its usages as a field, method, or package name will not be affected. Code that uses var as a class or interface name will be affected. As if anyone did that already. (Looking at you caveman working on Java).

## Benefits

- Write less to mean more
- Very handy in case of complex types such as these involving generics

## Caveats

Not any major caveats to be aware of, despite the obvious one:

- choose careful naming, nobody would know the type of `var a = b.getNext()`

## Conclusion

While not a paradigm shift among the Java language, this change is a sign that the language is now progressing at a fast pace.

Local-Variable Type Inference continues to remove some boilerplate from the process of writing code, making the language more attractive to developers.

Codebases will benefit, code will be written quicker, managers will be happy to show off about their companies living in the future.
