---
title: "Sermons"
permalink: /sermons/
layout: single
author_profile: true
excerpt: "Recent LifePoint messages are full worship-service livestreams. Older messages come from YouTube."
---

Recent sermons and teaching. Older messages refresh automatically from my [YouTube channel]({{ site.sermons.channel_url }}); recent LifePoint Church messages link to the full worship-service livestream.

{% include sermons-merged.html %}{% assign sermons = sermons_merged %}
{% if sermons and sermons.size > 0 %}
<div class="sermon-grid" markdown="0">
  {% for s in sermons %}{% include sermon-card.html sermon=s heading="h2" %}{% endfor %}
</div>
{% else %}
<p>Sermons are unavailable right now. Visit the <a href="{{ site.sermons.channel_url }}">YouTube channel</a>.</p>
{% endif %}

<p class="sermon-more"><a class="btn btn--primary" href="{{ site.sermons.channel_url }}?sub_confirmation=1" target="_blank" rel="noopener"><i class="fab fa-youtube" aria-hidden="true"></i> Subscribe on YouTube</a></p>
