class AddUserSlugToSkill < ActiveRecord::Migration[6.1]
  def change
    add_column :skills, :user_slug, :string
  end
end
