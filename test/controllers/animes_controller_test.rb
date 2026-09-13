require "test_helper"

class AnimesControllerTest < ActionDispatch::IntegrationTest
  test "creating an anime saves its description" do
    user = User.create!(email_address: "admin@example.com", password: "password123")

    post session_path, params: {
      email_address: user.email_address,
      password: "password123"
    }

    assert_response :redirect

    image = Rack::Test::UploadedFile.new(
      StringIO.new("fake-image"),
      "image/png",
      true,
      original_filename: "anime.png"
    )

    post animes_path, params: {
      anime: {
        title: "Fullmetal Alchemist",
        description: "A story about brothers and alchemy.",
        trailer_url: "https://www.youtube.com/watch?v=example",
        image: image
      }
    }

    assert_response :redirect
    anime = Anime.order(:created_at).last
    assert_equal "Fullmetal Alchemist", anime.title
    assert_equal "A story about brothers and alchemy.", anime.description
  end
end
