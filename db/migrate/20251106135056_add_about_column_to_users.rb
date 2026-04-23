class AddAboutColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :about, :string unless column_exists?(:users, :about)
  end
end
