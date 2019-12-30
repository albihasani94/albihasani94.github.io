---
layout: post
title: "Coming Clean on Records"
date: 2019-12-30
permalink: coming-clean-on-records.html
categories: [java14, records]
tags: [java, records]
description: "Java will have records, and it will have them soon! Yayy! Now, what does that mean and how on earth did we need these?"
image: assets/images/java-records.jpg
excerpt_separator: <!--more-->
---

Java will have records, and it will have them soon! Yayy! Now, what does that mean and how on earth did we need these?

<!--more-->

## Person Begins

Let's say you want to have objects of a Person type compounded by a person's name and age. We love objects! We would immediately rush over to the favorite IDE, write the fields and let the ide generate a bunch of other stuff for us. The result is more or less the same as I got.

```java
package play.with.records;

public class Person {

    private String name;
    private int age;

    // no-arg constructor
    // arg constructor
    // getters and setters

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        Person person = (Person) o;
        return age == person.age &&
                Objects.equals(name, person.name);
    }

    @Override
    public int hashCode() {
        int result = name.hashCode();
        result = 31 * result + age;
        return result;
    }

    @Override
    public String toString() {
        return "Person{name='" + name + ", age=" + age + '}';
    }
}

```

That's a whopping 56 lines of code, for just an object with only two properties. That stuff makes you not want to sleep at night. Scary.

In order to keep the semantics consistent, I have created an object of this type and fed it to the consumer.

```java
// Person class in any java version
Person first = new Person("Albi", 25);

Consumer<Person> c1 = System.out::println;
c1.accept(first);
```

The result I got is pretty straightforward:

```bash
Person{name='Albi, age=25}
```

Now, is there anything on earth you can do about all that *overhead* and what is more important, make this type more reader friendly?

## The Dark Pair

I have often come across the necessity of a structure that is a bit broader than a single element, but more lightweight than a full-fledged class. My colleague at the time was a Python developer and he was scratching his head and coming to me *"Why cannot Java have Tuples? It makes life easier. We have them in Python."*

To my surprise, there is something that provides this functionality in Java(almost) called Pair.

It has a constructor as follows:

```java
Pair​(K key, V value)
```

With this class, you can create Pairs with keys on one type and values of another type.

I am going to test my code using this construct.

```java
// Pair JavaFX prior to java 11
Pair<String, Integer> nameAgePair = new Pair<>("Albi", 25);

Consumer<Pair> c2 = System.out::println;
c2.accept(nameAgePair);
// Albi=25
```

Up to this point, we have decided to live in a utopia and use Pair just as we use any Java type any other day. What's the drawback about this is that Pair lives in a world of its own, the JavaFX [package](https://docs.oracle.com/javase/8/javafx/api/javafx/util/Pair.html). And with the removal of the JavaFX module from JDK 11, that is far from an ideal solution.

## The Record Rises

> Enhance the Java programming language with records. Records provide a compact syntax for declaring classes which are transparent holders for shallowly immutable data.

You could think of them as data stores. You want to store data, and you want it now. Records are for you then.

By writing records, you immediately take care of the need for the likes of constructors, getters and setters, equals(), and hashCode().

```java
record PersonRecord (String name, int age){
}

PersonRecord person = new PersonRecord("Albi", 25);

Consumer<PersonRecord> c3 = System.out::println;
c3.accept(person);
// PersonRecord[name=Albi, age=25]
```

## Records are classes

They can have almost all the things classes can have.

### Methods

As we have slightly demonstrated, records immediately get you equals, hashCode and toString for free, but you can add more as you like.

```java
record PersonRecord (String name,int age){
    boolean isWise () {
        return age > 80;
    }
}

PersonRecord person = new PersonRecord("Albi", 25);
PersonRecord wisePerson = new PersonRecord("Clint Eastwood", 95);

System.out.printf("Is %s wise? %s%n", person.name, person.isWise() ? "yes" : "no");
// Is Albi wise? no
System.out.printf("Is %s wise? %s%n", wisePerson.name, wisePerson.isWise() ? "yes" : "no");
// Is Clint Eastwood wise? yes
```

### Constructors

Let's say we needed a finer control over the definition of the record. We can add the good ol' boy, the constructor.

