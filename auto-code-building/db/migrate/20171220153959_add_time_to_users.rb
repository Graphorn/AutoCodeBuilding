class AddTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_login, :string
    add_column :users, :projects_num, :string
    add_column :users, :buildinfos_num, :string
  end
end
