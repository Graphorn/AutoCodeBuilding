class CreateBuildinfos < ActiveRecord::Migration[5.1]
  def change
    create_table :buildinfos do |t|
      t.string :project
      t.string :loginfo
      t.timestamps
    end
  end
end
