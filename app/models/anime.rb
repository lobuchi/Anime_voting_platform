class Anime < ApplicationRecord
  # REMOVED: has_one_attached :image (no more Active Storage/Cloudinary/Supabase)
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :watch_status, dependent: :destroy
  # Virtual attribute to hold the uploaded file from the form
  attr_accessor :image_file

  validates :title, presence: true

  # Validate the file is present AND under the size limit
  validate :image_file_presence
  validate :image_file_size

  # Before saving, encode the uploaded file into Base64
  before_save :encode_image, if: -> { image_file.present? }

  def calculate_rank
    votes.sum(:value)
  end

  def update_score!
    update(score: calculate_rank)
  end

  private

  def encode_image
    file = image_file
    base64_string = Base64.strict_encode64(file.read)
    self.image_data = "data:#{file.content_type};base64,#{base64_string}"
  end

  def image_file_presence
    # Only require an image if we don't already have one stored
    if image_file.blank? && image_data.blank?
      errors.add(:image_file, "must be uploaded")
    end
  end

  def image_file_size
    if image_file.present? && image_file.size > 1.megabyte
      errors.add(:image_file, "must be less than 1MB")
    end
  end
end
