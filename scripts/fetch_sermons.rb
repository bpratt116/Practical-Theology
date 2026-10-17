#!/usr/bin/env ruby
# Fetches the YouTube RSS feed (no API key) and merges it into _data/sermons.json.
# The feed only carries the newest 15 uploads. Older rows already in the file stay.
# Config lives in _config.yml under `sermons:` (channel_id or playlist_id, optional title_filter).
require "net/http"
require "rexml/document"
require "json"
require "yaml"

ID_RE = /\A[A-Za-z0-9_-]{11}\z/
DATE_RE = /\A\d{4}-\d{2}-\d{2}\z/

root = File.expand_path("..", __dir__)
cfg = (YAML.load_file(File.join(root, "_config.yml")) || {})["sermons"] || {}
id_param = cfg["playlist_id"].to_s.empty? ? "channel_id=#{cfg["channel_id"]}" : "playlist_id=#{cfg["playlist_id"]}"
url = URI("https://www.youtube.com/feeds/videos.xml?#{id_param}")
out = File.join(root, "_data", "sermons.json")

def load_existing(path)
  return [] unless File.exist?(path)
  parsed = JSON.parse(File.read(path))
  return [] unless parsed.is_a?(Array)
  parsed.select { |row| row.is_a?(Hash) && row["youtube_id"].to_s.match?(ID_RE) }
rescue JSON::ParserError
  warn "fetch_sermons: existing #{path} is not valid JSON; starting from the feed only"
  []
end

def fetch_feed(url)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.open_timeout = 10
  http.read_timeout = 20
  req = Net::HTTP::Get.new(url.request_uri)
  req["User-Agent"] = "PracticalTheology sermon archive"
  res = http.request(req)
  raise "HTTP #{res.code} for #{url}" unless res.is_a?(Net::HTTPSuccess)
  res.body
end

def keep_archive!(error, path)
  existing = load_existing(path)
  if existing.empty?
    warn "fetch_sermons: #{error.message}; no archive to keep"
    exit 1
  end
  warn "fetch_sermons: #{error.message}; keeping #{existing.size} sermons already in #{path}"
  exit 0
end

body = nil
begin
  body = fetch_feed(url)
rescue => e
  channel = cfg["channel_id"].to_s
  if cfg["playlist_id"].to_s.empty? && channel.start_with?("UC")
    fallback = URI("https://www.youtube.com/feeds/videos.xml?playlist_id=UU#{channel[2..]}")
    warn "fetch_sermons: #{e.message}; trying uploads playlist"
    begin
      body = fetch_feed(fallback)
    rescue => fallback_error
      keep_archive!(fallback_error, out)
    end
  else
    keep_archive!(e, out)
  end
end

doc = REXML::Document.new(body)
filter = cfg["title_filter"].to_s.empty? ? nil : Regexp.new(cfg["title_filter"], Regexp::IGNORECASE)
incoming = []
doc.elements.each("feed/entry") do |e|
  title = e.elements["title"]&.text.to_s.gsub(/\s+/, " ").strip
  next if title.empty?
  next if filter && title !~ filter
  vid = e.elements["yt:videoId"]&.text.to_s
  next unless vid.match?(ID_RE)
  published = e.elements["published"]&.text.to_s
  date = published[0, 10]
  next unless date.match?(DATE_RE)
  desc = e.elements["media:group/media:description"]&.text.to_s.strip
  incoming << {
    "id" => vid,
    "youtube_id" => vid,
    "title" => title,
    "date" => date,
    "published" => published,
    "url" => "https://www.youtube.com/watch?v=#{vid}",
    "thumbnail" => "https://i.ytimg.com/vi/#{vid}/hqdefault.jpg",
    "description" => desc[0, 280]
  }
end

raise "feed returned no usable videos" if incoming.empty?

by_id = {}
load_existing(out).each { |row| by_id[row["youtube_id"]] = row }
incoming.each { |row| by_id[row["youtube_id"]] = row }
merged = by_id.values.sort_by { |row| row["published"].to_s }.reverse
kept = load_existing(out).map { |row| row["youtube_id"] }
dropped = kept - merged.map { |row| row["youtube_id"] }
raise "refusing to drop known sermons: #{dropped.join(", ")}" unless dropped.empty?

File.write(out, JSON.pretty_generate(merged) + "\n")
puts "Wrote #{merged.size} sermons to #{out} (#{incoming.size} from the feed)"
