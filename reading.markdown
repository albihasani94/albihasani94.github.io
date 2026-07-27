---
layout: page
title: Reading
permalink: /reading/
description: "Books Albin Hasani is currently reading and has finished, grouped by year from his Goodreads bookshelves."
---

Books I am currently reading and ones I have finished.

> Proudly built, tested and measured with Codex running `gpt-5.6-sol`.

<h2 class="reading-section-title">Currently Reading</h2>
{% if site.data.goodreads.currently_reading.size > 0 %}
<ul class="reading-list">
  {% for book in site.data.goodreads.currently_reading %}
    <li class="reading-book">
      <a class="reading-book-cover" href="{{ book.url }}">
        <img
          src="{{ book.cover }}"
          alt="Cover of {{ book.title | escape }} by {{ book.author | escape }}"
          loading="lazy"
        >
      </a>
      <div class="reading-book-details">
        <h3><a href="{{ book.url }}">{{ book.title | escape }}</a></h3>
        <p>by {{ book.author | escape }}</p>
        {% if book.pages %}
          <p class="reading-book-meta">{{ book.pages }} pages</p>
        {% endif %}
      </div>
    </li>
  {% endfor %}
</ul>
{% else %}
I don't have a book marked as currently reading.
{% endif %}

<h2 class="reading-section-title">Read by Year</h2>
{% for reading_year in site.data.goodreads.read_by_year %}
  <section class="reading-year">
    <div class="reading-year-heading">
      <h2>{{ reading_year.year }}</h2>
      <span class="reading-year-count">
        {{ reading_year.books.size }}
        {% if reading_year.books.size == 1 %}book{% else %}books{% endif %}
      </span>
    </div>
    <ul class="reading-history">
      {% for book in reading_year.books %}
        <li class="reading-history-book{% if site.show_reading_history_covers and book.cover %} reading-history-book-with-cover{% endif %}">
          {% if site.show_reading_history_covers and book.cover %}
            <a class="reading-history-cover" href="{{ book.url }}">
              <img
                src="{{ book.cover }}"
                alt="Cover of {{ book.title | escape }} by {{ book.author | escape }}"
                loading="lazy"
              >
            </a>
          {% endif %}
          <div>
            <a class="reading-history-title" href="{{ book.url }}">{{ book.title | escape }}</a>
            <span class="reading-history-author">by {{ book.author | escape }}</span>
          </div>
          <time datetime="{{ book.read_at }}">{{ book.read_at | date: "%b %-d" }}</time>
        </li>
      {% endfor %}
    </ul>
  </section>
{% endfor %}

{% if site.data.goodreads.undated_read.size > 0 %}
  <section class="reading-year">
    <div class="reading-year-heading">
      <h2>Date not recorded</h2>
      <span class="reading-year-count">
        {{ site.data.goodreads.undated_read.size }} books
      </span>
    </div>
    <ul class="reading-history">
      {% for book in site.data.goodreads.undated_read %}
        <li class="reading-history-book{% if site.show_reading_history_covers and book.cover %} reading-history-book-with-cover{% endif %}">
          {% if site.show_reading_history_covers and book.cover %}
            <a class="reading-history-cover" href="{{ book.url }}">
              <img
                src="{{ book.cover }}"
                alt="Cover of {{ book.title | escape }} by {{ book.author | escape }}"
                loading="lazy"
              >
            </a>
          {% endif %}
          <div>
            <a class="reading-history-title" href="{{ book.url }}">{{ book.title | escape }}</a>
            <span class="reading-history-author">by {{ book.author | escape }}</span>
          </div>
        </li>
      {% endfor %}
    </ul>
  </section>
{% endif %}
