class AddDescriptionToAnimes < ActiveRecord::Migration[8.0]
  def change
    add_column :animes, :description, :text
  end
end
