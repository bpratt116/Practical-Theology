# Auto-link Scripture references in post content.
#
# Turns strings like "2 Peter 1:3", "Ephesians 1:13-14", and
# "1 Corinthians 12:4-11" into links to BibleGateway (ESV).
# Runs before kramdown so it only matches in body text, not front matter.

module PT
  module ScriptureLinkify
    BOOKS = [
      "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
      "Joshua", "Judges", "Ruth", "Samuel", "Kings", "Chronicles",
      "Ezra", "Nehemiah", "Esther", "Job", "Psalms?", "Proverbs",
      "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah",
      "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos",
      "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah",
      "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke",
      "John", "Acts", "Romans", "Corinthians", "Galatians",
      "Ephesians", "Philippians", "Colossians", "Thessalonians",
      "Timothy", "Titus", "Philemon", "Hebrews", "James", "Peter",
      "Jude", "Revelation"
    ].freeze

    BOOK_PATTERN = "(?:#{BOOKS.join('|')})"
    # (1|2|3)? Book Chapter:Verse[-Verse][,Verse]
    REF_PATTERN = /
      (?<!href=["'])                       # skip if already inside an href
      (?<prefix>\b(?:1|2|3|I{1,3})\s)?     # optional book number
      (?<book>#{BOOK_PATTERN})             # book name
      \s+
      (?<chapter>\d+)                      # chapter
      :
      (?<verse>\d+(?:[-–]\d+)?        # verse or verse range
                 (?:,\s*\d+(?:[-–]\d+)?)*)  # plus optional extra verses
    /ix

    def self.apply(content)
      content.gsub(REF_PATTERN) do
        match = Regexp.last_match
        ref = [match[:prefix], match[:book], " ", match[:chapter], ":", match[:verse]]
                .compact.join.gsub(/\s+/, " ").strip
        search = ref.gsub(" ", "+")
        %(<a href="https://www.biblegateway.com/passage/?search=#{search}&version=ESV" class="scripture-ref" target="_blank" rel="noopener">#{ref}</a>)
      end
    end
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  post.content = PT::ScriptureLinkify.apply(post.content)
end
