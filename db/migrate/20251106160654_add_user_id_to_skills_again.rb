class AddUserIdToSkillsAgain < ActiveRecord::Migration[8.0]
  def change
    add_reference :skills, :user, foreign_key: true
  end
end