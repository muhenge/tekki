class AddUserIdToSkillsAgain < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:skills, :user_id)
      add_index :skills, :user_id unless index_exists?(:skills, :user_id)
    else
      add_reference :skills, :user, foreign_key: true
    end
  end
end