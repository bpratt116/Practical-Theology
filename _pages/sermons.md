---
title: "Sermons"
permalink: /sermons/
layout: single
author_profile: true
excerpt: "Recent messages, straight from YouTube."
---

Recent sermons and teaching. This list refreshes automatically from my [YouTube channel]({{ site.sermons.channel_url }}).

{% assign sermons = site.data.sermons | sort: "published" | reverse %}
{% if sermons and sermons.size > 0 %}
<div class="sermon-grid" markdown="0">
  {% for s in sermons %}{% include sermon-card.html sermon=s %}{% endfor %}
</div>
{% else %}
<p>Sermons are loading — in the meantime, visit the <a href="{{ site.sermons.channel_url }}">YouTube channel</a>.</p>
{% endif %}

<p class="sermon-more"><a class="btn btn--primary" href="{{ site.sermons.channel_url }}?sub_confirmation=1" target="_blank" rel="noopener"><i class="fab fa-youtube" aria-hidden="true"></i> Subscribe on YouTube</a></p>
