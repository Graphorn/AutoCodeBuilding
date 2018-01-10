class DelColumnToProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :user_name, :string
  end
end
