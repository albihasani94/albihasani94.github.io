---
layout: post
title:  "Static Factory Collection Methods"
date:   2019-10-23
permalink: /static-factory-collection-methods
categories: [java9, collections]
tags: [java9, collections]
excerpt_separator: <!--more-->
---

In this post, I have written about some of the improvements to the collections with Java 9. I think it should be enough to get a Java Developer started with some nice features before talking about the elephant in the room: Modularity.

<!--more-->

It seems ages since Java 9 was released because Oracle and the Community have been delivering one major version of Java on a six-month schedule. 

There couldn't be a better time to step in the future of Java and save Java 8 from the risk of becoming our "Windows XP" in the not-so-far future. There is no reason not to as Java versions have often taken a strong stance towards backward-compatibility while delivering rock-solid enhancements.

These improvements have been covered by others, most masterfully from the likes of Sander Mak, Nicolai Parlog, and Miro Cupak. This post is going to be my take on it.

## List.of(), Set.of(), and a little taste of Map.of()

This feature is part of [JEP 269](https://openjdk.java.net/jeps/269){:target="_blank"}: Convenience Factory Methods for Collections.

I am going to single out its goal:

> Provide static factory methods on the collection interfaces that will create compact, unmodifiable collection instances.

This goal is concise and we would need to see how we dealt with collection creation in prior versions of Java to better understand the simplicity aimed for.

If you are more interested in the JEP process, you can read this short explanatory [post]({% post_url 2019-10-28-as-a-matter-of-jep %}).

### The Ceremony

```java
List<String> animals = new ArrayList<>();
animals.add("Dog");
animals.add("Lemur");
animals.add("Duck");
System.out.println(animals);
// [Dog, Lemur, Duck]
```

This is classic Java you have learned in school. Create a list of Strings. Add the items one by one. Drum roll. Credits.

It would be perfect in a reality where developers are paid for lines of code. (@cc me in a confrontation with your boss if your company practices this). For this post, I am just moving on to alternatives to the approach above.

### The Post-Ceremony

```java
Set<String> animals = new HashSet<>(Arrays.asList("Dog", "Lemur", "Duck"));
System.out.println(animals);
// [Duck, Dog, Lemur]
```

Now, this is what evolution does for you. People got lazy writing all that ceremony and decided there is a shorter way of doing it. The problem with this approach is that a method outside the Set or List interface needs to be called. That method resides in the Arrays class. Added to that, you have to create a List before getting a result of the Set.

### The Hack

{% highlight java %}
{% raw %}
Set<String> animals = new HashSet<>(){{add("Dog"); add("Lemur"); add("Duck");}};
System.out.println(animals);
// [Duck, Dog, Lemur]
{% endraw %}
{% endhighlight %}

Don't try this at home! This is what a Java geek would come up with. It makes me laugh, yet it works. This instantiation makes use of the instance-initializer construct of an anonymous inner class.

On the top, we have been clever enough to write this genius code.

Under the covers, we have created an instance of a class which extends HashSet in the outer braces, then we provided an instance initialization block in the inner braces.

This is considered an anti-pattern according to [some](https://blog.jooq.org/2014/12/08/dont-be-clever-the-double-curly-braces-anti-pattern/){:target="_blank"}, including myself. The instance initialized using this code will hold a hidden reference to the surrounding class, making memory leaks more likely.

### Java 9 to the Rescue!

```java
List<String> animals = List.of("Dog", "Lemur", "Duck");
System.out.println(animals);
// [Dog, Lemur, Duck]
```

Not only this works, but it is also simple for the user of the language. That's clean, concise, and it just does what it is implying. A list of these types will be created. No ceremony. Everyone who expected a great party should go home.

What's the catch? Let's just add another animal to the list.

```java
animals.add("Elephant");
|  Exception java.lang.UnsupportedOperationException
|        at ImmutableCollections.uoe (ImmutableCollections.java:71)
|        at ImmutableCollections$AbstractImmutableCollection.add (ImmutableCollections.java:75)
|        at (#12:1)
```

That must be quite a big elephant so that it couldn't fit in our list. The returned list, as we will see, is not a simple ArrayList.

```java
System.out.println(animals.getClass());
// class java.util.ImmutableCollections$ListN
```

These factory methods are designed for small, fixed-size collections. The reason we got the exception in the first place is that these static factory methods return immutable collections. An immutable collection, as an immutable object, is an object whose state cannot be changed after it is constructed.

### The benefits

- They are thread-safe after construction
- Because they don't need to support mutation, they can consume much less memory than mutable counterparts
- A go-to choice for collections that are initialized from known values and that never change

### The API

#### List.of

With Java 9, the most convenient way to create immutable lists is through this factory method.
What's more interesting lies under the API for this method.

Let's try a couple of use cases with this method. For these scenarios, I'm going to run the jshell [tool](https://docs.oracle.com/javase/9/jshell/introduction-jshell.htm){:target="_blank"} which came with Java 9.

```shell
jshell> List<Integer> singleElementList = List.of(1);
singleElementList ==> [1]

jshell> singleElementList.getClass()
$2 ==> class java.util.ImmutableCollections$List12

jshell> List<Integer> twoElementsList = List.of(1, 2);
twoElementsList ==> [1, 2]

jshell> twoElementsList.getClass()
$4 ==> class java.util.ImmutableCollections$List12
```

Nothing weird to notice yet. Let's try another one.

```shell
jshell> List<Integer> mustBeABiggerList = List.of(1, 2, 3);
mustBeABiggerList ==> [1, 2, 3]

jshell> mustBeABiggerList.getClass()
$6 ==> class java.util.ImmutableCollections$ListN
```

What happened? Changing the number of elements a list would contain resulted in a different kind of list type. From `ImmutableCollections$List12` for the two first objects and `ImmutableCollections$ListN` for the third object.

The reason for this change is that the writers of this API have intended to improve the performance of collections when their number is known.

Digging a little on this API, you would find not only 2, but 12 implementations of the `List.of` method. That's right!

```java
<E> List<E> of();
<E> List<E> of(E1);
<E> List<E> of(E1, E2);
<E> List<E> of(E1, E2, E3);
<E> List<E> of(E1, E2, E3, E4);
<E> List<E> of(E1, E2, E3, E4, E5);
<E> List<E> of(E1, E2, E3, E4, E5, E6);
<E> List<E> of(E1, E2, E3, E4, E5, E6, E7);
<E> List<E> of(E1, E2, E3, E4, E5, E6, E7, E8);
<E> List<E> of(E1, E2, E3, E4, E5, E6, E7, E8, E9);
<E> List<E> of(E1, E2, E3, E4, E5, E6, E7, E8, E9, E10);
<E> List<E> of(E... elements);
```

What's the fuss all about? For each number of elements up to 10, the API provides a specific option to the developer. These options have private implementations hidden behind the `of` method and they return more space-efficient collections than their mutable counterparts.

- The empty arguments `List.of()` would return an empty list
- The implementations with one `List.of(E1)` or two `List.of(E1, E2)` elements such as would return an instance of `ImmutableCollections.List12`
- The other implementations `List.of(E1, E2.. E10)` would return an instance of `ImmutableCollections.ListN`

The `List.of(E... elements)` serves as a last resort; it takes several arguments in the form of varargs and would be used in any other case. The reason this option is saved for the last is that it is less efficient. A vararg is implemented in Java as an array passed to the method. Therefore, the instantiation and garbage collection of an array would be performance costly compared to the overloaded methods with a fixed-size number of arguments.

```java
static <E> List<E> of(E... elements) {
        switch (elements.length) { // implicit null check of elements
            case 0:
                return ImmutableCollections.emptyList();
            case 1:
                return new ImmutableCollections.List12<>(elements[0]);
            case 2:
                return new ImmutableCollections.List12<>(elements[0], elements[1]);
            default:
                return new ImmutableCollections.ListN<>(elements);
        }
    }
```

The devil is in the details!

#### Set.of

Pretty much the same as the API for `List.of`.
The only change is that the data structure worked on is Set.
Unlike a list, a set is an unordered collection and does not allow duplicates.

The API would become streamlined as:

```java
Set.of();
Set.of(E1);
Set.of(E1, E2);
Set.of(E1, E2.. E10);
Set.of(E... elements);
```

Subsequent calls of `Set.of()` on a sequence of elements would return a Set  with a different iteration order each time.

The same benefits and caveats that apply to immutable lists apply to the immutable sets created through this factory method.

#### Map.of

Similarly, the Map interface provides a static factory method to create immutable maps.

```shell
jshell> Map<String, Integer> wordToNumber = Map.of("one", 1, "two", 2, "three", 3);
wordToNumber ==> {two=2, one=1, three=3}

jshell> wordToNumber.getClass()
$2 ==> class java.util.ImmutableCollections$MapN
```

The analogous API of Map would be

```java
Map.of();
Map.of(K1, V1);
Map.of(K1, V1, K2, V2);
Map.of(K1, V1, K2, V2.. K10, V10);
Map.ofEntries(Entry(K1, V1)... entries);
```

### Caveats to be aware of

- An attempt to modify the collection would result in an `UnsupportedOperationException`
- However, if the objects the collection holds are mutable the collection is not effectively immutable, e.g. `List<List<String>> effectivelyMutable;`.

## Conclusion

We just took a look at the new factory methods that came with the improved Collections API in Java 9. These methods have provided a convenient way to create immutable lists and sets.

As a writer of this article, I am impressed with the effort that goes into maintaining and growing the Java language. The JEPs are a good starting point to follow along with the birth of new features in years to come.

I hope to have achieved your understanding of these methods. There is a big noise out there, I would like to be part of a signal.

You can find all the code of this article as jshell interpretable commands [here](https://gist.github.com/albihasani94/2448fed86f1df71fbfdddc2d0b0b4138){:target="_blank"}.

*P.S. Don't support me*
