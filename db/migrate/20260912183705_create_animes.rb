class CreateAnimes < ActiveRecord::Migration[8.0]
  def change
    create_table :animes do |t|
      t.string :title
      t.string :image_url
      t.string :trailer_url
      t.integer :score

      t.timestamps
    end
  end
end
