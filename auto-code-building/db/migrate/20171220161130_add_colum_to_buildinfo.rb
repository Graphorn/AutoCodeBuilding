class AddColumToBuildinfo < ActiveRecord::Migration[5.1]
  def change
    add_column :buildinfos, :author, :string
    add_column :buildinfos, :user_name, :string
    add_column :buildinfos, :log, :string
    add_column :buildinfos, :branch, :string
    add_column :buildinfos, :commit_url, :string
    add_column :buildinfos, :commmit_msg, :string
    add_column :buildinfos, :build_time, :string
    add_column :buildinfos, :build_status, :string
  end
end
