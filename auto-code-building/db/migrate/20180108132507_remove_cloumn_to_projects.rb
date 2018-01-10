class RemoveCloumnToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :users, :string
  end
end