```java
record PersonRecord (String name,int age){
    public PersonRecord(String name, int age){
        if (age > 120) {
            throw new IllegalArgumentException("Sorry, age(%d) is too high".formatted(age));
        }
        this.name = name;
        this.age = age;
    }
}

try {
    PersonRecord reallyTooOldWoman = new PersonRecord("Victoria", 135);
    c3.accept(reallyTooOldWoman);
} catch (IllegalArgumentException e) {
    LOGGER.log(Level.INFO, "Exception caught: {0}", e.getMessage());
}
```

The output in my console says:

```bash
Dec 30, 2019 8:27:07 PM play.with.records.Main main
INFO: Exception caught: Sorry, age(135) is too high
```

What you can slightly dislike about this code is that it adds some of the boilerplate we removed in the first place. Lucky for you and me, there is another alternative to declaring this constructor in a record.

```java
record PersonRecord (String name,int age){
    public PersonRecord {
        if (age > 120) {
            throw new IllegalArgumentException("Sorry, age(%d) is too high".formatted(age));
        }
    }
}
```

Checking the output.

```bash
Dec 30, 2019 8:45:24 PM play.with.records.Main main
INFO: Exception caught: Sorry, age(135) is too high
```

Neat!

The constructor asks only for what's explicit, and it fills in the implicit stuff automatically. Sorry, Zen of Python, *Implicit is better than explicit.* (in this case)

## Real-Life Scenarios

Say you want to take a List and return both its minimum and maximum element at once. You are right when you say you are lazy to write a big class just for these two values.

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 10, 9, 8, 7, 6, 5);
```

You really **don't** want to write a heavyweight class. The answer is in records.

```java
record MinMax<T>(T min, T max){
}

MinMax minMaxOfNumbers = new MinMax(numbers.stream().mapToInt(x->x).min().getAsInt(), numbers.stream().mapToInt(x->x).max().getAsInt());
System.out.println("Min and max of numbers: " + minMaxOfNumbers);
// MinMax[min=1, max=10]
```

Notice that we wrote a generic type of MinMax. Let's add some people to the mix.

```java
List<PersonRecord> personRecords = List.of(person, wisePerson, new PersonRecord("Toddler", 4));

MinMax minMaxOfPersonsByAge = new MinMax(personRecords.stream().min(Comparator.comparing(PersonRecord::age)).get(),
    personRecords.stream().max(Comparator.comparing(PersonRecord::age)).get());
System.out.println("Min and max of persons by age: " + minMaxOfPersonsByAge);
// MinMax[min=PersonRecord[name=Toddler, age=4], max=PersonRecord[name=Clint Eastwood, age=95]]
```

The clear advantage we have in our hands compared to doing this with a Pair-like structure is that we have this variable named. And in this case, *MinMax* tells us almost all there is about this pair. To quote(ahem), the [Zen of Python](https://www.python.org/dev/peps/pep-0020/#id3){:target="_blank"}, "Explicit is better than implicit."

## Source code and Commands

The demos I have illustrated in this post are on [Github](https://github.com/albihasani94/play.with.records){:target="_blank"}.

You would need to add the `--enable-preview` flag to enable the usage of records. They are a preview feature as of Java 14.

The IDE support for records is almost inexistent until now, and I've coded my way through a lot of red underlines and warnings.

```bash
javac --enable-preview --release 14 --module-path mods -d classes \
--module-source-path src $(find src -name "*.java")

jar --create --file=mods/play.with.records.jar \
--main-class=play.with.records.Main -C classes/play.with.records .

java --enable-preview --module-path mods --module play.with.records
```

## To Sum Up

Records are very convenient data stores in Java. They are ideal for DTOs and classes without much business logic, just the data. They remove the need for IDE generated boilerplate and make reading code more appealing than reading classes for the use case that we have demonstrated. It's nice to know that even if you want to add some computation methods into the record, you can just do it. You can also add a lightweight constructor into them, which is syntactic sugar, but still very nice.

## P.S.

Dear reader, please don’t be this guy.

![records-denis](/assets/images/records-denis.png)

Yeah, C# had it first, Kotlin is in the future. Yes. If you want to use C#, use C#. If you want to use Kotlin, use Kotlin. Just because something works for you and your team doesn’t mean something else won’t work for someone else.

That’s the joy of programming. The possibilities are endless to make something right. You get to choose, just choose wisely.
