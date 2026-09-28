class CreateWatchStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :watch_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :anime, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end

    add_index :watch_statuses, [:user_id,:anime_id], unique: true
  end
end
