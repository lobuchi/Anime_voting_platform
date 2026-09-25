class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :anime

  validates :content, presence: true
    scope :recent, -> { order(created_at: :desc) }   # ← add this

end
