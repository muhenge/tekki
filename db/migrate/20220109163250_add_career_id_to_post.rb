class AddCareerIdToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :career_id, :integer
  end
end
