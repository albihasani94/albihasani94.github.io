---
layout: post
title:  "Let there be var"
date:   2019-10-26
permalink: /draft-there
categories: [java10, var]
tags: [java10, var]
excerpt_separator: <!--more-->
---

If you are late to the game with var in Java you can discover its use cases and necessity in this article.

<!--more-->

*This is old news.*

I have heard this excerpt at a talk by Brian Goetz and you can't blame him. From the time var was introduced to the language, it was dreaded and loved, feared and embraced.. and the world with var is not that bad after all.

## The birth of var

To understand the roots of this feature, one ought to have to have heard about *Project Amber.* This nice gem-y name project is all about introducing new language features to keep Java modern and more attractive to developers. *(Java you have always been good, it's just that these improvements will do no bad either).*

Local-Variable type inference is part of this project.

Did this invention happen in Java? Not by a long shot. Javascript has had var *TODO*

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

*But* still from a developer perspective is not as much fun to write.

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
