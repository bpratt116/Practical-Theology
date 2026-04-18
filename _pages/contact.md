---
title: "Contact"
permalink: /contact/
layout: single
author_profile: true
---

Send me a note — I read every message.

<!--
  Formspree contact form.
  After creating your form at https://formspree.io,
  replace YOUR_FORM_ID below with the ID Formspree gives you.
-->
<form action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
  <label for="contact-name">Name</label>
  <input type="text" name="name" id="contact-name" required />

  <label for="contact-email">Email</label>
  <input type="email" name="email" id="contact-email" required />

  <label for="contact-message">Message</label>
  <textarea name="message" id="contact-message" rows="6" required></textarea>

  <button type="submit">Send</button>
</form>
