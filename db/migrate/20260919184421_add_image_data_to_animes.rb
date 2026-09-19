class AddImageDataToAnimes < ActiveRecord::Migration[8.0]
  def change
    add_column :animes, :image_data, :text
  end
end
