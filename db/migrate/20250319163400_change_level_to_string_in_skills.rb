class ChangeLevelToStringInSkills < ActiveRecord::Migration[8.0]
  def change
    change_column :skills, :level, :string
  end
end
