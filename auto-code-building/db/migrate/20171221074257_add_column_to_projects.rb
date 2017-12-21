class AddColumnToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :user_name, :string
    add_column :projects, :buildinfo_num, :string
  end
end
