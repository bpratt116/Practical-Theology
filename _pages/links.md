---
title: "Links"
permalink: /links/
layout: single
author_profile: false
sitemap: false
---

<style>
  .bp-links{list-style:none;margin:1.5rem 0;padding:0;display:grid;gap:.75rem}
  .bp-links a{display:block;padding:1rem 1.1rem;border:1px solid rgba(0,0,0,.12);border-radius:10px;text-decoration:none;color:inherit}
  .bp-links a strong{display:block;font-size:1.05em}
  .bp-links a span{font-size:.85em;opacity:.75}
  .bp-links .featured a{border-width:2px;border-color:currentColor}
  .bp-links-bio{text-align:center}
  .bp-links-bio img{width:88px;height:88px;border-radius:50%;object-fit:cover}
</style>

<div class="bp-links-bio">
  <img src="{{ '/assets/profile.jpg' | relative_url }}" alt="Brendan Pratt">
  <p>Pastor &amp; app maker. Practical theology, prayer, and apps for faith and family.</p>
</div>

<ul class="bp-links">
  <li class="featured"><a data-track href="https://apps.apple.com/us/app/pilgrim-prayer-list/id6813986018"><strong>Prayer List</strong><span>Keep the people you pray for close</span></a></li>
  <!-- TODO: Chrona App Store ID not known (Everlight repo has placeholder idXXXXXXXXXX). Using product page until real URL exists. -->
  <li><a data-track href="https://everlight-digital.com/apps/chrona.html"><strong>Chrona</strong><span>Make the most of your time</span></a></li>
  <li><a data-track href="https://apps.apple.com/us/app/olive-household-rhythms/id6762567367"><strong>Olive</strong><span>A calm home for your family's week</span></a></li>
  <li><a data-track href="https://apps.apple.com/us/app/regen-athlete/id6764216927"><strong>Regen</strong><span>Recovery insights for athletes</span></a></li>
  <li><a data-track href="https://apps.apple.com/us/app/pilgrim-bible-prayer/id6769929244"><strong>Pilgrim</strong><span>Bible &amp; prayer, without the guilt</span></a></li>
  <li><a data-track href="https://www.pastorshepherd.com"><strong>Shepherd</strong><span>Pastoral care software for churches</span></a></li>
</ul>

<div class="home-cta" id="signup">
  <h2>Get updates</h2>
  <p>New posts and app news. No spam.</p>
  <!-- TODO(Resend): no backend yet. Wire to a Resend audience (brendanpratt.org is NOT yet a Resend domain; add + verify it first).
       CAN-SPAM: every email sent must include a working unsubscribe link and a valid physical postal address. -->
  <form onsubmit="event.preventDefault();this.querySelector('[type=submit]').value='Coming soon';">
    <input type="email" placeholder="you@example.com" required aria-label="Email address" />
    <input type="submit" value="Notify me" />
  </form>
</div>

<script>
(function(){
  var src=(new URLSearchParams(location.search).get('src')||'').toLowerCase();
  if(src!=='x'&&src!=='threads')src='direct';
  var CAMPAIGN='linkinbio';
  var APPLE_PT=null; // TODO: Apple provider token (pt=) unknown; set when known.
  document.querySelectorAll('a[data-track]').forEach(function(a){
    var u=new URL(a.getAttribute('href'),location.href);
    if(u.hostname==='apps.apple.com'){
      u.searchParams.set('ct',CAMPAIGN+'-'+src);
      if(APPLE_PT)u.searchParams.set('pt',APPLE_PT);
    }else{
      u.searchParams.set('utm_source',src);
      u.searchParams.set('utm_medium','social');
      u.searchParams.set('utm_campaign',CAMPAIGN);
    }
    a.href=u.toString();
  });
})();
</script>
