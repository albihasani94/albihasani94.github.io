---
layout: post
title: "Making Space for Pattern Matching"
date: 2020-02-09
permalink: making-space-for-pattern-matching.html
categories: [java14, pattern matching]
tags: [java, pattern matching]
description: "As a Java Developer, the risk of getting used to ceremony is a serious thing. Some people are actively involved in putting this risk into sleep."
image: assets/images/no-and-then.jpg
excerpt_separator: <!--more-->
---

As a Java Developer, the risk of getting used to ceremony is a serious thing. Some people are actively involved in putting this risk into sleep.

<!--more-->

A common theme around Java is its verbosity. More than it takes more lines to model a behaviour, it takes more effort to read this model and translate it into the real-life process that we want to describe.

One of the cases where this becomes a hassle is the classic `instanceof` process.

Let's say we have a shape.

```java
public class Shape { }
```

And we have three descendants of this class.

```java
public class Circle extends Shape { }
public class Triangle extends Shape { }
public class Rectangle extends Shape { }
```

Let's put into each shape a distinctive method.

```java
public void sayIamACircle() {
    System.out.println("I am a circle");
}
public void sayIamATriangle() {
    System.out.println("I am a triangle");
}
public void sayIamARectangle() {
    System.out.println("I am a rectangle");
}
```

Then we go on to construct three instances of these shapes in our main method.

```java
Shape rectangle = new Rectangle();
Shape circle = new Circle();
Shape triangle = new Triangle();
```

Nothing interesting here.

## Speaking Shapes

```java
sayYourShape(triangle);

private static void sayYourShape(Shape shape) { }
```

### What we have to do

> Test if an object is a representative of a class

```java
private static void sayYourShape(Shape shape) {
    if (shape instanceof Triangle) {
    }
}
```

### And then?

> Cast the object into a reference of this class

```java
private static void sayYourShape(Shape shape) {
    if (shape instanceof Triangle) {
        Triangle triangle = (Triangle) shape;
    }
}
```

### And theen?

> Play with the new reference

```java
private static void sayYourShape(Shape shape) {
    if (shape instanceof Triangle) {
        Triangle triangle = (Triangle) shape;
        triangle.sayIamATriangle();
    }
}
```

### And theeen?

> No and then. No and theen.. No and theeen...

![No and then!](https://media.giphy.com/media/bzaEWi1Z1xzby/giphy.gif)

It is already too much to handle. You have the object, then you test if it is an instance of a class, then even with this information you have to cast the object into the exact reference you know this object is an instance of. This never made too much sense, or at least wasn't fun to write.

Other languages, and more recently C#, have added a pattern matching feature. This feature, built in the language, paves the way to cleaner control flow statements.

Let's go back to our speaking circles.

## Look who's speaking

```java
private static void sayYourShapeImproved(Shape shape) {
    if (shape instanceof Triangle triangle) {
        triangle.sayIamATriangle();
    }
}
```

The ceremony. Gone. Puff. Let that sink in for a moment.

This code is immediately improved and speaks for itself. It's more like a sentence, than magic.

### No and then

You test if shape is an instance of a particular shape, then directly assign this to that shape reference. You are free to use this variable that way you want it according to its reference.

This enables cleaner designs and saves some casting on the writer's side, and some processing on the reader's side.

## Supercharging Pattern Matching

Pattern matching, a specification of [JEP 305](http://openjdk.java.net/jeps/305){:target="_blank"}, is pretty impressive. It shows us the way to better control flow in if and switch statements. If you liked the apéritif, you sure gonna like the entrée.

This feature is complete with deconstruction patterns and records, which will provide built-in deconstructors, in conjunction with sealed types.

You will write similar code to this.

```java
sealed interface Shape permits Circle, Triangle, Rectangle { }
private record Triangle (int base, int height) implements Rectangle;

int area (Shape shape) {
    if (shape instanceof Triangle(int base, int height)) {
        return base*height/2;
    }
}
```

This could be a very likely Java code in the future, mixing sealed interfaces, records, and pattern matching.

## Source Code

Source code can be found on [Github](https://github.com/albihasani94/java9-plus/tree/master/src/main/java/com/jdk/java14/patternmatching){:target="_blank"}

## Conclusion

I decided to go with an experimental feature, and that doesn't mean what you have read here will totally disappear in a drawer. Some things might change, while the main course of action you have seen here will be likely the same when JDK 15 comes out, or these features make into the final release, hopefully the Java 17 LTS but that is only my assumption.

This construct will allow nicer hierarchy checks and the deconstruction patterns will eliminate much of the getter code in order to use the variables of an instance directly.
