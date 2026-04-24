---
title: "Archive"
permalink: /archive/
layout: single
author_profile: true
---

Every post, grouped by year.

{% assign by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
{% for year in by_year %}
  <h2 id="y-{{ year.name }}">{{ year.name }}</h2>
  <ul class="archive-year">
    {% for post in year.items %}
      <li>
        <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d" }}</time>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  </ul>
{% endfor %}
