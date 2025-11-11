class AddAboutColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :about, :string
  end
end
