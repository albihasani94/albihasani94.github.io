---
layout: post
title: "Helpful NPEs and where to find them"
date: 2020-10-11
permalink: helpful-npes
categories: [java, jdk, npe]
tags: [java, jdk, npe]
description: "What drives Java developers crazy and goes away when given developers a strong brew of coffee? NullPointerExceptions."
image: assets/images/what_is_npe.png
excerpt_separator: <!--more-->
---

What drives Java developers crazy and goes away when given developers a strong brew of coffee? NullPointerExceptions.

<!--more-->

How many times was your code confident to call that method on the object? Only to find the JVM crush its hopes by blabbering a lot of console language, crush your perfect solution to pieces, and leave only a witness statement as its final output: NullPointerException.

This construct has always puzzled developers.

![what-is-npe](/assets/images/what_is_npe.png)

Tony Hoare, went as far as to call the introduction of the null reference his [billion dollar mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/){:target="_blank"}, publicly apologizing for it. He is probably the only dude alive who could get away with it, given his contributions in Computer Science and the quicksort algorithm.

Null itself is not the problem. Having an empty value in your domain is not a disaster and may be a clear representation of your business example. What is wrong is how you're allowed to dangerously access this reference without a proper null check. That is totally unsafe and has been the cause of so many developers' tears and pain.

Following Tony Hoare here, *A programming language designer should be responsible for the mistakes made by programmers using the language. It is a serious activity; not one that should be given to programmers with 9 months experience with assembly; they should have a strong scientific basis, a good deal of ingenuity and invention and control of detail, and a clear objective that the programs written by people using the language would be correct. free of obvious errors and free of syntactical traps.*

Designing programs is hard. Designing languages that make you able to write these programs in a safe way is harder.

Optionals have already been providing a hand in dealing with the null references, by having a representation for an absence of value: `Optional.EMPTY`. Kotlin aims to be null-safe by design. It allows explicit nullable types by adding `?` at the end of type declaration, and only safe calls to these references by typing: `?.`. If you insist, it allows some explicit `!!` referencing which could still throw a NPE, but that's on you.

This post does not teach you how to avoid NPEs altogether, it focuses on the moment that it happens. Java has a strong focus, perhaps more than any other language, on backward compatibility. It would hardly risk a system written in an older version of Java to not work on the latest version. I wouldn't bet on Java to lose that focus anytime soon. So null references are here to stay. How can we make our lives easier with them?

## Where we stand

You hate it. No matter how much experience you have under your belt, you always fail to the same mistake. It's like that bad dream that keeps repeating. NullPointerException is the monster.

Even though Java has included Optionals as a language feature, and they've taken a lot of ground, you still haven't seen the last of this monster.

Actually, we are about to see one right now.

```java
String notANullReference = "hi there";
String aNullReference = null;

printLength.accept(notANullReference);
printLength.accept(aNullReference);

private static Consumer<String> printLength = input ->
    System.out.println("Length of string %s is %d".formatted(input, input.length()));
```

It does not take long to understand that a call to `.length()` on the null reference will throw a NPE.

Running this code will output the following info in the stacktrace:

```java
Exception in thread "main" java.lang.NullPointerException
    at com.albi.helpful.npe.App.lambda$static$0(App.java:21)
    at com.albi.helpful.npe.App.main(App.java:12)
```

It states there is a NPE in our App class and it lets us know about the line that it threw the error in what method. Beyond that, understanding the cause of this message is poor.

I am not saying that is entirely the opposite of helpful, but it could have said something more.

## Java 14 saves the day

Make a wish for a new Java feature and there will be a JEP for it, most probably with a touch of Brian Goetz on it.

Our hero has a number and a name: JEP [358](https://openjdk.java.net/jeps/358){:target="_blank"}: Helpful NullPointerExceptions.

This is one of the goodies that landed with JDK 14 earlier in March this year.

To make a case why we might need it, let's add another reference to the equation and do something extra with it.

```java
String anotherNotNullReference = "hello nulls";

Stream.of(notANullReference,
        aNullReference,
        anotherNotNullReference)
        .forEach(printLength);
```

What we got is a third reference, which is not null in this case, and a stream of these String references. We want to find the combined length of these Strings.

As we know, because of our null reference, this program is set for failure.

```java
Exception in thread "main" java.lang.NullPointerException
    at com.albi.helpful.npe.App.lambda$static$0(App.java:21)
    at java.base/java.util.Spliterators$ArraySpliterator.forEachRemaining(Spliterators.java:948)
    at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:658)
    at com.albi.helpful.npe.App.main(App.java:17)
```

This message is telling us in which method and line the incident happened.

Looking more carefully, besides following the flow of the iterations and debugging, which could get complex in a short time, we do not know which one of the references in the stream caused it.

That is not so.. *helpful*.

![dark-npe](/assets/images/dark_npe.jpg)

Getting close to the point, you could make use of what this JEP has in store do explore an alternate universe where NPEs are helpful.

Running the same program with a special flag: `-XX:+ShowCodeDetailsInExceptionMessages` would shed some light on this investigation.

```java
Exception in thread "main" java.lang.NullPointerException:
  Cannot invoke "String.length()" because "input" is null
    at com.albi.helpful.npe.App.lambda$static$0(App.java:21)
    at java.base/java.util.Spliterators$ArraySpliterator.forEachRemaining(Spliterators.java:948)
    at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:658)
    at com.albi.helpful.npe.App.main(App.java:17)
```

It is there. This indeed helpful message makes it loud that `input` argument is null, therefore the JVM cannot call `String.lenth()` on it. A real eye-opener.

Making it so easy, the developers can focus on actually fixing the NPE, rather than starting a quest to find the reference that caused it. In most cases, this feature will serve it for us. Going back to the statement from Hoare, the Java language designers take it seriously to offer the best programming experience to developers, if not for reversing decisions of the past which could not be abandoned due to the backward-compatibility promise, instead offering a bag of improvements such as this one.

Only writing this article I did learn that this feature has become a default on JDK 15, and you don't need the `-XX:+ShowCodeDetailsInExceptionMessages` flag anymore. As a matter of fact, Java is moving so fast even someone like me, who is a usual twitter citizen, missed the news.

<blockquote class="twitter-tweet" data-dnt="true" data-theme="dark"><p lang="en" dir="ltr">Helpful NullPointerException (JEP 358) will be set by default in JDK 15.<a href="https://t.co/r8wdTvq59X">https://t.co/r8wdTvq59X</a><a href="https://t.co/kmYk5enRUj">https://t.co/kmYk5enRUj</a> <a href="https://t.co/5lV8DymKpJ">pic.twitter.com/5lV8DymKpJ</a></p>&mdash; David Delabassée (@delabassee) <a href="https://twitter.com/delabassee/status/1276024020392128514?ref_src=twsrc%5Etfw">June 25, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

P.S. Source Code on [Github](https://github.com/albihasani94/helpful-NPE){:target="_blank"}
