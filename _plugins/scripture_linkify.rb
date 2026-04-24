# Auto-link Scripture references in post content.
#
# Runs AFTER Kramdown has turned markdown into HTML, so we can
# safely skip content inside <code>, <pre>, and existing <a> tags
# rather than hoping kramdown passes our anchors through untouched.

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

    # Book alternation. "Song of Solomon" has a literal space, so we
    # write the regex without /x mode to avoid Ruby stripping spaces
    # from the interpolated alternation.
    BOOK_ALT = BOOKS.join("|")
    REF_PATTERN = /(?<prefix>(?:\b[123]|\bI{1,3})\s)?(?<book>#{BOOK_ALT})\s+(?<chapter>\d+):(?<verse>\d+(?:[-–]\d+)?(?:,\s*\d+(?:[-–]\d+)?)*)/

    # Split the HTML into safe and unsafe regions. Never linkify inside
    # <a>, <code>, or <pre> blocks.
    SPLITTER = %r{(<a\b[^>]*>.*?</a>|<code\b[^>]*>.*?</code>|<pre\b[^>]*>.*?</pre>)}m

    def self.link(ref)
      search = ref.gsub(/\s+/, " ").strip.gsub(" ", "+")
      text = ref.gsub(/\s+/, " ").strip
      %(<a href="https://www.biblegateway.com/passage/?search=#{search}&amp;version=ESV" class="scripture-ref" target="_blank" rel="noopener">#{text}</a>)
    end

    def self.linkify_text(chunk)
      chunk.gsub(REF_PATTERN) do
        m = Regexp.last_match
        ref = "#{m[:prefix]}#{m[:book]} #{m[:chapter]}:#{m[:verse]}"
        link(ref)
      end
    end

    def self.apply(html)
      return html if html.nil?
      parts = html.split(SPLITTER)
      # Odd indices are skipped regions; even indices are safe to process.
      parts.each_with_index.map { |p, i| i.even? ? linkify_text(p) : p }.join
    end
  end
end

Jekyll::Hooks.register :posts, :post_render do |post|
  before = post.output.to_s.scan(/class="scripture-ref"/).length
  post.output = PT::ScriptureLinkify.apply(post.output)
  after = post.output.to_s.scan(/class="scripture-ref"/).length
  Jekyll.logger.info "ScriptureLinkify:", "#{post.relative_path} -> added #{after - before} link(s)"
end
