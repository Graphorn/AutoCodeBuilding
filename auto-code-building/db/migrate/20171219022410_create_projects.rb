class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :author
      t.string :project_name
      t.string :project_url
      t.timestamps
    end
  end
end
