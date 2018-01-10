class AddImgurlToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :imgurl, :string
  end
end
