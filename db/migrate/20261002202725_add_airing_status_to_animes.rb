class AddAiringStatusToAnimes < ActiveRecord::Migration[8.0]
  def up
    add_column :animes, :airing_status, :string, null: false, default: "completed"

    # Backfill: everything before today is "completed"
    Anime.reset_column_information
    Anime.update_all(airing_status: "completed")

    add_index :animes, :airing_status
  end

  def down
    remove_index :animes, :airing_status
    remove_column :animes, :airing_status
  end
end
