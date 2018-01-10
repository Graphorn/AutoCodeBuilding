class AddProjectsToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :buildinfo_num, :string
    add_column :projects, :buildinfo_num_all, :string
    add_column :users, :projects, :string
    add_column :users, :name, :string
  end
end
