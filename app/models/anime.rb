class Anime < ApplicationRecord
  has_one_attached :image
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :image, presence: true

  def calculate_rank
    votes.sum(:value)
  end

  def update_score!
    update(score: calculate_rank)
  end


  def image_size
    if image.attached? && image.blob.byte_size > 1.megabyte
      errors.add(:image, "must be less than 1MB")
    end
  end

end
