class RemoveColumnToBuildinfos < ActiveRecord::Migration[5.1]
  def change
    remove_column :buildinfos, :log, :string
  end
end
