class AddProfileColumnsToUser < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :username, :string
    add_column :users, :display_name, :string
    add_column :users, :bio, :text
    add_column :users, :avatar_data, :text

    # Backfill existing users so username can be NOT NULL
    User.reset_column_information
    User.find_each do |user|
      base = user.email_address.split("@").first.gsub(/[^a-zA-Z0-9_]/, "")
      base = "user" if base.blank?
      name = base
      n = 0
      name = "#{base}#{n += 1}" while User.exists?(username: name)
      user.update_columns(username: name, display_name: base)
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
    remove_column :users, :display_name
    remove_column :users, :bio
    remove_column :users, :avatar_data
  end
end
