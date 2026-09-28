class WatchStatus < ApplicationRecord
  belongs_to :user
  belongs_to :anime

  enum :status, {
    watching: "watching",
    completed: "completed",
    on_hold: "on hold",
    dropped: "dropped",
    plan_to_watch: "plan to watch"
  
  }
  validates :user_id, uniqueness: { scope: :anime_id, message: "already has a status for this anime" }

  # Human-friendly label
  def label
    status.titleize
  end

  # Tailwind color per status
  def color_classes
    case status
    when "watching"      then "bg-blue-100 text-blue-800 border-blue-300"
    when "completed"     then "bg-green-100 text-green-800 border-green-300"
    when "on_hold"       then "bg-yellow-100 text-yellow-800 border-yellow-300"
    when "dropped"       then "bg-red-100 text-red-800 border-red-300"
    when "plan_to_watch" then "bg-gray-100 text-gray-700 border-gray-300"
    else "bg-gray-100 text-gray-700 border-gray-300"
    end
  end
end
