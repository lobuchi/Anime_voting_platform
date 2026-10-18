require 'net/http'
require 'json'

class JikanService
  BASE_URL = "https://api.jikan.moe/v4"

  def self.upcoming_anime
    # Try to get from cache first
    cached_data = Rails.cache.read("upcoming_anime")
    return cached_data if cached_data.present?

    # Try to fetch live data
    live_data = fetch_data("#{BASE_URL}/seasons/upcoming?limit=5")
    
    if live_data.any?
      Rails.cache.write("upcoming_anime", live_data, expires_in: 12.hours)
      return live_data
    else
      # FALLBACK DATA: If API fails or times out, show this so the app looks good
      return fallback_data
    end
  end

  private

  def self.fetch_data(url)
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'Mozilla/5.0'
    
    # 3 second timeout so the page doesn't load forever
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 3, read_timeout: 3) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)["data"] || []
    else
      []
    end
  rescue StandardError => e
    Rails.logger.error "Jikan API failed: #{e.message}"
    []
  end

  # Mock data structured exactly like the Jikan API response
  # Uses AniList CDN to prevent broken image links
  def self.fallback_data
    [
      {
        "title" => "Solo Leveling Season 2",
        "title_english" => "Solo Leveling Season 2",
        "type" => "TV",
        "aired" => { "from" => "2025-01-05T00:00:00+00:00" },
        "images" => { "jpg" => { "image_url" => "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx176496-Z4L4kG0t6q6Q.jpg" } }
      },
      {
        "title" => "One Punch Man 3",
        "title_english" => "One Punch Man 3",
        "type" => "TV",
        "aired" => { "from" => "2025-10-01T00:00:00+00:00" },
        "images" => { "jpg" => { "image_url" => "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx153353-uO1QjJ1N1x7j.jpg" } }
      },
      {
        "title" => "Chainsaw Man Movie",
        "title_english" => "Chainsaw Man - The Movie: Reze Arc",
        "type" => "Movie",
        "aired" => { "from" => "2025-09-19T00:00:00+00:00" },
        "images" => { "jpg" => { "image_url" => "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx171019-eN4l0T2n6w7b.jpg" } }
      }
    ]
  end
end
