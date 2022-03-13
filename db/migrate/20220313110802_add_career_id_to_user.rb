class AddCareerIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :career_id, :integer
  end
end
