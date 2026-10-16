## Welcome to my blog! 

### Helpful links for authoring
* [Example posts](https://github.com/mmistakes/minimal-mistakes/tree/master/docs/_posts)
* [Theme docs](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)
* [Markdown editor](https://stackedit.io/)
* [Markdown cheat sheet](https://www.markdownguide.org/cheat-sheet/)
* [Unsplash](https://unsplash.com/)

## Sermons page

`/sermons/` merges two sources (see `_includes/sermons-merged.html`), newest first, de-duplicated by YouTube ID:

1. **@bpratt116 YouTube channel**: fetched automatically from the RSS feed by `scripts/fetch_sermons.rb` (configured under `sermons:` in `_config.yml`). The Pages workflow runs it before every build and on a daily schedule.
2. **Curated list**: `_data/sermons_curated.yml`, for messages on other channels (e.g. LifePoint livestreams).

### Adding a new sermon
Add an entry to the top of `_data/sermons_curated.yml` and commit:

```yaml
- date: "2026-10-18"         # keep quoted
  title: "Sermon Title"
  passage: "Phil 2:19-30"
  youtube_id: "XXXXXXXXXXX"   # the part after watch?v=
  start: 1680                 # optional: seconds where the sermon starts (adds &t=1680s)
  source: "LifePoint Church livestream (full service)"
```

The thumbnail comes from YouTube automatically. The newest entry also becomes the home page's "Latest Sermon".
