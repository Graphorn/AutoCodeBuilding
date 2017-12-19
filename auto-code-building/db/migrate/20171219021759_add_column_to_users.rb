class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :userid, :string
    remove_column :users, :name, :string
    add_column :users, :user_type, :string
    add_column :users, :user_name, :string
    add_column :users, :pwd, :string
  end
end
