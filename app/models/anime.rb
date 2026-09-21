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
end
