class AddSkillIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :skill_id, :integer
  end
end
