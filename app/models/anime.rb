class Anime < ApplicationRecord
  # Associations
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :watch_statuses, dependent: :destroy

  # Virtual attribute to hold the uploaded file from the form
  attr_accessor :image_file

  # Enum for airing status — prefix avoids method-name conflicts
  enum :airing_status, {
    airing:    "airing",
    completed: "completed"
  }, default: "completed", prefix: true

  # Validations
  validates :title, presence: true
  validate :image_file_presence
  validate :image_file_size

  # Encode uploaded image to Base64 before saving
  before_save :encode_image, if: -> { image_file.present? }

  # Helpers — use the raw attribute, no reliance on generated predicates
  def airing_status_label
    airing_status == "airing" ? "Airing" : "Completed"
  end

  def airing_status_classes
    airing_status == "airing" ? "bg-green-100 text-green-800 border-green-300" : "bg-blue-100 text-blue-800 border-blue-300"
  end

  def calculate_rank
    votes.sum(:value)
  end

  def update_score!
    update(score: calculate_rank)
  end


  def airing_status_style
    if airing_status == "airing"
      "background: #dcfce7; color: #166534; border: 1px solid #86efac;"
    else
      "background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd;"
    end
  end
  private

  def encode_image
    file = image_file
    base64_string = Base64.strict_encode64(file.read)
    self.image_data = "data:#{file.content_type};base64,#{base64_string}"
  end

  def image_file_presence
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
