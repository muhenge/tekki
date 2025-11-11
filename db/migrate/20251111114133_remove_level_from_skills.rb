class RemoveLevelFromSkills < ActiveRecord::Migration[8.0]
  def change
    remove_column :skills, :level, :string
  end
end
