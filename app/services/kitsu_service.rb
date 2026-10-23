require 'net/http'
require 'json'

class KitsuService
  BASE_URL = "https://kitsu.io/api/edge"

  def self.upcoming_anime
    cached_data = Rails.cache.read("upcoming_anime_kitsu")
    return cached_data if cached_data.present?

    live_data = fetch_data("#{BASE_URL}/anime?filter[status]=upcoming&page[limit]=5&sort=startDate")
    
    if live_data.any?
      Rails.cache.write("upcoming_anime_kitsu", live_data, expires_in: 12.hours)
      return live_data
    else
      return fallback_data
    end
  end

  def self.top_airing_anime
    cached_data = Rails.cache.read("top_airing_kitsu")
    return cached_data if cached_data.present?

    # Fetch currently airing, sorted by highest rating
    live_data = fetch_data("#{BASE_URL}/anime?filter[status]=current&sort=-averageRating&page[limit]=5")

    if live_data.any?
      Rails.cache.write("top_airing_kitsu", live_data, expires_in: 12.hours)
      return live_data
    else
      return []
    end
  end

  private

  def self.fetch_data(url)
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    # Kitsu REQUIRES the JSON:API Accept header
    request['Accept'] = 'application/vnd.api+json'
    
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      parsed = JSON.parse(response.body)
      
      # Map Kitsu's JSON:API structure to the structure our View expects
      parsed["data"].map do |item|
        attrs = item["attributes"]
        {
          "title" => attrs["canonicalTitle"] || attrs["titles"]&.dig("en_jp"),
          "title_english" => attrs["titles"]&.dig("en"),
          "type" => attrs["subtype"]&.upcase,
          "aired" => { "from" => attrs["startDate"] },
          # ADDED URL HERE
          "url" => "https://kitsu.io/anime/#{item['id']}",
          # Kitsu image CDN is safe for hotlinking (no proxy needed)
          "images" => { "jpg" => { "image_url" => attrs.dig("posterImage", "medium") || attrs.dig("posterImage", "original") } }
        }
      end
    else
      Rails.logger.error "Kitsu API error: #{response.code}"
      []
    end
  rescue StandardError => e
    Rails.logger.error "Kitsu API failed: #{e.message}"
    []
  end

  # Fallback data using Kitsu's CDN (guaranteed to work)
  def self.fallback_data
    [
      {
        "title" => "Solo Leveling Season 2",
        "title_english" => "Solo Leveling Season 2",
        "type" => "TV",
        "aired" => { "from" => "2025-01-05T00:00:00Z" },
        "url" => "https://kitsu.io",
        "images" => { "jpg" => { "image_url" => "https://media.kitsu.io/anime/poster_images/44979/medium.jpg" } }
      },
      {
        "title" => "One Punch Man 3",
        "title_english" => "One Punch Man 3",
        "type" => "TV",
        "aired" => { "from" => "2025-10-01T00:00:00Z" },
        "url" => "https://kitsu.io",
        "images" => { "jpg" => { "image_url" => "https://media.kitsu.io/anime/poster_images/41287/medium.jpg" } }
      },
      {
        "title" => "Chainsaw Man Movie",
        "title_english" => "Chainsaw Man - The Movie: Reze Arc",
        "type" => "Movie",
        "aired" => { "from" => "2025-09-19T00:00:00Z" },
        "url" => "https://kitsu.io",
        "images" => { "jpg" => { "image_url" => "https://media.kitsu.io/anime/poster_images/43167/medium.jpg" } }
      }
    ]
  end
end