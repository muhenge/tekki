class AddIndexesToSkills < ActiveRecord::Migration[8.0]
  def change
    add_index :skills, :user_id
    add_index :skills, :level
  end
end
