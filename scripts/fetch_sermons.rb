#!/usr/bin/env ruby
# Fetches the YouTube RSS feed (no API key) and writes _data/sermons.json.
# Config lives in _config.yml under `sermons:` (channel_id or playlist_id, optional title_filter).
require "net/http"
require "rexml/document"
require "json"
require "yaml"

root = File.expand_path("..", __dir__)
cfg = (YAML.load_file(File.join(root, "_config.yml")) || {})["sermons"] || {}
id_param = cfg["playlist_id"].to_s.empty? ? "channel_id=#{cfg['channel_id']}" : "playlist_id=#{cfg['playlist_id']}"
url = URI("https://www.youtube.com/feeds/videos.xml?#{id_param}")
out = File.join(root, "_data", "sermons.json")

begin
  res = Net::HTTP.get_response(url)
  raise "HTTP #{res.code}" unless res.is_a?(Net::HTTPSuccess)
  doc = REXML::Document.new(res.body)
  filter = cfg["title_filter"].to_s.empty? ? nil : Regexp.new(cfg["title_filter"], Regexp::IGNORECASE)
  videos = []
  doc.elements.each("feed/entry") do |e|
    title = e.elements["title"].text.to_s.gsub(/\s+/, " ").strip
    next if filter && title !~ filter
    vid = e.elements["yt:videoId"].text
    desc = e.elements["media:group/media:description"]&.text.to_s.strip
    videos << {
      "id" => vid, "title" => title,
      "published" => e.elements["published"].text,
      "url" => "https://www.youtube.com/watch?v=#{vid}",
      "thumbnail" => "https://i.ytimg.com/vi/#{vid}/hqdefault.jpg",
      "description" => desc[0, 280]
    }
  end
  raise "feed returned no videos" if videos.empty?
  File.write(out, JSON.pretty_generate(videos) + "\n")
  puts "Wrote #{videos.size} sermons to #{out}"
rescue => e
  # Never break the site build: keep the last committed data file.
  warn "fetch_sermons: #{e.message}; keeping existing #{out}"
end
