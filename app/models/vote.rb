class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :anime

  validates :user_id, uniqueness: { scope: :anime_id, message: "has already voted on this anime" }
  validates :value, presence: true, inclusion: { in: [-1, 1] }

  after_save :update_anime_score
  after_destroy :update_anime_score

  private

  def update_anime_score
    anime.update_score!
  end
end
