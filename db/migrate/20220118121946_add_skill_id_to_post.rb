class AddSkillIdToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :skill_id, :integer
  end
end
